import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'config/config.dart';
import 'hj_page/root_page.dart';
import 'hj_page/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const LldjApp());
}

class LldjApp extends StatelessWidget {
  const LldjApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => GetMaterialApp(
        title: Config.appName,
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const SplashPage()),
          GetPage(name: '/root', page: () => const RootPage(), transition: Transition.fadeIn),
        ],
        defaultTransition: Transition.cupertino,
        transitionDuration: Config.pageDuration,
        unknownRoute: GetPage(name: '/404', page: () => const NotFoundPage()),
      ),
    );
  }

  ThemeData _buildTheme() {
    const seed = Color(0xFFFF2D55);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: seed),
      scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFFEEEEEE), thickness: .5),
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/images/common/ic_nodata.webp', width: 120.w, height: 120.w),
            SizedBox(height: 16.w),
            const Text('页面不存在'),
          ],
        ),
      ),
    );
  }
}