import '../hj_model/models.dart';

/// 本地片库 —— 降级数据源
///
/// 接口链路（域名发现 / AES 响应解密 / JWT 登录态）尚未完全打通前，
/// 使用从原 app 实机收割的已签名播放地址（harvest/library.json，
/// 2026-10-19 采集，密钥与签名分片当日实测仍有效）。
class LocalLibrary {
  LocalLibrary._();

  /// 与原 APK 相同的片源：JHA-134（3 个已签名集）
  static const List<Map<String, String>> _seed = <Map<String, String>>[
    <String, String>{
      'drama': 'JHA-134',
      'episode': 'ld3JQPTihyyDdfYr8VvLwOmF',
      'm3u8':
          'https://d1c8gaa71p5xoi.cloudfront.net/api/app/vid/h5/m3u8/JHA-134/tk1/ld3JQPTihyyDdfYr8VvLwOmFgWRi4ySv4xsd4rL6ViLAErYLFLSlqVp2nXtSK0qhKLDO55jHp_XkAYTOJxLZ3liujuoQxxG28dAsb-FLOBl1slFbo2eKKiu4pZM.m3u8?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0aW1lc3RhbXAiOjE3OTIzNzg2MTAxOTMzNzk2MDAsInR5cGUiOjAsInVpZCI6MTQ0NzA5MH0.9R-6NSCRqRD1YMAye4btQjFEJ5imrhUTSmhd00t1s1Y&c=https://sjljsla.lkkwip.cn',
    },
    <String, String>{
      'drama': 'JHA-134',
      'episode': 'Oacnhy5bdWUWbCCekh5pivBY',
      'm3u8':
          'https://d1c8gaa71p5xoi.cloudfront.net/api/app/vid/h5/m3u8/JHA-134/tk1/Oacnhy5bdWUWbCCekh5pivBYT9kdYTZV-382zzkHr_a33chjJgPrgNBNHoU5oeT6bC1kqZn5n-zUpGWszWxnzLFxZGar2NXZWAsujEVhdALUDOs9ijU1_osA0xk.m3u8?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0aW1lc3RhbXAiOjE3OTIzNzg2MTAxOTMzNzk2MDAsInR5cGUiOjAsInVpZCI6MTQ0NzA5MH0.9R-6NSCRqRD1YMAye4btQjFEJ5imrhUTSmhd00t1s1Y&c=https://sjljsla.lkkwip.cn',
    },
    <String, String>{
      'drama': 'JHA-134',
      'episode': 'JWzB7RNnFJytI52DW-QqWtXX',
      'm3u8':
          'https://d1c8gaa71p5xoi.cloudfront.net/api/app/vid/h5/m3u8/JHA-134/tk1/JWzB7RNnFJytI52DW-QqWtXXs0bgOCJCluTgT-uDjphZqOjOzmQt_tJGKy7iRkpI1s0j5fSxDmeL3OBtQup25TgDwP8jd8FmOldGnf6GUI3WbrERcpAVL6BKcN8.m3u8?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0aW1lc3RhbXAiOjE3OTIzNzg2MTAxOTMzNzk2MDAsInR5cGUiOjAsInVpZCI6MTQ0NzA5MH0.9R-6NSCRqRD1YMAye4btQjFEJ5imrhUTSmhd00t1s1Y&c=https://sjljsla.lkkwip.cn',
    },
  ];

  /// 首页兜底数据（接口失败/为空时展示）
  static List<Drama> dramas() => const <Drama>[
        Drama(
          id: 134,
          title: 'JHA-134',
          cover: '',
          desc: '本地片库 · 已签名直连',
        ),
      ];

  /// 按 剧目ID/标题 匹配播放地址；无匹配时返回第一条（保证可播）
  static String lookup(String idOrTitle) {
    for (final e in _seed) {
      if (idOrTitle.contains(e['drama']!) || e['drama']!.contains(idOrTitle)) {
        return e['m3u8']!;
      }
    }
    return _seed.isEmpty ? '' : _seed.first['m3u8']!;
  }
}
