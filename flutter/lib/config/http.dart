import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api.dart';
import 'config.dart';

/// 网络客户端 —— 对应原 APK 的 Dio 封装
/// 带域名管理器（多域名容灾）、失败自动重试、登录态注入
class HttpClient {
  HttpClient._();
  static final HttpClient instance = HttpClient._();

  late final Dio _dio = Dio(BaseOptions(
        baseUrl: Address.main,
        connectTimeout: Config.timeout,
        receiveTimeout: Config.timeout,
        headers: {
          'User-Agent': 'okhttp/4.9.3',
          'Accept': 'application/json',
        },
        contentType: Headers.jsonContentType,
      ));

  /// 当前生效域名（域名管理器状态）
  static String _current = Address.main;
  static String get currentDomain => _current;

  /// 请求统计
  int _seq = 0;

  Dio get raw => _dio;

  /// 登录态
  static String? token;
  static Map<String, String> get _headers => <String, String>{
        if (token != null) 'Authorization': 'Bearer $token',
        'X-Seq': (++_seq).toString(),
      };

  /// 切换域名（域名管理器逻辑）
  static void switchDomain() {
    final i = Address.all.indexOf(_current);
    _current = Address.all[(i + 1) % Address.all.length];
    _dio.options.baseUrl = _current;
    debugPrint('[DomainManager] 已重置到 $_current');
  }

  Future<Map<String, dynamic>> _run(
    String method,
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    bool retry = true,
  }) async {
    try {
      final res = await _dio.request(
        path,
        data: data,
        queryParameters: query,
        options: Options(method: method, headers: _headers),
      );
      final body = res.data;
      if (body is Map) return Map<String, dynamic>.from(body);
      return <String, dynamic>{'data': body};
    } catch (e) {
      if (retry) {
        // 使用缓存域名降级后重试一次
        switchDomain();
        return _run(method, path, data: data, query: query, retry: false);
      }
      debugPrint('[Http] $method $path 失败: $e');
      return <String, dynamic>{'code': -1, 'msg': '连接超时'};
    }
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query}) =>
      _run('GET', path, query: query);

  Future<Map<String, dynamic>> post(String path, {Object? data, Map<String, dynamic>? query}) =>
      _run('POST', path, data: data, query: query);

  Future<Map<String, dynamic>> delete(String path, {Map<String, dynamic>? query}) =>
      _run('DELETE', path, query: query);
}

/// 业务层封装：把裸 JSON 变成列表 / 详情
class Repo {
  Repo._();
  static final Repo instance = Repo._();

  /// 统一解包：原 app 后端返回 {code, msg, data}
  static dynamic _unwrap(Map<String, dynamic> raw) {
    if (raw.containsKey('data')) return raw['data'];
    if (raw.containsKey('list')) return raw['list'];
    if (raw.containsKey('items')) return raw['items'];
    return raw;
  }

  /// 取列表（自动识别分页字段）
  static List<Map<String, dynamic>> asList(dynamic data) {
    if (data is List) {
      return data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    if (data is Map) {
      for (final k in <String>['list', 'items', 'data', 'records', 'rows', 'result']) {
        final v = data[k];
        if (v is List) {
          return v.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
        }
      }
    }
    return <Map<String, dynamic>>[];
  }

  /// 通用列表请求
  static Future<List<Map<String, dynamic>>> list(
    String path, {
    Map<String, dynamic>? query,
    int page = 1,
    int size = Config.pageSize,
  }) async {
    final raw = await HttpClient.instance.get(path, query: <String, dynamic>{
      ...?query,
      'page': page,
      'size': size,
      'page_size': size,
    });
    if (Config.useMock) return <Map<String, dynamic>>[];
    return asList(_unwrap(raw));
  }

  /// 通用详情请求
  static Future<Map<String, dynamic>> detail(String path,
      {Map<String, dynamic>? query}) async {
    final raw = await HttpClient.instance.get(path, query: query);
    final d = _unwrap(raw);
    if (d is Map) return Map<String, dynamic>.from(d);
    return <String, dynamic>{};
  }
}

/// JSON 工具（补齐原 app 的 safe 解析习惯）
extension JsonSafe on Map<String, dynamic> {
  String str(String k, [String def = '']) {
    final v = this[k];
    if (v == null) return def;
    return v.toString();
  }

  int num_(String k, [int def = 0]) {
    final v = this[k];
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? def;
    return def;
  }

  double dbl(String k, [double def = 0]) {
    final v = this[k];
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? def;
    return def;
  }

  List<Map<String, dynamic>> mapList(String k) {
    final v = this[k];
    if (v is List) {
      return v.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return <Map<String, dynamic>>[];
  }

  Map<String, dynamic> obj(String k) {
    final v = this[k];
    if (v is Map) return Map<String, dynamic>.from(v);
    return <String, dynamic>{};
  }
}