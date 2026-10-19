import Foundation

/// 端点目录：与 §4 分析报告中的 130 个端点一一对应（按域分组）
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

struct APIEndpoint {
    let path: String
    let method: HTTPMethod
    var query: [URLQueryItem] = []

    init(_ path: String, _ method: HTTPMethod = .post, query: [URLQueryItem] = []) {
        self.path = path
        self.method = method
        self.query = query
    }
}

// MARK: - 端点定义（路径字符串与 jydj Dart 层一致）

extension APIEndpoint {
    /// 域名配置（对应 /ping/domain、encryptedConfig 动态下发；此处为初始值）
    static var baseURL: String { Config.apiBaseURL }

    // 媒资 / 内容
    static func dramaFeed(page: Int, size: Int = 20) -> APIEndpoint {
        APIEndpoint("/media/drama/feed", .get,
                    query: [.init(name: "page", value: "\(page)"), .init(name: "pageSize", value: "\(size)")])
    }
    static func dramaTopics() -> APIEndpoint { APIEndpoint("/media/drama/topics", .get) }
    static func dramaTopicWorks(id: String) -> APIEndpoint {
        APIEndpoint("/media/drama/topic/works", .get, query: [.init(name: "topicId", value: id)])
    }
    static func mediaRecommend(page: Int) -> APIEndpoint {
        APIEndpoint("/media/recommend", .get, query: [.init(name: "page", value: "\(page)")])
    }
    static func mediaRanking() -> APIEndpoint { APIEndpoint("/media/ranking", .get) }
    static func mediaSearch(keyword: String, page: Int) -> APIEndpoint {
        APIEndpoint("/media/search", .get,
                    query: [.init(name: "keyword", value: keyword), .init(name: "page", value: "\(page)")])
    }
    static func mediaInfo(id: String) -> APIEndpoint {
        APIEndpoint("/media/info", .get, query: [.init(name: "mediaId", value: id)])
    }
    static let dramaDownloadAuthorize = APIEndpoint("/media/drama/download/authorize")

    // 短剧
    static func vidInfo(id: String) -> APIEndpoint {
        APIEndpoint("/vid/info", .get, query: [.init(name: "vid", value: id)])
    }
    static func vidPlay(id: String) -> APIEndpoint {
        APIEndpoint("/vid/play", .get, query: [.init(name: "vid", value: id)])
    }
    static let vidRanking = APIEndpoint("/vid/ranking", .get)
    static func vidRecommend(page: Int) -> APIEndpoint {
        APIEndpoint("/vid/recommend/list", .get, query: [.init(name: "page", value: "\(page)")])
    }
    static func vidSectionChange(id: String) -> APIEndpoint {
        APIEndpoint("/vid/section/changeVideo/", .get, query: [.init(name: "sectionId", value: id)])
    }

    // 首页
    static let bannerList = APIEndpoint("/banner/list", .get)
    static func modulesList() -> APIEndpoint { APIEndpoint("/modules/list", .get) }
    static func tagInfo(id: String) -> APIEndpoint {
        APIEndpoint("/tag/info", .get, query: [.init(name: "tagId", value: id)])
    }
    static func tagMediaList(id: String, page: Int) -> APIEndpoint {
        APIEndpoint("/tag/media/list", .get,
                    query: [.init(name: "tagId", value: id), .init(name: "page", value: "\(page)")])
    }

    // 搜索
    static func searchList(keyword: String, page: Int) -> APIEndpoint {
        APIEndpoint("/search/list", .get,
                    query: [.init(name: "keyword", value: keyword), .init(name: "page", value: "\(page)")])
    }

    // 用户
    static let mineInfo = APIEndpoint("/mine/info", .get)
    static let mineWallet = APIEndpoint("/mine/wallet", .get)
    static func mineLogin(phone: String, code: String) -> APIEndpoint { APIEndpoint("/mine/login") }
    static func mineMobileLoginOnly(phone: String, code: String) -> APIEndpoint { APIEndpoint("/mine/mobileLoginOnly") }
    static let mineCollect = APIEndpoint("/mine/collect", .get)
    static let mineCollectInfoList = APIEndpoint("/mine/collect/infoList", .get)
    static let mineLike = APIEndpoint("/mine/like", .get)
    static let mineFollow = APIEndpoint("/mine/follow", .get)
    static let mineIncomes = APIEndpoint("/mine/iIncomes", .get)
    static let minePublish = APIEndpoint("/mine/publish", .get)
    static let mineTransactionH = APIEndpoint("/mine/transactionH", .get)
    static let mineBuyVid = APIEndpoint("/mine/buyVid", .get)
    static func minePortraitUpload() -> APIEndpoint { APIEndpoint("/mine/portrait") }
    static let mineFeedback = APIEndpoint("/mine/feedback")

