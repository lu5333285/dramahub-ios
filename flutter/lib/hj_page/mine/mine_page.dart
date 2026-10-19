import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/http.dart';
import '../../hj_model/models.dart';
import '../../hj_utils/img.dart';
import '../root_page.dart';

/// 我的 —— 真实接口 /mine/info、/mine/wallet、/vip/product
class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  UserInfo _user = UserInfo.empty;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final u = await MediaRepo.instance.mine();
    if (!mounted) return;
    setState(() {
      _user = u;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFFFF2D55),
      onRefresh: _load,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _header(),
          _wallet(),
          _grid(),
          _menu(),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20.w),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20.w, left: 16.w, right: 16.w, bottom: 22.w),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF32294A), Color(0xFF16131F)],
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => Get.to(() => const _LoginPage()),
                child: ClipOval(
                  child: _user.portrait.isEmpty
                      ? Image.asset('assets/images/common/placeholder_portrait.png',
                          width: 52.w, height: 52.w)
                      : LLImage.url(_user.portrait, width: 52.w, height: 52.w),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_user.nickname.isEmpty ? '点击登录' : _user.nickname,
                        style: TextStyle(
                            color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w600)),
                    SizedBox(height: 5.w),
                    if (_user.isVip)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.w),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: <Color>[Color(0xFFFFC83D), Color(0xFFFF9500)]),
                          borderRadius: BorderRadius.circular(9.w),
                        ),
                        child: Text('VIP${_user.vipLevel}',
                            style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.w700)),
                      )
                    else
                      GestureDetector(
                        onTap: _openVip,
                        child: Row(
                          children: <Widget>[
                            Text('开通会员',
                                style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
                            SizedBox(width: 3.w),
                            const Icon(Icons.chevron_right, size: 13, color: Colors.white38),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Image.asset('assets/images/common/official_icon.png', width: 22.w, height: 22.w),
            ],
          ),
          SizedBox(height: 16.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _stat('${_user.integral}', '我的积分'),
              _stat('${_user.coin}', '我的金币'),
              _stat('${_user.vipLevel}', '会员等级'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String v, String label) => Column(
        children: <Widget>[
          Text(v,
              style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w700)),
          SizedBox(height: 3.w),
          Text(label, style: TextStyle(color: Colors.white38, fontSize: 11.sp)),
        ],
      );

  Widget _wallet() {
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, -14.w, 12.w, 0),
      padding: EdgeInsets.symmetric(vertical: 15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _w('立即提现', 'assets/images/mine/mine_menu_1.png'),
          _w('我的积分', 'assets/images/mine/mine_menu_2.png'),
          _w('福利任务', 'assets/images/mine/mine_menu_3.png'),
          _w('邀请好友', 'assets/images/mine/mine_menu_4.png'),
        ],
      ),
    );
  }

  Widget _w(String label, String icon) => Column(
        children: <Widget>[
          Image.asset(icon, width: 24.w, height: 24.w),
          SizedBox(height: 6.w),
          Text(label, style: TextStyle(fontSize: 11.sp, color: const Color(0xFF2A2A32))),
        ],
      );

  Widget _grid() {
    const items = <List<String>>[
      <String>['我的收藏', 'mine_collect.png'],
      <String>['我的关注', 'mine_follow.png'],
      <String>['下载记录', 'mine_col_delete.png'],
      <String>['我的钱包', 'mine_menu_10.png'],
      <String>['邀请好友', 'mine_menu_12.png'],
      <String>['提现明细', 'mine_menu_2.png'],
      <String>['我的账号', 'mine_id.png'],
      <String>['兑换码', 'mine_menu_3.png'],
    ];
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 10.w, 12.w, 0),
      padding: EdgeInsets.symmetric(vertical: 16.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.w)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 18.w,
          childAspectRatio: 1,
        ),
        itemBuilder: (_, i) {
          final img = 'assets/images/mine/${items[i][1]}';
          return Column(
            children: <Widget>[
              _assetOrIcon(img, items[i][0]),
              SizedBox(height: 5.w),
              Text(items[i][0], style: TextStyle(fontSize: 11.sp, color: const Color(0xFF5A5A64))),
            ],
          );
        },
      ),
    );
  }

  Widget _assetOrIcon(String path, String label) {
    final has = <String>[
      'mine_collect.png', 'mine_follow.png', 'mine_col_delete.png',
      'mine_menu_1.png', 'mine_menu_2.png', 'mine_menu_3.png', 'mine_menu_4.png',
      'mine_menu_10.png', 'mine_menu_12.png', 'mine_id.png',
    ].any((e) => path.endsWith(e));
    if (!has) {
      return Icon(Icons.more_horiz, size: 22.w, color: const Color(0xFFB0B0B8));
    }
    return Image.asset(path, width: 22.w, height: 22.w);
  }

  Widget _menu() {
    const rows = <List<String>>[
      <String>['下载说明', ''],
      <String>['官方联系方式', ''],
      <String>['设置', ''],
    ];
    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 10.w, 12.w, 0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.w)),
      child: Column(
        children: rows.asMap().entries.map((e) {
          return Column(
            children: <Widget>[
              ListTile(
                dense: true,
                title: Text(e.value[0], style: TextStyle(fontSize: 13.sp, color: const Color(0xFF2A2A32))),
                trailing: const Icon(Icons.chevron_right, size: 16, color: Color(0xFFB0B0B8)),
                onTap: () => Get.to(() => _SimplePage(title: e.value[0])),
              ),
              if (e.key < rows.length - 1)
                const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _openVip() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20.w, 24.w, 20.w, MediaQuery.of(context).padding.bottom + 26.w),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFF2A2340), Color(0xFF14121C)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('会员中心',
                style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w700)),
            SizedBox(height: 8.w),
            Text('解锁全站尊享特权',
                style: TextStyle(color: Colors.white38, fontSize: 12.sp)),
            SizedBox(height: 22.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _vip('连续包月', '¥25', '每月'),
                SizedBox(width: 12.w),
                _vip('季度会员', '¥68', '每季'),
                SizedBox(width: 12.w),
                _vip('年度会员', '¥198', '每年'),
              ],
            ),
            SizedBox(height: 20.w),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 13.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: <Color>[Color(0xFFFFD36E), Color(0xFFFF9500)]),
                borderRadius: BorderRadius.circular(24.w),
              ),
              alignment: Alignment.center,
              child: Text('立即开通',
                  style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vip(String name, String price, String unit) => Container(
        width: 82.w,
        padding: EdgeInsets.symmetric(vertical: 14.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFF4A3D2A), Color(0xFF241F18)],
          ),
          borderRadius: BorderRadius.circular(10.w),
          border: Border.all(color: const Color(0x33FFC83D)),
        ),
        child: Column(
          children: <Widget>[
            Text(name, style: TextStyle(color: Colors.white70, fontSize: 11.sp)),
            SizedBox(height: 6.w),
            Text(price,
                style: TextStyle(color: const Color(0xFFFFC83D), fontSize: 19.sp, fontWeight: FontWeight.w800)),
            Text(unit, style: TextStyle(color: Colors.white30, fontSize: 9.sp)),
          ],
        ),
      );
}

