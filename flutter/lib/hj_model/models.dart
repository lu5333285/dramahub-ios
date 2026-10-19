import 'package:flutter/foundation.dart';

import '../config/api.dart';
import '../config/http.dart';

/// 短剧 / 视频模型 —— 对应 hj_model/media_*
@immutable
class Drama {
  final int id;
  final String title;
  final String cover;
  final String url;
  final String desc;
  final int duration;
  final int heat;
  final int views;
  final bool vip;

  const Drama({
    required this.id,
    required this.title,
    required this.cover,
    this.url = '',
    this.desc = '',
    this.duration = 0,
    this.heat = 0,
    this.views = 0,
    this.vip = false,
  });

  factory Drama.fromJson(Map<String, dynamic> j) => Drama(
        id: j.num_('id'),
        title: j.str('title').isEmpty ? j.str('name') : j.str('title'),
        cover: _cover(j),
        url: j.str('url').isEmpty ? j.str('play_url') : j.str('url'),
        desc: j.str('description').isEmpty ? j.str('desc') : j.str('description'),
        duration: j.num_('duration'),
        heat: j.num_('heat'),
        views: j.numAlt('views', 'play_num'),
        vip: j.num_('is_vip') == 1 || j.num_('vip') == 1,
      );

  /// 从多个候选字段里取封面（原 app 服务端字段名不统一）
  static String _cover(Map<String, dynamic> j) {
    for (final k in <String>[
      'cover',
      'cover_url',
      'poster',
      'poster_url',
      'image',
      'img',
      'thumb',
      'thumbnail',
      'picture',
    ]) {
      final v = j[k];
      if (v is String && v.isNotEmpty) return v;
    }
    final list = j['images'];
    if (list is List && list.isNotEmpty) {
      final f = list.first;
      if (f is String) return f;
      if (f is Map) return Map<String, dynamic>.from(f).str('url');
    }
    return '';
  }

  /// 从 images/pics/list 字段提取图片列表（原 app 服务端字段名不统一）
  static List<String> coverList(Map<String, dynamic> j) {
    for (final k in <String>['images', 'pics', 'list']) {
      final v = j[k];
      if (v is List) {
        return v.map((e) {
          if (e is String) return e;
          if (e is Map) {
            final m = Map<String, dynamic>.from(e);
            return m.str('url').isEmpty ? m.str('image') : m.str('url');
          }
          return '';
        }).where((e) => e.isNotEmpty).toList();
      }
    }
    final one = _cover(j);
    return one.isEmpty ? <String>[] : <String>[one];
  }
}

/// 漫画章节模型 —— 对应 hj_model/acg/*
@immutable
class Chapter {
  final int id;
  final String title;
  final List<String> images;
  final bool unlocked;

  const Chapter({
    required this.id,
    required this.title,
    this.images = const <String>[],
    this.unlocked = true,
  });

  factory Chapter.fromJson(Map<String, dynamic> j) => Chapter(
        id: j.num_('id'),
        title: j.str('title').isEmpty ? '第 ${j.num_('sort', 1)} 话' : j.str('title'),
        images: <String>[
          for (final k in <String>['images', 'list', 'urls', 'pics'])
            if (j[k] is List)
              ...(j[k] as List).map((e) {
                if (e is String) return e;
                if (e is Map) {
                  final m = Map<String, dynamic>.from(e);
                  return m.str('url').isEmpty ? m.str('image') : m.str('url');
                }
                return '';
              })
        ].where((e) => e.isNotEmpty).toList(),
        unlocked: j.num_('is_vip') != 1,
      );
}

/// 用户信息 —— 对应 /mine/info
@immutable
class UserInfo {
  final int id;
  final String nickname;
  final String portrait;
  final int vipLevel;
  final int coin;
  final int integral;
  final bool isVip;

  const UserInfo({
    this.id = 0,
    this.nickname = '',
    this.portrait = '',
    this.vipLevel = 0,
    this.coin = 0,
    this.integral = 0,
    this.isVip = false,
  });

  factory UserInfo.fromJson(Map<String, dynamic> j) {
    final level = j.numAlt('vip_level', 'level');
    return UserInfo(
      id: j.num_('id'),
      nickname: j.str('nickname').isEmpty ? j.str('name') : j.str('nickname'),
      portrait: Drama._cover(j),
      vipLevel: level,
      coin: j.numAlt('coin', 'gold'),
      integral: j.num_('integral'),
      isVip: level > 0 || j.num_('is_vip') == 1,
    );
  }

