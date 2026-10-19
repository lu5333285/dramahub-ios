import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../config/config.dart';

/// 启动页 —— 使用原 APK 的 launch 素材
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  late final Animation<double> _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();
    _c.forward();
    Future.delayed(Config.splashDuration, () {
      if (mounted) Get.offAllNamed('/root');
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12101A),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFF1E1A2E), Color(0xFF12101A)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeTransition(
              opacity: _fade,
              child: Column(
                children: <Widget>[
                  Image.asset('assets/images/common/app_main_logo.png',
                      width: 96.w, height: 96.w, fit: BoxFit.contain),
                  SizedBox(height: 18.w),
                  Image.asset('assets/images/common/app_wordmark_lldj.png',
                      width: 128.w, fit: BoxFit.contain),
                ],
              ),
            ),
            SizedBox(height: 60.w),
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white24),
            ),
            SizedBox(height: 80.w),
            Text('${Config.version} (${Config.buildNo})',
                style: TextStyle(color: Colors.white24, fontSize: 11.sp)),
          ],
        ),
      ),
    );
  }
}