import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/api.dart';
import '../../config/config.dart';

/// 图片组件：网络图走缓存，失败回落到原 APK 自带的占位图
class LLImage extends StatelessWidget {
  const LLImage.url(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = 0,
    this.placeholder = 'assets/images/common/place_holder_video.png',
  });

  const LLImage.asset(
    this.asset, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = 0,
  })  : url = '',
        placeholder = '';

  final String url;
  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (url.isEmpty && asset.isEmpty) {
      child = _ph();
    } else if (url.isEmpty) {
      child = Image.asset(asset, width: width, height: height, fit: fit);
    } else {
      final abs = url.startsWith('http') ? url : '${Address.cdn}$url';
      child = CachedNetworkImage(
        imageUrl: abs,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 180),
        placeholder: (_, __) => _ph(),
        errorWidget: (_, __, ___) => _ph(),
      );
    }
    if (radius <= 0) return child;
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: child);
  }

  Widget _ph() {
    if (placeholder.isEmpty) {
      return Container(width: width, height: height, color: const Color(0xFF2A2735));
    }
    return Container(
      width: width,
      height: height,
      color: const Color(0xFF2A2735),
      alignment: Alignment.center,
      child: placeholder.isEmpty
          ? null
          : Image.asset(placeholder, fit: BoxFit.contain, width: (width ?? 40) * .5, height: (height ?? 40) * .5),
    );
  }
}

/// 原生 Image（用于 svg 之外的自有素材）
class LLAsset extends StatelessWidget {
  const LLAsset(this.asset, {super.key, this.width, this.height, this.fit = BoxFit.contain});
  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) =>
      Image.asset(asset, width: width, height: height, fit: fit);
}