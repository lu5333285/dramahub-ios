import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/cbc.dart';
import 'package:pointycastle/api.dart';

/// 真实网关 —— 原 APK 运行时下发的 CloudFront 域名（APK 内硬编码的域名已全部失效）
class Gateway {
  Gateway._();

  /// 按优先级排列（实测均有效，第一个为主用）
  static const List<String> hosts = <String>[
    'https://d1c8gaa71p5xoi.cloudfront.net',
    'https://d1hf8gfq4fjqma.cloudfront.net',
  ];

  /// 分片服务对 UA 有校验，与原 app（okhttp）保持一致
  static const String userAgent = 'okhttp/4.9.3';

  /// m3u8 分片 AES 密钥接口（无需鉴权，返回 16 字节原始 key）
  static const String keyPath = '/api/app/vid/sec';
}

/// 本地 HLS 解密代理 —— 复刻原 app 的播放链路：
///
/// 原 app：ExoPlayer 播 [签名 m3u8]，分片 AES-128-CBC（IV 全 0）加密，
/// 密钥来自 /api/app/vid/sec；因 IV 非标准（HLS 规范用 media sequence 当 IV），
/// AVPlayer 直接播放会解错，故走本地代理逐片解密。
///
/// 流程：AVPlayer → http://127.0.0.1:port/play/<id>/index.m3u8
///   → 代理拉真实 m3u8，去掉 EXT-X-KEY，分片改写为 /play/<id>/seg/<n>.ts
///   → 代理逐片下载（UA=okhttp）→ AES-CBC(IV=0) 解密 → 明文 MPEG-TS
class HlsProxy {
  HlsProxy._();
  static final HlsProxy instance = HlsProxy._();

  HttpServer? _server;
  int _seq = 0;
  final Map<int, String> _playlists = <int, String>{};
  final Map<int, String> _keyUris = <int, String>{};
  final Map<String, Uint8List> _keys = <String, Uint8List>{};
  final Map<String, String> _segments = <String, String>{};
  final HttpClient _http = HttpClient()
    ..userAgent = Gateway.userAgent
    ..connectionTimeout = const Duration(seconds: 15);

  bool get _ready => _server != null;

  /// 注册一个远程 m3u8，返回本地可播地址
  Future<String> register(String remoteM3u8) async {
    if (!_ready) await _bind();
    final id = _seq++;
    _playlists[id] = remoteM3u8;
    return 'http://127.0.0.1:${_server!.port}/play/$id/index.m3u8';
  }

  Future<void> _bind() async {
    final s = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server = s;
    s.listen(_handle, onError: (Object e) => debugPrint('[HlsProxy] $e'));
    debugPrint('[HlsProxy] listening on 127.0.0.1:${s.port}');
  }

  Future<void> _handle(HttpRequest req) async {
    try {
      final path = req.uri.path;
      final m =
          RegExp(r'^/play/(\d+)/index\.m3u8$').firstMatch(path) ??
              RegExp(r'^/play/(\d+)/seg/(\d+)\.ts$').firstMatch(path);
      if (m == null) {
        req.response.statusCode = 404;
        await req.response.close();
        return;
      }
      final id = int.parse(m.group(1)!);
      if (path.endsWith('.m3u8')) {
        final body = await _playlist(id);
        if (body == null) {
          req.response.statusCode = 502;
          await req.response.close();
          return;
        }
        req.response.headers.contentType =
            ContentType('application', 'vnd.apple.mpegurl', charset: 'utf-8');
        req.response.headers.set('Access-Control-Allow-Origin', '*');
        req.response.write(body);
        await req.response.close();
      } else {
        final idx = int.parse(m.group(2)!);
        final segUrl = _segments['$id-$idx'];
        if (segUrl == null) {
          req.response.statusCode = 404;
          await req.response.close();
          return;
        }
        final ts = await _segment(id, segUrl);
        if (ts == null) {
          req.response.statusCode = 502;
          await req.response.close();
          return;
        }
        req.response.headers.contentType =
            ContentType('video', 'mp2t');
        req.response.headers.contentLength = ts.length;
        req.response.add(ts);
        await req.response.close();
      }
    } catch (e) {
      debugPrint('[HlsProxy] handle error: $e');
      try {
        req.response.statusCode = 500;
        await req.response.close();
      } catch (_) {}
    }
  }

