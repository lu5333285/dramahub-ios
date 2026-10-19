// Generated from lldj2.4.0V5.apk (libapp.so Dart AOT string table)
// 端点路径逐字取自原 APK，未做改写。共 121 条。
// Regenerate with rea_analysis/gen_endpoints.py — DO NOT EDIT MANUALLY.

import Foundation

/// 原版后端域名观测值（libapp.so 明文常量）
enum LLDJBackend {
    static let host0 = "https://lldj.tv"
    static let host1 = "https://lldj1.tv"
    static let host2 = "https://api2.uszim.com"
    static let host3 = "https://acg.imscc.cc"
    static let host4 = "https://im.tapi.flowcd.cn"
    static let host5 = "https://imcfg.imscc.cc"
    static let host6 = "https://sdk.api.cdflow.cn"
    static let host7 = "https://awx2.tianxiawudi007.com"
    static let host8 = "https://awx2api.80sygtm.com"
    static let all = [host0, host1, host2, host3, host4, host5, host6, host7, host8]
}

enum LLDJMethod: String {
    case get = "GET"
    case post = "POST"
}

enum LLDJDomain: String, CaseIterable {
    case core
    case media
    case search
    case interact
    case community
    case im
    case user
    case wallet
    case vip
    case welfare
    case ai
    case common

    var title: String {
        switch self {
        case .core: return "核心"
        case .media: return "媒资"
        case .search: return "搜索"
        case .interact: return "互动"
        case .community: return "社区"
        case .im: return "IM"
        case .user: return "用户"
        case .wallet: return "钱包"
        case .vip: return "VIP"
        case .welfare: return "福利"
        case .ai: return "AI"
        case .common: return "公共"
        }
    }

    var host: String {
        switch self {
        case .im: return LLDJBackend.host4
        case .ai: return LLDJBackend.host2
        default: return LLDJBackend.host0
        }
    }

    /// 分组标题（用于路由目录展示）
    var group: String {
        switch self {
        case .core: return "核心配置"
        case .media: return "短剧媒资"
        case .search: return "搜索标签"
        case .interact: return "书架收藏"
        case .community: return "社区评论"
        case .im: return "即时通讯"
        case .user: return "账号用户"
        case .wallet: return "钱包支付"
        case .vip: return "会员权益"
        case .welfare: return "福利任务"
        case .ai: return "AI 创作"
        case .common: return "通用公共"
        }
    }
}

/// 单个端点定义
struct LLDJEndpointDef {
    let path: String
    let method: LLDJMethod
    let domain: LLDJDomain
    let title: String

    init(path: String, method: LLDJMethod, domain: LLDJDomain, title: String = "") {
        self.path = path
        self.method = method
        self.domain = domain
        self.title = title
    }

    /// 带查询参数
    func q(_ items: [(String, String)]) -> LLDJEndpointDef {
        guard !items.isEmpty else { return self }
        let s = items.map { "\($0.0)=\($0.1.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")" }.joined(separator: "&")
        return LLDJEndpointDef(path: path + "?" + s, method: method, domain: domain, title: title)
    }

    var url: String { domain.host + path }
}

