import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../hj_model/models.dart';
import '../../hj_utils/img.dart';
import '../root_page.dart';

/// 社区页 —— 真实接口 /msg/dynamic/list、/follow/dynamics/list
class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 3, vsync: this);
  static const List<String> _tabs = <String>['推荐', '关注', '热门'];

  List<Post> _list = <Post>[];
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
    final data = await MediaRepo.instance.posts();
    if (!mounted) return;
    setState(() {
      _list = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.w),
                  Text('社区',
                      style: TextStyle(
                          fontSize: 17.sp, fontWeight: FontWeight.w700, color: const Color(0xFF16161A))),
                  SizedBox(height: 8.w),
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
                      onTap: (_) => _load(),
                      tabs: _tabs.map((e) => Tab(text: e, height: 34)).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const LoadingView()
                  : _list.isEmpty
                      ? EmptyView(text: '暂无动态', onTap: _load)
                      : RefreshIndicator(
                          color: const Color(0xFFFF2D55),
                          onRefresh: _load,
                          child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 90.w),
                            itemCount: _list.length,
                            itemBuilder: (_, i) => _post(_list[i]),
                          ),
                        ),
            ),
          ],
        ),
        Positioned(
          right: 16.w,
          bottom: MediaQuery.of(context).padding.bottom + 20.w,
          child: GestureDetector(
            onTap: () => Get.bottomSheet(_publishSheet()),
            child: Container(
              width: 46.w,
              height: 46.w,
              decoration: const BoxDecoration(color: Color(0xFFFF2D55), shape: BoxShape.circle),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _post(Post p) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipOval(
                child: p.avatar.isEmpty
                    ? Container(width: 34.w, height: 34.w, color: const Color(0xFFEEE))
                    : LLImage.url(p.avatar, width: 34.w, height: 34.w),
              ),
              SizedBox(width: 9.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(p.author.isEmpty ? '匿名用户' : p.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13.sp, color: const Color(0xFF16161A), fontWeight: FontWeight.w500)),
                    if (p.time.isNotEmpty)
                      Text(p.time, style: TextStyle(fontSize: 10.sp, color: const Color(0xFFB0B0B8))),
                  ],
                ),
              ),
              Image.asset('assets/images/community/community_noval_sel.png', width: 16.w, height: 16.w),
            ],
          ),
          SizedBox(height: 9.w),
          Text(p.content, style: TextStyle(fontSize: 13.sp, color: const Color(0xFF2A2A32), height: 1.5)),
          if (p.images.isNotEmpty) ...<Widget>[
            SizedBox(height: 9.w),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 5.w,
              crossAxisSpacing: 5.w,
              children: p.images
                  .take(9)
                  .map((u) => ClipRRect(
                        borderRadius: BorderRadius.circular(5.w),
                        child: LLImage.url(u),
                      ))
                  .toList(),
            ),
          ],
          SizedBox(height: 10.w),
          Row(
            children: <Widget>[
              _bar('assets/images/community/like_count.png', '${p.likes}'),
              SizedBox(width: 24.w),
              _bar('assets/images/community/view_count.png', '浏览'),
              SizedBox(width: 24.w),
              _bar('assets/images/common/share_grey.png', '分享'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bar(String icon, String text) => Row(
        children: <Widget>[
          Image.asset(icon, width: 15.w, height: 15.w),
          SizedBox(width: 4.w),
          Text(text, style: TextStyle(fontSize: 11.sp, color: const Color(0xFF9A9AA0))),
        ],
      );

  Widget _publishSheet() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 18.w, 16.w, MediaQuery.of(context).padding.bottom + 22.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('发布',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color(0xFF16161A))),
          SizedBox(height: 16.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _type('assets/images/community/publish_img.webp', '发布图文'),
              _type('assets/images/community/publish_video.webp', '发布视频'),
              _type('assets/images/community/publish_hash.svg', '发布话题'),
            ],
          ),
          SizedBox(height: 14.w),
          Text('发布诱导图文',
              style: TextStyle(fontSize: 11.sp, color: const Color(0xFFB0B0B8))),
        ],
      ),
    );
  }

  Widget _type(String icon, String label) => Column(
        children: <Widget>[
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(color: const Color(0xFFF7F7F9), borderRadius: BorderRadius.circular(12.w)),
            alignment: Alignment.center,
            child: Image.asset(icon, width: 26.w, height: 26.w),
          ),
          SizedBox(height: 6.w),
          Text(label, style: TextStyle(fontSize: 11.sp, color: const Color(0xFF5A5A64))),
        ],
      );
}