/// 登录页
class _LoginPage extends StatelessWidget {
  const _LoginPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, foregroundColor: const Color(0xFF16161A)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(24.w, 30.w, 24.w, 0),
        children: <Widget>[
          Image.asset('assets/images/common/app_main_logo.png', width: 62.w, height: 62.w),
          SizedBox(height: 16.w),
          Text('欢迎回来',
              style: TextStyle(fontSize: 21.sp, fontWeight: FontWeight.w700, color: const Color(0xFF16161A))),
          SizedBox(height: 6.w),
          Text('本平台登录会自动创建账号，需保存账号凭证或绑定手机号码，才能记录之前的账号信息。',
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF9A9AA0), height: 1.6)),
          SizedBox(height: 26.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F9),
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: Row(
              children: <Widget>[
                const Text('+86', style: TextStyle(fontSize: 14.sp, color: const Color(0xFF2A2A32))),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: 14.sp),
                    decoration: const InputDecoration(
                      hintText: '请输入手机号',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F9),
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: TextField(
              obscureText: true,
              style: TextStyle(fontSize: 14.sp),
              decoration: const InputDecoration(
                hintText: '密码',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          SizedBox(height: 24.w),
          Container(
            padding: EdgeInsets.symmetric(vertical: 14.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: <Color>[Color(0xFFFF5C7A), Color(0xFFFF2D55)]),
              borderRadius: BorderRadius.circular(24.w),
            ),
            alignment: Alignment.center,
            child: Text('登录',
                style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: 16.w),
          Center(
            child: Text('未绑定手机号码会导致账号信息丢失',
                style: TextStyle(fontSize: 11.sp, color: const Color(0xFFB0B0B8))),
          ),
        ],
      ),
    );
  }
}

/// 通用二级页
class _SimplePage extends StatelessWidget {
  const _SimplePage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF16161A),
        title: Text(title, style: TextStyle(fontSize: 16.sp, color: const Color(0xFF16161A))),
      ),
      body: const EmptyView(text: '暂无内容'),
    );
  }
}