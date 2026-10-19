// Generated from lldj2.4.0V5.apk — Dart 源码树（587 个 .dart 文件）映射
// 字符串表保留了 package:jydj/...dart 路径，此处逐模块还原。
// Regenerate with rea_analysis/gen_portmap.py — DO NOT EDIT MANUALLY.

import Foundation

/// 原 Dart 一级模块
enum LLDJDartModule: String, CaseIterable, Identifiable {
    /// Identifiable：直接复用 rawValue
    var id: String { rawValue }

    case hj_page
    case hj_model
    case hj_utils
    case tools_base
    case im_manager
    case track_event_manager
    case alert
    case config
    case routers
    case extensionMod
    case assets_tool

    var fileCount: Int {
        switch self {
        case .hj_page: return 366
        case .hj_model: return 43
        case .hj_utils: return 35
        case .tools_base: return 86
        case .im_manager: return 16
        case .track_event_manager: return 6
        case .alert: return 24
        case .config: return 2
        case .routers: return 2
        case .extensionMod: return 5
        case .assets_tool: return 1
        }
    }

    var title: String {
        switch self {
        case .hj_page: return "页面层"
        case .hj_model: return "数据模型层"
        case .hj_utils: return "工具/服务层"
        case .tools_base: return "基础组件层"
        case .im_manager: return "IM 模块"
        case .track_event_manager: return "埋点模块"
        case .alert: return "弹窗层"
        case .config: return "配置层"
        case .routers: return "路由层"
        case .extensionMod: return "扩展层"
        case .assets_tool: return "资源工具"
        }
    }

    var summary: String {
        switch self {
        case .hj_page: return "GetX Page（129）"
        case .hj_model: return "Codable 模型（137 fromJson）"
        case .hj_utils: return "api_service + util（35 文件）"
        case .tools_base: return "缓存/埋点/广告/事件总线（86 文件）"
        case .im_manager: return "聊天/消息（16 文件）"
        case .track_event_manager: return "事件上报（6 文件）"
        case .alert: return "全局弹窗/支付引导（24 文件）"
        case .config: return "address.dart + config.dart"
        case .routers: return "router_map.dart + jump_router.dart"
        case .extensionMod: return "Dart extension"
        case .assets_tool: return "assets 打包"
        }
    }

    var dartPath: String { "package:jydj/" + rawValue }
}

/// 原 Dart hj_page 二级子模块 → iOS Feature 目录
struct LLDJFeatureArea: Identifiable, Hashable {
    let id: String
    let dartDir: String
    let swiftDir: String
    let title: String
    let fileCount: Int
}