/// 全部业务端点（121 条，按域分组）
enum LLDJEndpoint {
    /// 探活取域名
    static let e000 = LLDJEndpointDef(path: "/ping/domain", method: .get, domain: .core, title: "探活取域名")
    /// 刷新动态域名
    static let e001 = LLDJEndpointDef(path: "/ping/domain/refresh", method: .post, domain: .core, title: "刷新动态域名")
    /// 应用市场地址
    static let e002 = LLDJEndpointDef(path: "/ping/store_url", method: .get, domain: .core, title: "应用市场地址")
    /// 首页模块列表
    static let e003 = LLDJEndpointDef(path: "/modules/list", method: .get, domain: .core, title: "首页模块列表")
    /// 商品内购列表
    static let e004 = LLDJEndpointDef(path: "/product/buy", method: .get, domain: .core, title: "商品内购列表")
    /// 媒资详情
    static let e005 = LLDJEndpointDef(path: "/media/info", method: .get, domain: .media, title: "媒资详情")
    /// 推荐流
    static let e006 = LLDJEndpointDef(path: "/media/recommend", method: .get, domain: .media, title: "推荐流")
    /// 媒资搜索
    static let e007 = LLDJEndpointDef(path: "/media/search", method: .get, domain: .media, title: "媒资搜索")
    /// 媒资榜单
    static let e008 = LLDJEndpointDef(path: "/media/ranking", method: .get, domain: .media, title: "媒资榜单")
    /// 专题详情
    static let e009 = LLDJEndpointDef(path: "/media/topic", method: .get, domain: .media, title: "专题详情")
    /// 媒资库搜索
    static let e010 = LLDJEndpointDef(path: "/media/library/search", method: .get, domain: .media, title: "媒资库搜索")
    /// 我的已购
    static let e011 = LLDJEndpointDef(path: "/media/my_buy", method: .get, domain: .media, title: "我的已购")
    /// 内容详情
    static let e012 = LLDJEndpointDef(path: "/media_content/info", method: .get, domain: .media, title: "内容详情")
    /// 内容列表
    static let e013 = LLDJEndpointDef(path: "/media_content/list", method: .get, domain: .media, title: "内容列表")
    /// 短剧流
    static let e014 = LLDJEndpointDef(path: "/media/drama/feed", method: .get, domain: .media, title: "短剧流")
    /// 短剧专题
    static let e015 = LLDJEndpointDef(path: "/media/drama/topics", method: .get, domain: .media, title: "短剧专题")
    /// 专题作品
    static let e016 = LLDJEndpointDef(path: "/media/drama/topic/works", method: .get, domain: .media, title: "专题作品")
    /// 短剧下载授权
    static let e017 = LLDJEndpointDef(path: "/media/drama/download/authorize", method: .post, domain: .media, title: "短剧下载授权")
    /// 短剧信息
    static let e018 = LLDJEndpointDef(path: "/vid/info", method: .get, domain: .media, title: "短剧信息")
    /// 短剧播放
    static let e019 = LLDJEndpointDef(path: "/vid/play", method: .get, domain: .media, title: "短剧播放")
    /// 短剧榜单
    static let e020 = LLDJEndpointDef(path: "/vid/ranking", method: .get, domain: .media, title: "短剧榜单")
    /// 短剧推荐
    static let e021 = LLDJEndpointDef(path: "/vid/recommend/list", method: .get, domain: .media, title: "短剧推荐")
    /// 短剧剧集列表
    static let e022 = LLDJEndpointDef(path: "/vid/section/list", method: .get, domain: .media, title: "短剧剧集列表")
    /// 短剧首页新剧
    static let e023 = LLDJEndpointDef(path: "/vid/home/new/list", method: .get, domain: .media, title: "短剧首页新剧")
    /// 短剧库
    static let e024 = LLDJEndpointDef(path: "/vid/library", method: .get, domain: .media, title: "短剧库")
    /// 短剧库搜索
    static let e025 = LLDJEndpointDef(path: "/vid/library/search", method: .get, domain: .media, title: "短剧库搜索")
    /// 短剧投稿
    static let e026 = LLDJEndpointDef(path: "/vid/submit", method: .post, domain: .media, title: "短剧投稿")
    /// 用户短剧统计
    static let e027 = LLDJEndpointDef(path: "/vid/user/count", method: .get, domain: .media, title: "用户短剧统计")
    /// 社区短剧推荐
    static let e028 = LLDJEndpointDef(path: "/vid/community/recommend", method: .get, domain: .media, title: "社区短剧推荐")
    /// 标签详情
    static let e029 = LLDJEndpointDef(path: "/tag/info", method: .get, domain: .search, title: "标签详情")
    /// 标签媒资
    static let e030 = LLDJEndpointDef(path: "/tag/media/list", method: .get, domain: .search, title: "标签媒资")
    /// 标签短剧
    static let e031 = LLDJEndpointDef(path: "/tag/vid/list", method: .get, domain: .search, title: "标签短剧")
    /// 搜索列表
    static let e032 = LLDJEndpointDef(path: "/search/list", method: .get, domain: .search, title: "搜索列表")
    /// 搜索发布者
    static let e033 = LLDJEndpointDef(path: "/search/publisher/list", method: .get, domain: .search, title: "搜索发布者")
    /// 书架列表
    static let e034 = LLDJEndpointDef(path: "/media_bookshelf/list", method: .get, domain: .interact, title: "书架列表")
    /// 加入书架
    static let e035 = LLDJEndpointDef(path: "/media_bookshelf/add", method: .post, domain: .interact, title: "加入书架")
    /// 移出书架
    static let e036 = LLDJEndpointDef(path: "/media_bookshelf/del", method: .post, domain: .interact, title: "移出书架")
    /// 我的收藏
    static let e037 = LLDJEndpointDef(path: "/mine/collect", method: .get, domain: .interact, title: "我的收藏")
    /// 书架列表
    static let e038 = LLDJEndpointDef(path: "/media_bookshelf/list", method: .get, domain: .interact, title: "书架列表")
    /// 我的已购
    static let e039 = LLDJEndpointDef(path: "/media/my_buy", method: .get, domain: .media, title: "我的已购")
    /// 我的点赞
    static let e040 = LLDJEndpointDef(path: "/mine/like", method: .get, domain: .interact, title: "我的点赞")
    /// 我的发布
    static let e041 = LLDJEndpointDef(path: "/mine/publish", method: .get, domain: .community, title: "我的发布")
    /// 删除发布
    static let e042 = LLDJEndpointDef(path: "/mine/publish/delete", method: .post, domain: .community, title: "删除发布")
    /// 动态消息
    static let e043 = LLDJEndpointDef(path: "/msg/dynamic/list", method: .get, domain: .community, title: "动态消息")
    /// 推荐视频流
    static let e044 = LLDJEndpointDef(path: "/recommend/vid/list", method: .get, domain: .community, title: "推荐视频流")
    /// 二次创作列表
    static let e045 = LLDJEndpointDef(path: "/recreation/list", method: .get, domain: .community, title: "二次创作列表")
    /// 官方号列表
    static let e046 = LLDJEndpointDef(path: "/official/list", method: .get, domain: .community, title: "官方号列表")
    /// 评论列表
    static let e047 = LLDJEndpointDef(path: "/comment/list", method: .get, domain: .community, title: "评论列表")
    /// 评论详情
    static let e048 = LLDJEndpointDef(path: "/comment/info", method: .get, domain: .community, title: "评论详情")
    /// 发送评论
    static let e049 = LLDJEndpointDef(path: "/comment/send", method: .post, domain: .community, title: "发送评论")
    /// IM Token
    static let e050 = LLDJEndpointDef(path: "/im/token", method: .get, domain: .im, title: "IM Token")
    /// 发送消息
    static let e051 = LLDJEndpointDef(path: "/im/message/send", method: .post, domain: .im, title: "发送消息")
    /// 确保好友关系
    static let e052 = LLDJEndpointDef(path: "/im/friend/ensure", method: .post, domain: .im, title: "确保好友关系")
    /// IM 广告
    static let e053 = LLDJEndpointDef(path: "/im/ad", method: .get, domain: .im, title: "IM 广告")
    /// 群归档消息
    static let e054 = LLDJEndpointDef(path: "/v2/group/archive/list", method: .get, domain: .im, title: "群归档消息")
    /// 历史消息初始化
    static let e055 = LLDJEndpointDef(path: "/v2/history/initialization/messages", method: .get, domain: .im, title: "历史消息初始化")
    /// 批量在线状态
    static let e056 = LLDJEndpointDef(path: "/v2/user/presence/status/batch", method: .post, domain: .im, title: "批量在线状态")
    /// 登录
    static let e057 = LLDJEndpointDef(path: "/mine/login", method: .post, domain: .user, title: "登录")
    /// 我的信息
    static let e058 = LLDJEndpointDef(path: "/mine/info", method: .get, domain: .user, title: "我的信息")
    /// 设置头像
    static let e059 = LLDJEndpointDef(path: "/mine/portrait", method: .post, domain: .user, title: "设置头像")
    /// 我的关注
    static let e060 = LLDJEndpointDef(path: "/mine/follow", method: .get, domain: .user, title: "我的关注")
    /// 关注列表
    static let e061 = LLDJEndpointDef(path: "/follow/list", method: .get, domain: .user, title: "关注列表")
    /// 关注动态
    static let e062 = LLDJEndpointDef(path: "/follow/dynamics/list", method: .get, domain: .user, title: "关注动态")
    /// 好友列表
    static let e063 = LLDJEndpointDef(path: "/friend/list", method: .get, domain: .user, title: "好友列表")
    /// 公告列表
    static let e064 = LLDJEndpointDef(path: "/mine/announce/list", method: .get, domain: .user, title: "公告列表")
    /// 认证二维码
    static let e065 = LLDJEndpointDef(path: "/mine/certificate/qr", method: .get, domain: .user, title: "认证二维码")
    /// 我的钱包
    static let e066 = LLDJEndpointDef(path: "/mine/wallet", method: .get, domain: .wallet, title: "我的钱包")
    /// 币种列表
    static let e067 = LLDJEndpointDef(path: "/mine/currencys", method: .get, domain: .wallet, title: "币种列表")
    /// 发起支付
    static let e068 = LLDJEndpointDef(path: "/mine/topay", method: .post, domain: .wallet, title: "发起支付")
    /// 添加银行卡
    static let e069 = LLDJEndpointDef(path: "/mine/txnact/yh/add", method: .post, domain: .wallet, title: "添加银行卡")
    /// 银行卡列表
    static let e070 = LLDJEndpointDef(path: "/mine/txnact/yh/get", method: .get, domain: .wallet, title: "银行卡列表")
    /// 删除交易账户
    static let e071 = LLDJEndpointDef(path: "/mine/txnact/del", method: .post, domain: .wallet, title: "删除交易账户")
    /// 我的账单
    static let e072 = LLDJEndpointDef(path: "/mine/zhangdan", method: .get, domain: .wallet, title: "我的账单")
    /// 提现配置
    static let e073 = LLDJEndpointDef(path: "/withdraw/cfg", method: .get, domain: .wallet, title: "提现配置")
    /// 提现下单
    static let e074 = LLDJEndpointDef(path: "/withdraw/order", method: .post, domain: .wallet, title: "提现下单")
    /// 支付指引
    static let e075 = LLDJEndpointDef(path: "/payment/guide", method: .get, domain: .wallet, title: "支付指引")
    /// 支付指引曝光
    static let e076 = LLDJEndpointDef(path: "/payment/guide/impression", method: .post, domain: .wallet, title: "支付指引曝光")
    /// 金币档位
    static let e077 = LLDJEndpointDef(path: "/video_gold_coin/list", method: .get, domain: .wallet, title: "金币档位")
    /// VIP 商品
    static let e078 = LLDJEndpointDef(path: "/vip/product", method: .get, domain: .vip, title: "VIP 商品")
    /// 优惠券列表
    static let e079 = LLDJEndpointDef(path: "/coupon/list", method: .get, domain: .vip, title: "优惠券列表")
    /// 积分任务
    static let e080 = LLDJEndpointDef(path: "/integral/list", method: .get, domain: .vip, title: "积分任务")
    /// 积分记录
    static let e081 = LLDJEndpointDef(path: "/integral/record/list", method: .get, domain: .vip, title: "积分记录")
    /// 任务列表
    static let e082 = LLDJEndpointDef(path: "/task/list", method: .get, domain: .welfare, title: "任务列表")
    /// 执行任务
    static let e083 = LLDJEndpointDef(path: "/task/do", method: .post, domain: .welfare, title: "执行任务")
    /// 领取任务奖励
    static let e084 = LLDJEndpointDef(path: "/task/receive", method: .post, domain: .welfare, title: "领取任务奖励")
    /// 签到奖励
    static let e085 = LLDJEndpointDef(path: "/checkin/prize", method: .get, domain: .welfare, title: "签到奖励")
    /// 领取签到奖励
    static let e086 = LLDJEndpointDef(path: "/checkin/claim_vip", method: .post, domain: .welfare, title: "领取签到奖励")
    /// 签到点击上报
    static let e087 = LLDJEndpointDef(path: "/checkin/click", method: .post, domain: .welfare, title: "签到点击上报")
    /// 兑换码兑换
    static let e088 = LLDJEndpointDef(path: "/code/exchange", method: .post, domain: .welfare, title: "兑换码兑换")
    /// 邀请信息
    static let e089 = LLDJEndpointDef(path: "/userinvite/info", method: .get, domain: .welfare, title: "邀请信息")
    /// 邀请用户列表
    static let e090 = LLDJEndpointDef(path: "/userinvite/userlist", method: .get, domain: .welfare, title: "邀请用户列表")
    /// AI 模型列表
    static let e091 = LLDJEndpointDef(path: "/ai/mod/list", method: .get, domain: .ai, title: "AI 模型列表")
    /// AI 模型列表 v2
    static let e092 = LLDJEndpointDef(path: "/ai/mod/v2/list", method: .get, domain: .ai, title: "AI 模型列表 v2")
    /// AI 模型详情
    static let e093 = LLDJEndpointDef(path: "/ai/mod/info", method: .get, domain: .ai, title: "AI 模型详情")
    /// AI 广场
    static let e094 = LLDJEndpointDef(path: "/aiplaza/list", method: .get, domain: .ai, title: "AI 广场")
    /// 文生图生成
    static let e095 = LLDJEndpointDef(path: "/ai/img/generate", method: .post, domain: .ai, title: "文生图生成")
    /// 文生图记录
    static let e096 = LLDJEndpointDef(path: "/ai/img/list", method: .get, domain: .ai, title: "文生图记录")
    /// 隐藏文生图
    static let e097 = LLDJEndpointDef(path: "/ai/img/hide", method: .post, domain: .ai, title: "隐藏文生图")
    /// AI 换脸生成
    static let e098 = LLDJEndpointDef(path: "/ai/changeface/generate", method: .post, domain: .ai, title: "AI 换脸生成")
    /// AI 换脸记录
    static let e099 = LLDJEndpointDef(path: "/ai/changeface/list", method: .get, domain: .ai, title: "AI 换脸记录")
    /// 隐藏换脸记录
    static let e100 = LLDJEndpointDef(path: "/ai/changeface/hide", method: .post, domain: .ai, title: "隐藏换脸记录")
    /// 图生视频生成
    static let e101 = LLDJEndpointDef(path: "/ai/imagetovideo/generate", method: .post, domain: .ai, title: "图生视频生成")
    /// 图生视频记录
    static let e102 = LLDJEndpointDef(path: "/ai/imagetovideo/list", method: .get, domain: .ai, title: "图生视频记录")
    /// 隐藏图生视频
    static let e103 = LLDJEndpointDef(path: "/ai/imagetovideo/hide", method: .post, domain: .ai, title: "隐藏图生视频")
    /// AI 文生图生成
    static let e104 = LLDJEndpointDef(path: "/ai/text_to_image/generate", method: .post, domain: .ai, title: "AI 文生图生成")
    /// AI 文生图记录
    static let e105 = LLDJEndpointDef(path: "/ai/text_to_image/list", method: .get, domain: .ai, title: "AI 文生图记录")
    /// 隐藏文生图记录
    static let e106 = LLDJEndpointDef(path: "/ai/text_to_image/hide", method: .post, domain: .ai, title: "隐藏文生图记录")
    /// AI 图像处理生成
    static let e107 = LLDJEndpointDef(path: "/ai/undress/generate", method: .post, domain: .ai, title: "AI 图像处理生成")
    /// AI 图像处理记录
    static let e108 = LLDJEndpointDef(path: "/ai/undress/list", method: .get, domain: .ai, title: "AI 图像处理记录")
    /// 隐藏处理记录
    static let e109 = LLDJEndpointDef(path: "/ai/undress/hide", method: .post, domain: .ai, title: "隐藏处理记录")
    /// AI 文本转小说生成
    static let e110 = LLDJEndpointDef(path: "/ai_text_to_novel/generate", method: .post, domain: .ai, title: "AI 文本转小说生成")
    /// AI 文本转小说记录
    static let e111 = LLDJEndpointDef(path: "/ai_text_to_novel/list", method: .get, domain: .ai, title: "AI 文本转小说记录")
    /// 隐藏小说记录
    static let e112 = LLDJEndpointDef(path: "/ai_text_to_novel/hide", method: .post, domain: .ai, title: "隐藏小说记录")
    /// 分享上报
    static let e113 = LLDJEndpointDef(path: "/share/output", method: .post, domain: .common, title: "分享上报")
    /// STS 上传凭证
    static let e114 = LLDJEndpointDef(path: "/sts/upload/config", method: .get, domain: .common, title: "STS 上传凭证")
    /// 客服地址
    static let e115 = LLDJEndpointDef(path: "/customer/url", method: .get, domain: .common, title: "客服地址")
    /// 广告点击上报
    static let e116 = LLDJEndpointDef(path: "/ads/click/stat", method: .post, domain: .common, title: "广告点击上报")
    /// 验证码通知
    static let e117 = LLDJEndpointDef(path: "/notification/captcha", method: .post, domain: .common, title: "验证码通知")
    /// 意见反馈
    static let e118 = LLDJEndpointDef(path: "/mine/feedback", method: .post, domain: .common, title: "意见反馈")
    /// 下载使用上报
    static let e119 = LLDJEndpointDef(path: "/mine/download/use", method: .post, domain: .common, title: "下载使用上报")
    /// 特权消费
    static let e120 = LLDJEndpointDef(path: "/mine/privilege/consume", method: .post, domain: .common, title: "特权消费")