  /// 拉真实 m3u8 并改写
  Future<String?> _playlist(int id) async {
    final remote = _playlists[id];
    if (remote == null) return null;
    final text = await _getText(_withHosts(remote));
    if (text == null) return null;

    final buf = StringBuffer();
    var i = 0;
    for (var raw in text.split('\n')) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      if (line.startsWith('#EXT-X-KEY')) {
        // 解析密钥 URI（每批播放列表可能不同：实测有 /vid/sec 与 /vid/m3u8sec 两种）
        final km = RegExp(r'URI="([^"]+)"').firstMatch(line);
        if (km != null) {
          _keyUris[id] = _resolve(remote, km.group(1)!);
        }
        continue; // 代理内解密，AVPlayer 不再需要该行
      }
      if (line.startsWith('#')) {
        buf.writeln(line);
        continue;
      }
      // 分片行：记录原始 URL，改写为本地地址
      final segUrl = line.startsWith('http') ? line : _resolve(remote, line);
      _segments['$id-$i'] = segUrl;
      buf.writeln('/play/$id/seg/$i.ts');
      i++;
    }
    return buf.toString();
  }

  String _resolve(String base, String rel) {
    final u = Uri.parse(base);
    return u.resolve(rel).toString();
  }

  /// 主域失败时逐个换备用域重试
  List<String> _withHosts(String url) {
    if (!url.startsWith('http')) return <String>[url];
    final out = <String>[url];
    final u = Uri.parse(url);
    for (final h in Gateway.hosts) {
      final alt = u.replace(host: Uri.parse(h).host).toString();
      if (alt != url) out.add(alt);
    }
    return out;
  }

  Future<String?> _getText(List<String> urls) async {
    for (final u in urls) {
      try {
        final rs = await _http.getUrl(Uri.parse(u));
        final resp = await rs.close();
        if (resp.statusCode != 200) continue;
        return await resp.transform(utf8.decoder).join();
      } catch (e) {
        debugPrint('[HlsProxy] get $u -> $e');
      }
    }
    return null;
  }

  Future<Uint8List?> _getBytes(String url) async {
    try {
      final rs = await _http.getUrl(Uri.parse(url));
      final resp = await rs.close();
      if (resp.statusCode != 200) return null;
      final builder = BytesBuilder(copy: false);
      await for (final chunk in resp) {
        builder.add(chunk);
      }
      return builder.takeBytes();
    } catch (e) {
      debugPrint('[HlsProxy] bytes $url -> $e');
      return null;
    }
  }

  /// 拉取分片并解密为明文 TS
  Future<Uint8List?> _segment(int id, String url) async {
    final keyUri = _keyUris[id];
    Uint8List? key;
    if (keyUri == null) {
      // 无 KEY 行 → 明文 HLS，原样透传
      return _getBytes(url);
    }
    key = _keys[keyUri];
    if (key == null) {
      // 密钥按播放列表里声明的 URI 动态获取，失败再回落 /vid/sec
      key = await _fetchKey(keyUri);
      key ??= await _fetchKey(Gateway.hosts.first + Gateway.keyPath);
      if (key == null) return null;
      _keys[keyUri] = key;
    }
    var enc = await _getBytes(url);
    if (enc == null) {
      final alts = _withHosts(url).skip(1).toList();
      for (final a in alts) {
        enc = await _getBytes(a);
        if (enc != null) break;
      }
    }
    if (enc == null) return null;
    return _decrypt(key, enc);
  }

  Future<Uint8List?> _fetchKey(String uri) async {
    for (final u in _withHosts(uri)) {
      final k = await _getBytes(u);
      if (k != null && k.length == 16) {
        debugPrint('[HlsProxy] key ok ($u): ${k.take(4).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}');
        return k;
      }
    }
    return null;
  }

  /// AES-128-CBC，IV 全 0（原 app 服务端行为，已验证：解密后首字节 0x47、188 对齐全同步）
  Uint8List _decrypt(Uint8List key, Uint8List enc) {
    final n = enc.length - enc.length % 16;
    final data = Uint8List.sublistView(enc, 0, n);
    final iv = Uint8List(16);
    final cbc = CBCBlockCipher(AESEngine())
      ..init(false, ParametersWithIV<KeyParameter>(KeyParameter(key), iv));
    final out = Uint8List(n);
    for (var off = 0; off < n; off += 16) {
      cbc.processBlock(data, off, out, off);
    }
    return out;
  }
}