enum LLDJPortMap {
    /// 全部 Feature 区域（按 iOS 目录归并）
    static let areas: [LLDJFeatureArea] = [
        LLDJFeatureArea(id: "Mine", dartDir: "mine/collec_history_buy,mine/home_mine_logic.dart,mine/home_mine_page.dart,mine/identity,mine/make_money,mine/message,mine/mine_drive,mine/mine_following,mine/mine_gesture_pwd,mine/mine_post,mine/mine_profit,mine/mine_setting,mine/mine_share,mine/mine_video_cache,mine/mine_vip,mine/more_question,mine/welfare,mine/widgets", swiftDir: "Features/Mine", title: "我的", fileCount: 104),
        LLDJFeatureArea(id: "Home", dartDir: "home/activity_float,home/dark_home_page.dart,home/home_cell_style,home/home_drawer.dart,home/home_drawer_logic.dart,home/home_main_logic.dart,home/home_main_page.dart,home/home_sub_module,home/provider,home/search_page,home/section_all_page,home/special_topic_detail,home/tag,home/widget", swiftDir: "Features/Home", title: "首页", fileCount: 56),
        LLDJFeatureArea(id: "Drama", dartDir: "drama/drama_detail_logic.dart,drama/drama_detail_page.dart,drama/drama_feed_logic.dart,drama/drama_feed_page.dart,drama/drama_list_logic.dart,drama/drama_list_page.dart,drama/view,short_video/short_main_video_logic.dart,short_video/short_main_video_page.dart,short_video/short_video_logic.dart,short_video/short_video_page.dart,short_video/view,video/cartoon,video/simple_video_player_logic.dart,video/simple_video_player_page.dart,video/video_full_logic.dart,video/video_full_page.dart,video/video_logic.dart,video/video_page.dart,video/video_player_alert.dart,video/view", swiftDir: "Features/Drama", title: "短剧", fileCount: 45),
        LLDJFeatureArea(id: "Community", dartDir: "comment/cell,comment/comment_alert.dart,comment/comment_input_view.dart,comment/comment_mixin.dart,comment/comment_views.dart,comment/widget,community/community,community/community_main_page_page,community/community_tag_page,community/post_detail_page,community/publish_page,community/widget", swiftDir: "Features/Community", title: "社区", fileCount: 41),
        LLDJFeatureArea(id: "AI", dartDir: "ai/ai_change_face_logic.dart,ai/ai_change_face_page.dart,ai/ai_draw,ai/ai_face_sub_logic.dart,ai/ai_face_sub_page.dart,ai/ai_girl,ai/ai_home_logic.dart,ai/ai_home_page.dart,ai/ai_image_to_video,ai/ai_mod_detail_page.dart,ai/ai_novel,ai/ai_record,ai/ai_square,ai/ai_sub_type,ai/models,ai/widgets", swiftDir: "Features/AI", title: "AI 创作", fileCount: 39),
        LLDJFeatureArea(id: "Cartoon", dartDir: "cartoon/acg_widget_item.dart,cartoon/audio_player_bottomsheet.dart,cartoon/audio_player_content.dart,cartoon/cartoon_detail_logic.dart,cartoon/cartoon_detail_page.dart,cartoon/cartoon_read_logic.dart,cartoon/cartoon_read_page.dart,cartoon/cartoon_recommend_logic.dart,cartoon/cartoon_recommend_page.dart,cartoon/cartoon_sectionlist_page.dart,cartoon/cartoon_sectionlist_sub_logic.dart,cartoon/cartoon_sectionlist_sub_page.dart,cartoon/cartoon_sub_detail_page.dart,cartoon/cartoon_sub_grid_logic.dart,cartoon/cartoon_sub_grid_page.dart,cartoon/cartoon_sub_module_logic.dart,cartoon/cartoon_sub_module_page.dart,cartoon/novel_detail_logic.dart,cartoon/novel_detail_page.dart,cartoon/novel_header.dart,cartoon/photo_gallery_item.dart,cartoon/text_novel_read_logic.dart,cartoon/text_novel_read_page.dart,cartoon/voice_novel_read_logic.dart,cartoon/voice_novel_read_page.dart,cartoon/widget", swiftDir: "Features/Cartoon", title: "漫画", fileCount: 29),
        LLDJFeatureArea(id: "Find", dartDir: "find/acg_game_detail_logic.dart,find/acg_game_detail_page.dart,find/acg_game_recommend_logic.dart,find/acg_game_recommend_page.dart,find/pic_collect,find/rank_module", swiftDir: "Features/Find", title: "Find", fileCount: 17),
        LLDJFeatureArea(id: "Live", dartDir: "live/live_detail_logic.dart,live/live_detail_page.dart,live/live_item_widget.dart,live/live_main_logic.dart,live/live_main_page.dart,live/live_model.dart,live/live_service.dart,live/live_sub_logic.dart,live/live_sub_page.dart,live/live_widget.dart", swiftDir: "Features/Live", title: "直播", fileCount: 10),
        LLDJFeatureArea(id: "Presale", dartDir: "pre_sale/limit_time_provider.dart,pre_sale/pre_sale_alert.dart,pre_sale/pre_sale_entry.dart,pre_sale/pre_sale_logic.dart,pre_sale/pre_sale_model.dart,pre_sale/pre_sale_page.dart,pre_sale/pre_sale_provider.dart,pre_sale/pre_sale_service.dart", swiftDir: "Features/Presale", title: "预售", fileCount: 8),
        LLDJFeatureArea(id: "Main", dartDir: "main_page/drama_tip_bubble.dart,main_page/main_logic.dart,main_page/main_page.dart,main_page/main_tabbar.dart,main_page/provider", swiftDir: "Features/Main", title: "主框架", fileCount: 6),
        LLDJFeatureArea(id: "UserCenter", dartDir: "user_center_page/user_center_logic.dart,user_center_page/user_center_page.dart,user_center_page/view,user_center_page/widget", swiftDir: "Features/UserCenter", title: "用户中心", fileCount: 5),
        LLDJFeatureArea(id: "Splash", dartDir: "splash/splash_ad_view.dart,splash/splash_logic.dart,splash/splash_page.dart", swiftDir: "Features/Splash", title: "启动", fileCount: 3),
        LLDJFeatureArea(id: "H5", dartDir: "web_page/h5_logic.dart,web_page/h5_page.dart,web_page/h5_webview_settings.dart", swiftDir: "Features/H5", title: "H5", fileCount: 3),
    ]

    static var totalDartFiles: Int { 587 }
    static var totalPages: Int { 129 }
    static var totalLogics: Int { 104 }
    static var totalJsonModels: Int { 137 }
}
