import 'package:flutter/material.dart';

/// 全局配置 —— 对应原 APK 的 `config/config.dart` + `config/address.dart`
class Config {
  Config._();

  /// 是否使用 mock 数据（真实后端不可用时回退）
  static bool useMock = false;

  /// 是否开启调试日志（原 APK 带 analytics_sdk）
  static bool debug = false;

  /// 启动图淡入时长
  static const Duration splashDuration = Duration(milliseconds: 1800);

  /// 页面过渡动画时长
  static const Duration pageDuration = Duration(milliseconds: 260);

  /// 网络超时
  static const Duration timeout = Duration(seconds: 20);

  /// 分页大小
  static const int pageSize = 20;

  /// App 名称
  static const String appName = '鹿鹿短剧';
  static const String version = '2.4.0';
  static const String buildNo = 'V5';
}

/// 域名配置 —— 从 libapp.so 中提取的真实后端域名
class Address {
  Address._();

  /// 主 API
  static const String main = 'https://acg.imscc.cc';

  /// 备用 API 1
  static const String backup1 = 'https://awx2api.80sygtm.com';

  /// 备用 API 2
  static const String backup2 = 'https://api2.uszim.com';

  /// 短剧 / 官网
  static const String site = 'https://lldj.tv';

  /// IM 长连接
  static const String im = 'https://im.tapi.flowcd.cn';

  /// IM 配置下发
  static const String imConfig = 'https://imcfg.imscc.cc';

  /// CDN（图片 / 视频资源）
  static const String cdn = 'https://d1c8gaa71p5xoi.cloudfront.net';

  /// 备用 CDN
  static const String cdn2 = 'https://d1hf8gfq4fjqma.cloudfront.net';

  /// 备用 CDN 3
  static const String cdn3 = 'https://dpkv1s9xi3olr.cloudfront.net';

  /// 域名管理器失败时使用的降级域名
  static const String fallback = 'https://awx2.tianxiawudi007.com';

  /// 拉取域名列表
  static const String domainList = '/domain/list';

  /// 按优先级排列
  static const List<String> all = <String>[
    main,
    backup1,
    backup2,
    fallback,
  ];
}