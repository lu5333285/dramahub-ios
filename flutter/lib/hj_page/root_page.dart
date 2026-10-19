import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../config/config.dart';
import 'acg/acg_page.dart';
import 'community/community_page.dart';
import 'home/home_page.dart';
import 'mine/mine_page.dart';
import 'rank/rank_page.dart';

/// 主框架 —— 底部 5 Tab，与原 APK 一致（首页 / 榜单 / 漫画 / 社区 / 我的）
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _index = 0;

  final List<Widget> _pages = <Widget>[
    const HomePage(),
    const RankPage(),
    const AcgPage(),
    const CommunityPage(),
    const MinePage(),
  ];

  static const List<String> _titles = <String>['首页', '榜单', '漫画', '社区', '我的'];
  static const List<IconData> _icons = <IconData>[
    Icons.home_outlined,
    Icons.emoji_events_outlined,
    Icons.auto_stories_outlined,
    Icons.forum_outlined,
    Icons.person_outline,
  ];
  static const List<IconData> _activeIcons = <IconData>[
    Icons.home,
    Icons.emoji_events,
    Icons.auto_stories,
    Icons.forum,
    Icons.person,
  ];

  void _onTap(int i) {
    if (i == _index) return;
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF12101A),
        child: Stack(
          children: <Widget>[
            Positioned.fill(child: _pages[_index]),
            // 沉浸式状态栏遮罩（首页有深色头图）
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).padding.top,
              child: _index == 0
                  ? const ColoredBox(color: Color(0x66000000))
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: .5)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 54.w,
            child: Row(
              children: List<Widget>.generate(_pages.length, (i) {
                final active = i == _index;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onTap(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          active ? _activeIcons[i] : _icons[i],
                          size: 22.w,
                          color: active ? const Color(0xFFFF2D55) : const Color(0xFF9A9AA0),
                        ),
                        SizedBox(height: 2.w),
                        Text(
                          _titles[i],
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: active ? const Color(0xFFFF2D55) : const Color(0xFF9A9AA0),
                            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

/// 统一的深色渐变头图（首页/详情页共用）
class GradientHeader extends StatelessWidget {
  const GradientHeader({
    super.key,
    required this.child,
    this.height = 240,
    this.colors = const <Color>[Color(0xFF2A2340), Color(0xFF12101A)],
  });

  final Widget child;
  final double height;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: SafeArea(bottom: false, child: child),
    );
  }
}

/// 空状态（使用原 ic_nodata 素材）
class EmptyView extends StatelessWidget {
  const EmptyView({super.key, this.text = '没有更多数据了', this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/images/common/ic_nodata.webp', width: 100.w, height: 100.w),
            SizedBox(height: 12.w),
            Text(text, style: TextStyle(color: Colors.white38, fontSize: 13.sp)),
            SizedBox(height: 12.w),
            if (onTap != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(16.w),
                ),
                child: Text('点击重试', style: TextStyle(color: Colors.white60, fontSize: 12.sp)),
              ),
          ],
        ),
      ),
    );
  }
}

/// 加载中
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});
  @override
  Widget build(BuildContext context) => const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white24),
        ),
      );
}

/// 全局通用色
class LLColors {
  LLColors._();
  static const Color primary = Color(0xFFFF2D55);
  static const Color gold = Color(0xFFFFC83D);
  static const Color bg = Color(0xFF12101A);
  static const Color card = Color(0xFF1C1926);
  static const Color sub = Color(0xFF6E6E78);
}