    // 购买 / 支付
    static let vipProduct = APIEndpoint("/vip/product", .get)
    static func productBuy() -> APIEndpoint { APIEndpoint("/product/buy") }
    static func paymentGuide() -> APIEndpoint { APIEndpoint("/payment/guide", .get) }
    static func couponList() -> APIEndpoint { APIEndpoint("/coupon/list", .get) }
    static func codeExchange() -> APIEndpoint { APIEndpoint("/code/exchange") }

    // 提现
    static let withdrawCfg = APIEndpoint("/withdraw/cfg", .get)
    static func withdrawApply() -> APIEndpoint { APIEndpoint("/withdraw") }
    static let withdrawOrder = APIEndpoint("/withdraw/order", .get)

    // 签到 / 任务
    static func checkinPrize() -> APIEndpoint { APIEndpoint("/checkin/prize") }
    static func checkinClick() -> APIEndpoint { APIEndpoint("/checkin/click") }
    static func taskList() -> APIEndpoint { APIEndpoint("/task/list", .get) }
    static func taskDo(id: String) -> APIEndpoint { APIEndpoint("/task/do") }
    static func taskReceive(id: String) -> APIEndpoint { APIEndpoint("/task/receive") }

    // 评论
    static func commentList(id: String, page: Int) -> APIEndpoint {
        APIEndpoint("/comment/list", .get,
                    query: [.init(name: "mediaId", value: id), .init(name: "page", value: "\(page)")])
    }
    static func commentSend() -> APIEndpoint { APIEndpoint("/comment/send") }
    static func thumbsUp() -> APIEndpoint { APIEndpoint("/thumbsUp") }
    static func thumbsDown() -> APIEndpoint { APIEndpoint("/thumbsDown") }

    // 邀请
    static func userinviteInfo() -> APIEndpoint { APIEndpoint("/userinvite/info", .get) }
    static func mineInviteBind() -> APIEndpoint { APIEndpoint("/mine/inviteBind") }

    // 社区
    static func communityRecommend(page: Int) -> APIEndpoint {
        APIEndpoint("/vid/community/recommend", .get, query: [.init(name: "page", value: "\(page)")])
    }
    static func followDynamics(page: Int) -> APIEndpoint {
        APIEndpoint("/follow/dynamics/list", .get, query: [.init(name: "page", value: "\(page)")])
    }

    // 直播
    static func liveModuleList() -> APIEndpoint { APIEndpoint("/live/module/list/91porn", .get) }
    static func liveAnchorList(moduleId: String) -> APIEndpoint {
        APIEndpoint("/live/anchor/list/91porn", .get, query: [.init(name: "moduleId", value: moduleId)])
    }
    static func liveAnchorWatch(anchorId: String) -> APIEndpoint {
        APIEndpoint("/live/anchor/watch/91porn", .get, query: [.init(name: "anchorId", value: anchorId)])
    }

    // AI
    static func aiModList() -> APIEndpoint { APIEndpoint("/ai/mod/v2/list", .get) }
    static func aiModInfo(id: String) -> APIEndpoint {
        APIEndpoint("/ai/mod/info", .get, query: [.init(name: "modId", value: id)])
    }
    static func aiGenerate(_ sub: String) -> APIEndpoint { APIEndpoint("/ai/\(sub)/generate") }
    static func aiList(_ sub: String) -> APIEndpoint { APIEndpoint("/ai/\(sub)/list", .get) }
    static let aiTextToNovelGenerate = APIEndpoint("/ai_text_to_novel/generate")
    static let aiMateURL = APIEndpoint("/aimatev2/url", .get)
    static let customerURL = APIEndpoint("/customer/url", .get)

    // IM
    static let imToken = APIEndpoint("/im/token")
    static let imMessageSend = APIEndpoint("/im/message/send")
    static func imFriendEnsure() -> APIEndpoint { APIEndpoint("/im/friend/ensure") }
    static let imHistoryInit = APIEndpoint("/v2/history/initialization/messages")

    // 上传
    static let stsUploadConfig = APIEndpoint("/sts/upload/config", .get)
    static func vidSubmit() -> APIEndpoint { APIEndpoint("/vid/submit") }

    // 运维
    static let appPingCheck = APIEndpoint("/api/app/ping/check", .get)
    static let domainRefresh = APIEndpoint("/ping/domain/refresh", .get)
    static let eventTracking = APIEndpoint("/api/eventTracking/batchReport.json")
}
