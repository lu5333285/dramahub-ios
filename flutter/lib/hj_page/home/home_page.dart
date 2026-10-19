import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/config.dart';
import '../../config/http.dart';
import '../../hj_model/models.dart';
import '../../hj_utils/img.dart';
import '../root_page.dart';
import 'video_page.dart';



/// 首页 —— 使用真实接口 /media/recommend、/vid/home/new/list、/media/ranking
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 3, vsync: this);

  List<String> _sections = <String>['推荐', '短剧', '漫画'];
  List<Drama> _list = <Drama>[];
  bool _loading = true;
  int _page = 1;
  bool _hasMore = true;

  static const List<String> _apiByTab = <String>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _load({bool reset = false}) async {
    if (reset) {
      setState(() {
        _page = 1;
        _hasMore = true;
        _list = <Drama>[];
      });
    }
    setState(() => _loading = true);
    final repo = MediaRepo.instance;
    final data = switch (_tab.index) {
      0 => await repo.recommend(page: _page),
      1 => await repo.newList(page: _page),
      _ => (await repo.newList(page: _page)),
    };
    if (!mounted) return;
    setState(() {
      _list = reset ? data : <Drama>[..._list, ...data];
      _hasMore = data.length >= Config.pageSize;
      _loading = false;
      _page++;
    });
  }

  Future<void> _loadSections() async {
    final s = await MediaRepo.instance.sections();
    if (s.isNotEmpty && mounted) setState(() => _sections = <String>['推荐', ...s.take(6)]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _header(),
          _tabs(),
          Expanded(child: _body()),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 14.w, right: 10.w),
            child: Image.asset('assets/images/common/app_logo.png', width: 26.w, height: 26.w),
          ),
          Text('${Config.appName}',
              style: TextStyle(
                  fontSize: 17.sp, fontWeight: FontWeight.w700, color: const Color(0xFF16161A))),
          const Spacer(),
          _roundIcon('assets/images/home/home_search.png', () => Get.to(() => const SearchPage())),
          _roundIcon('assets/images/home/home_menu.png', () => _showMenu()),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }

  Widget _roundIcon(String asset, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 8.w),
          child: Image.asset(asset, width: 21.w, height: 21.w),
        ),
      );

  void _showMenu() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(vertical: 18.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <String>['每日签到领福利', '我的积分', '福利任务', '邀请好友', '官方联系方式']
              .map((e) => ListTile(
                    title: Text(e, style: TextStyle(fontSize: 14.sp)),
                    onTap: () => Get.back(),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _tabs() {
    return Container(
      color: Colors.white,
      height: 40.w,
      child: TabBar(
        controller: _tab,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: const Color(0xFF16161A),
        unselectedLabelColor: const Color(0xFF9A9AA0),
        indicatorColor: const Color(0xFFFF2D55),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 2.5,
        dividerColor: Colors.transparent,
        labelStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 15.sp),
        onTap: (i) => _load(reset: true),
        tabs: _sections.map((e) => Tab(text: e, height: 40.w)).toList(),
      ),
    );
  }

  Widget _body() {
    if (_loading && _list.isEmpty) return const LoadingView();
    if (_list.isEmpty) return const EmptyView(onTap: null);
    return RefreshIndicator(
      color: const Color(0xFFFF2D55),
      onRefresh: () => _load(reset: true),
      child: GridView.builder(
        padding: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 24.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.w,
          crossAxisSpacing: 8.w,
          childAspectRatio: .62,
        ),
        itemCount: _list.length + 1,
        itemBuilder: (context, i) {
          if (i >= _list.length) {
            return Center(child: Text('上拉加载更多', style: TextStyle(color: Colors.grey, fontSize: 12.sp)));
          }
          return _card(_list[i]);
        },
      ),
    );
  }

  Widget _card(Drama d) {
    return GestureDetector(
      onTap: () => Get.to(() => VideoPage(drama: d)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.w),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  LLImage.url(d.cover, radius: 8.w),
                  if (d.vip)
                    Positioned(
                      top: 6.w,
                      left: 6.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.w),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: <Color>[Color(0xFFFFC83D), Color(0xFFFF9500)]),
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                        child: Text('VIP',
                            style: TextStyle(fontSize: 9.sp, color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  Positioned(
                    right: 6.w,
                    bottom: 6.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .55),
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      child: Text(_dur(d.duration),
                          style: TextStyle(fontSize: 9.sp, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5.w),
          Text(d.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.5.sp, color: const Color(0xFF16161A), fontWeight: FontWeight.w500)),
          SizedBox(height: 2.w),
          Row(
            children: <Widget>[
              if (d.heat > 0)
                Text('🔥 ${_wan(d.heat)}',
                    style: TextStyle(fontSize: 10.sp, color: const Color(0xFF9A9AA0))),
              if (d.heat > 0 && d.views > 0) SizedBox(width: 8.w),
              if (d.views > 0)
                Text('👁 ${_wan(d.views)}',
                    style: TextStyle(fontSize: 10.sp, color: const Color(0xFF9A9AA0))),
            ],
          ),
        ],
      ),
    );
  }

  static String _dur(int s) {
    if (s <= 0) return '00:00';
    final m = s ~/ 60;
    final ss = s % 60;
    return '${m.toString().padLeft(2, '0')}:${ss.toString().padLeft(2, '0')}';
  }

  static String _wan(int n) {
    if (n >= 10000) return '${(n / 10000).toStringAsFixed(1)}万';
    return '$n';
  }
}