    static let all: [LLDJEndpointDef] = [e000, e001, e002, e003, e004, e005, e006, e007, e008, e009, e010, e011, e012, e013, e014, e015, e016, e017, e018, e019, e020, e021, e022, e023, e024, e025, e026, e027, e028, e029, e030, e031, e032, e033, e034, e035, e036, e037, e038, e039, e040, e041, e042, e043, e044, e045, e046, e047, e048, e049, e050, e051, e052, e053, e054, e055, e056, e057, e058, e059, e060, e061, e062, e063, e064, e065, e066, e067, e068, e069, e070, e071, e072, e073, e074, e075, e076, e077, e078, e079, e080, e081, e082, e083, e084, e085, e086, e087, e088, e089, e090, e091, e092, e093, e094, e095, e096, e097, e098, e099, e100, e101, e102, e103, e104, e105, e106, e107, e108, e109, e110, e111, e112, e113, e114, e115, e116, e117, e118, e119, e120]

    /// 按域分组
    static func byDomain(_ d: LLDJDomain) -> [LLDJEndpointDef] { all.filter { $0.domain == d } }

    /// 路径检索
    static func search(_ q: String) -> [LLDJEndpointDef] {
        all.filter { $0.path.contains(q) || $0.title.contains(q) }
    }
}