  static const UserInfo empty = UserInfo();
}

/// 榜单条目
@immutable
class RankItem {
  final int id;
  final String title;
  final String cover;
  final String tag;
  final int hot;

  const RankItem({
    required this.id,
    required this.title,
    required this.cover,
    this.tag = '',
    this.hot = 0,
  });

  factory RankItem.fromJson(Map<String, dynamic> j) => RankItem(
        id: j.num_('id'),
        title: j.str('title').isEmpty ? j.str('name') : j.str('title'),
        cover: Drama._cover(j),
        tag: j.str('tag').isEmpty ? j.str('category') : j.str('tag'),
        hot: j.numAlt('hot', 'heat'),
      );
}

/// 动态 / 社区帖子
@immutable
class Post {
  final int id;
  final String content;
  final List<String> images;
  final String author;
  final String avatar;
  final int likes;
  final String time;

  const Post({
    required this.id,
    required this.content,
    this.images = const <String>[],
    this.author = '',
    this.avatar = '',
    this.likes = 0,
    this.time = '',
  });

  factory Post.fromJson(Map<String, dynamic> j) {
    final user = j['user'] is Map ? j.obj('user') : <String, dynamic>{};
    return Post(
      id: j.num_('id'),
      content: j.str('content').isEmpty ? j.str('text') : j.str('content'),
      images: Drama.coverList(j),
      author: user['nickname']?.toString() ?? j.str('nickname'),
      avatar: user.isEmpty ? Drama._cover(j) : Drama._cover(user),
      likes: j.numAlt('likes', 'like_num'),
      time: j.str('create_time').isEmpty ? j.str('time') : j.str('create_time'),
    );
  }
}

/// Repository 层：按原接口组织数据获取
class MediaRepo {
  MediaRepo._();
  static final MediaRepo instance = MediaRepo._();

  /// 首页推荐
  Future<List<Drama>> recommend({int page = 1}) async {
    final rows = await Repo.list(Api.mediaRecommend, page: page);
    return rows.map(Drama.fromJson).toList();
  }

  /// 首页新剧
  Future<List<Drama>> newList({int page = 1}) async {
    final rows = await Repo.list(Api.vidHomeNewList, page: page);
    return rows.map(Drama.fromJson).toList();
  }

  /// 短剧详情
  Future<Drama> detail(int id) async {
    final j = await Repo.detail(Api.mediaInfo, query: <String, dynamic>{'id': id});
    return Drama.fromJson(j);
  }

  /// 短剧播放地址
  Future<String> playUrl(int id) async {
    final j = await Repo.detail(Api.vidPlay, query: <String, dynamic>{'id': id});
    final data = j['data'] ?? j;
    if (data is Map) {
      final m = Map<String, dynamic>.from(data);
      for (final k in <String>['url', 'play_url', 'm3u8']) {
        final v = m[k];
        if (v is String && v.isNotEmpty) return v;
      }
    }
    return '';
  }

  /// 排行榜
  Future<List<RankItem>> ranking() async {
    final rows = await Repo.list(Api.mediaRanking);
    return rows.map(RankItem.fromJson).toList();
  }

  /// 短剧分类
  Future<List<String>> sections() async {
    final rows = await Repo.list(Api.vidSectionList);
    return rows.map((e) => e.str('name').isEmpty ? e.str('title') : e.str('name')).toList();
  }

  /// 搜索
  Future<List<Drama>> search(String keyword, {int page = 1}) async {
    final rows = await Repo.list(Api.mediaSearch,
        query: <String, dynamic>{'keyword': keyword, 'search': keyword}, page: page);
    return rows.map(Drama.fromJson).toList();
  }

  /// 我的信息
  Future<UserInfo> mine() async {
    final j = await Repo.detail(Api.mineInfo);
    return UserInfo.fromJson(j);
  }

  /// 社区动态
  Future<List<Post>> posts({int page = 1}) async {
    final rows = await Repo.list(Api.msgDynamicList, page: page);
    return rows.map(Post.fromJson).toList();
  }

  /// 漫画章节
  Future<List<Chapter>> chapters(int mediaId) async {
    final rows = await Repo.list(Api.mediaContentList,
        query: <String, dynamic>{'id': mediaId, 'media_id': mediaId});
    return rows.map(Chapter.fromJson).toList();
  }

  /// 积分任务
  Future<List<Map<String, dynamic>>> tasks() => Repo.list(Api.taskList);
}
