import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../config/http.dart';
import '../../hj_model/models.dart';
import '../../hj_utils/img.dart';
import '../root_page.dart';

export 'video_page.dart' show SearchPage;

/// 短剧播放页 —— 对应 hj_page/video/*
class VideoPage extends StatefulWidget {
  const VideoPage({super.key, required this.drama});

  final Drama drama;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController? _vc;
  bool _loading = true;
  bool _play = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final url = await MediaRepo.instance.playUrl(widget.drama.id);
      if (url.isEmpty) {
        setState(() {
          _loading = false;
          _error = '播放地址获取失败';
        });
        return;
      }
      final abs = url.startsWith('http') ? url : 'https://acg.imscc.cc$url';
      final c = VideoPlayerController.networkUrl(Uri.parse(abs));
      _vc = c;
      await c.initialize();
      if (!mounted) return;
      setState(() {
        _loading = false;
        _play = true;
      });
      c.play();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = '无法播放该内容';
      });
    }
  }

  @override
  void dispose() {
    _vc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                _play = !_play;
                _play ? _vc?.play() : _vc?.pause();
              }),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  if (_loading)
                    const LoadingView()
                  else if (_error != null)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text('无法播放该内容', style: TextStyle(color: Colors.white38)),
                          SizedBox(height: 12.w),
                          TextButton(
                            onPressed: _init,
                            child: const Text('重试', style: TextStyle(color: Colors.white54)),
                          ),
                        ],
                      ),
                    )
                  else if (_vc != null && _vc!.value.isInitialized)
                    FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: _vc!.value.size.width,
                        height: _vc!.value.size.height,
                        child: VideoPlayer(_vc!),
                      ),
                    ),
                  if (_error == null && !_loading)
                    Center(
                      child: AnimatedOpacity(
                        opacity: _play ? 0 : 1,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          width: 56.w,
                          height: 56.w,
                          decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                          child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                        ),
                      ),
                    ),
                  if (_error == null && !_loading)
                    Positioned.fill(
                      child: VideoProgressIndicator(
                        _vc!,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Color(0xFFFF2D55),
                          bufferedColor: Colors.white24,
                          backgroundColor: Colors.white10,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                ],
              ),
            ),
          ),
          _info(),
        ],
      ),
    );
  }

  Widget _info() {
    final d = widget.drama;
    return Container(
      color: const Color(0xFF12101A),
      padding: EdgeInsets.fromLTRB(16.w, 14.w, 16.w, MediaQuery.of(context).padding.bottom + 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(d.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600)),
          if (d.desc.isNotEmpty) ...<Widget>[
            SizedBox(height: 8.w),
            Text(d.desc,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white38, fontSize: 12.5.sp, height: 1.5)),
          ],
          SizedBox(height: 14.w),
          Row(
            children: <Widget>[
              _action('assets/images/common/like_white.png', '${d.heat}'),
              _action('assets/images/common/eye_white.webp', '${d.views}'),
              _action('assets/images/common/collect_white.png', '收藏'),
              const Spacer(),
              GestureDetector(
                onTap: () => _pay(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: <Color>[Color(0xFFFFC83D), Color(0xFFFF9500)]),
                    borderRadius: BorderRadius.circular(18.w),
                  ),
                  child: Text('开通会员',
                      style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _action(String icon, String label) => Padding(
        padding: EdgeInsets.only(right: 20.w),
        child: Row(
          children: <Widget>[
            Image.asset(icon, width: 17.w, height: 17.w),
            SizedBox(width: 5.w),
            Text(label, style: TextStyle(color: Colors.white54, fontSize: 11.sp)),
          ],
        ),
      );

  void _pay() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20.w, 22.w, 20.w, MediaQuery.of(context).padding.bottom + 24.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('开通会员',
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700, color: const Color(0xFF16161A))),
            SizedBox(height: 6.w),
            Text('即可享会员专属特权',
                style: TextStyle(fontSize: 12.sp, color: const Color(0xFF9A9AA0))),
            SizedBox(height: 20.w),
            _plan('连续包月', '¥25 / 月', '推荐'),
            SizedBox(height: 10.w),
            _plan('季度会员', '¥68 / 季', ''),
            SizedBox(height: 10.w),
            _plan('年度会员', '¥198 / 年', '最划算'),
            SizedBox(height: 16.w),
            Text('立即开通可领',
                style: TextStyle(fontSize: 11.sp, color: const Color(0xFFFF9500))),
          ],
        ),
      ),
    );
  }

  Widget _plan(String name, String price, String tag) => Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFEEEEEE)),
          borderRadius: BorderRadius.circular(10.w),
        ),
        child: Row(
          children: <Widget>[
            Text(name, style: TextStyle(fontSize: 14.sp, color: const Color(0xFF16161A))),
            if (tag.isNotEmpty) ...<Widget>[
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF2D55),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Text(tag, style: TextStyle(fontSize: 9.sp, color: Colors.white)),
              ),
            ],
            const Spacer(),
            Text(price, style: TextStyle(fontSize: 14.sp, color: const Color(0xFFFF2D55), fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

/// 搜索页
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _c = TextEditingController();
  List<Drama> _list = <Drama>[];
  bool _loading = false;

  static const List<String> _hot = <String>['热门短剧', '新番上架', '真人出演', '高分精选', '每日更新'];

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _doSearch() async {
    final kw = _c.text.trim();
    if (kw.isEmpty) return;
    setState(() => _loading = true);
    final data = await MediaRepo.instance.search(kw);
    if (!mounted) return;
    setState(() {
      _list = data;
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
        titleSpacing: 0,
        title: Container(
          height: 34.w,
          margin: EdgeInsets.only(right: 12.w),
          decoration: BoxDecoration(color: const Color(0xFFF2F2F5), borderRadius: BorderRadius.circular(17.w)),
          child: Row(
            children: <Widget>[
              SizedBox(width: 10.w),
              Image.asset('assets/images/home/home_search.png', width: 16.w, height: 16.w),
              SizedBox(width: 6.w),
              Expanded(
                child: TextField(
                  controller: _c,
                  style: TextStyle(fontSize: 13.sp, color: const Color(0xFF16161A)),
                  decoration: InputDecoration(
                    hintText: '搜索短剧、漫画、作者',
                    hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFFB0B0B8)),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onSubmitted: (_) => _doSearch(),
                  textInputAction: TextInputAction.search,
                ),
              ),
            ],
          ),
        ),
      ),
      body: _list.isEmpty && !_loading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 18.w, 16.w, 10.w),
                  child: Text('热门搜索', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                ),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.w,
                  children: _hot
                      .map((e) => GestureDetector(
                            onTap: () {
                              _c.text = e;
                              _doSearch();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F2F5),
                                borderRadius: BorderRadius.circular(14.w),
                              ),
                              child: Text(e, style: TextStyle(fontSize: 12.sp, color: const Color(0xFF5A5A64))),
                            ),
                          ))
                      .toList(),
                ),
              ],
            )
          : _loading
              ? const LoadingView()
              : GridView.builder(
                  padding: EdgeInsets.all(8.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.w,
                    crossAxisSpacing: 8.w,
                    childAspectRatio: .58,
                  ),
                  itemCount: _list.length,
                  itemBuilder: (_, i) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 3 / 4,
                        child: LLImage.url(_list[i].cover, radius: 6.w),
                      ),
                      SizedBox(height: 4.w),
                      Text(_list[i].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11.5.sp)),
                    ],
                  ),
                ),
    );
  }
}