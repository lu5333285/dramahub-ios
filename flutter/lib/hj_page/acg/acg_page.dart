import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../hj_model/models.dart';
import '../../hj_utils/img.dart';
import '../home/video_page.dart';
import '../root_page.dart';

/// 漫画页 —— 对应 hj_page/acg/*
class AcgPage extends StatefulWidget {
  const AcgPage({super.key});

  @override
  State<AcgPage> createState() => _AcgPageState();
}

class _AcgPageState extends State<AcgPage> {
  List<RankItem> _list = <RankItem>[];
  List<String> _cats = <String>['全部', '热门', '完结', '更新中'];
  int _cat = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final rows = await MediaRepo.instance.ranking();
    if (!mounted) return;
    setState(() {
      _list = rows;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 14.w, right: 8.w),
          child: Row(
            children: <Widget>[
              Text('漫画',
                  style: TextStyle(
                      fontSize: 17.sp, fontWeight: FontWeight.w700, color: const Color(0xFF16161A))),
              const Spacer(),
              Image.asset('assets/images/home/libary_search.webp', width: 19.w, height: 19.w),
              SizedBox(width: 12.w),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          height: 36.w,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            children: _cats.asMap().entries.map((e) {
              final active = e.key == _cat;
              return GestureDetector(
                onTap: () => setState(() => _cat = e.key),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 18.w),
                  decoration: active
                      ? const UnderlineTabIndicator(borderSide: BorderSide(color: Color(0xFFFF2D55), width: 2.5))
                      : null,
                  child: Text(e.value,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                          color: active ? const Color(0xFF16161A) : const Color(0xFF9A9AA0))),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: _loading
              ? const LoadingView()
                  : _list.isEmpty
                  ? EmptyView(text: '什么也没有', onTap: _load)
                  : GridView.builder(
                      padding: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 24.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8.w,
                        crossAxisSpacing: 8.w,
                        childAspectRatio: .58,
                      ),
                      itemCount: _list.length,
                      itemBuilder: (context, i) {
                        final it = _list[i];
                        return GestureDetector(
                          onTap: () => Get.to(() => VideoPage(
                              drama: Drama(id: it.id, title: it.title, cover: it.cover))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(child: LLImage.url(it.cover, radius: 6.w)),
                              SizedBox(height: 4.w),
                              Text(it.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11.5.sp, color: const Color(0xFF16161A))),
                            ],
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

/// 漫画详情 / 阅读页
class CartoonPage extends StatefulWidget {
  const CartoonPage({super.key, required this.item});

  final RankItem item;

  @override
  State<CartoonPage> createState() => _CartoonPageState();
}

class _CartoonPageState extends State<CartoonPage> {
  List<Chapter> _chapters = <Chapter>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await MediaRepo.instance.chapters(widget.item.id);
    if (!mounted) return;
    setState(() {
      _chapters = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF16161A),
        title: Text(widget.item.title, style: TextStyle(fontSize: 16.sp, color: const Color(0xFF16161A))),
      ),
      body: _loading
          ? const LoadingView()
          : _chapters.isEmpty
              ? const EmptyView(text: '暂无章节')
              : ListView.builder(
                  padding: EdgeInsets.all(12.w),
                  itemCount: _chapters.length,
                  itemBuilder: (_, i) {
                    final c = _chapters[i];
                    return Container(
                      margin: EdgeInsets.only(bottom: 8.w),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F9),
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(c.title, style: TextStyle(fontSize: 13.sp, color: const Color(0xFF16161A))),
                          const Spacer(),
                          if (!c.unlocked)
                            Text('开通会员',
                                style: TextStyle(fontSize: 11.sp, color: const Color(0xFFFF9500))),
                          SizedBox(width: 6.w),
                          const Icon(Icons.chevron_right, size: 16, color: Color(0xFFB0B0B8)),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}