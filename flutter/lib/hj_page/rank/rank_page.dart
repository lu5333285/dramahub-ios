import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../hj_model/models.dart';
import '../../hj_utils/img.dart';
import '../home/video_page.dart';
import '../root_page.dart';

/// 榜单页 —— 真实接口 /media/ranking
class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);
  List<RankItem> _items = <RankItem>[];
  bool _loading = true;

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

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await MediaRepo.instance.ranking();
    if (!mounted) return;
    setState(() {
      _items = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            children: <Widget>[
              SizedBox(height: 8.w),
              Text('榜单',
                  style: TextStyle(
                      fontSize: 17.sp, fontWeight: FontWeight.w700, color: const Color(0xFF16161A))),
              SizedBox(height: 6.w),
              SizedBox(
                height: 34.w,
                child: TabBar(
                  controller: _tab,
                  labelColor: const Color(0xFF16161A),
                  unselectedLabelColor: const Color(0xFF9A9AA0),
                  indicatorColor: const Color(0xFFFF2D55),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 2.5,
                  dividerColor: Colors.transparent,
                  labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: TextStyle(fontSize: 14.sp),
                  tabs: const <Widget>[Tab(text: '热门榜', height: 34), Tab(text: '收藏榜', height: 34)],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const LoadingView()
              : _items.isEmpty
                  ? EmptyView(text: '暂无榜单数据', onTap: _load)
                  : RefreshIndicator(
                      color: const Color(0xFFFF2D55),
                      onRefresh: _load,
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 24.w),
                        itemCount: _items.length,
                        separatorBuilder: (_, __) => SizedBox(height: 8.w),
                        itemBuilder: (context, i) => _row(_items[i], i),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _row(RankItem it, int i) {
    final medal = i < 3;
    const medalColor = <Color>[Color(0xFFFF4D4F), Color(0xFFFF9500), Color(0xFFC08A2E)];
    return GestureDetector(
      onTap: () => Get.to(() => VideoPage(
          drama: Drama(id: it.id, title: it.title, cover: it.cover, heat: it.hot))),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.w),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 8.w, offset: Offset(0, 2.w)),
          ],
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 22.w,
              child: medal
                  ? Text('${i + 1}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                          color: medalColor[i],
                          fontStyle: FontStyle.italic))
                  : Text('${i + 1}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp, color: const Color(0xFFB0B0B8))),
            ),
            SizedBox(width: 8.w),
            ClipRRect(
              borderRadius: BorderRadius.circular(6.w),
              child: LLImage.url(it.cover, width: 52.w, height: 70.w, radius: 6.w),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(it.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.sp, color: const Color(0xFF16161A), height: 1.3)),
                  SizedBox(height: 6.w),
                  Row(
                    children: <Widget>[
                      if (it.tag.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0F3),
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                          child: Text(it.tag, style: TextStyle(fontSize: 9.5.sp, color: const Color(0xFFFF2D55))),
                        ),
                      SizedBox(width: 6.w),
                      if (it.hot > 0)
                        Text('🔥 ${_wan(it.hot)}',
                            style: TextStyle(fontSize: 10.sp, color: const Color(0xFF9A9AA0))),
                    ],
                  ),
                ],
              ),
            ),
            Image.asset('assets/images/common/arrow_right_grey.webp', width: 14.w, height: 14.w),
            SizedBox(width: 4.w),
          ],
        ),
      ),
    );
  }

  static String _wan(int n) => n >= 10000 ? '${(n / 10000).toStringAsFixed(1)}万' : '$n';
}