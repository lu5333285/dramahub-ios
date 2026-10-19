import Foundation

// MARK: - 首页域（HomePlateModel / ModuleData / BannerJumpEntity）

struct HomeModule: Decodable, Identifiable {
    let id: String
    var name: String?              // 推荐 / 热播 / 榜单 / 专题 …
    var icon: String?
    var sort: Int = 0
    var items: [MediaContent] = []
}

struct BannerItem: Decodable, Identifiable {
    let id: String
    var image: String?
    var jumpType: String?          // media / h5 / live
    var jumpValue: String?
    var title: String?
}

/// 首页聚合（对应 home_main_logic 的首页数据）
struct HomeData: Decodable {
    var banners: [BannerItem] = []
    var modules: [HomeModule] = []
    var hotKeywords: [String] = []
}

// MARK: - 社区域（post / 评论）

struct CommunityPost: Decodable, Identifiable, Hashable {
    let id: String
    var content: String?
    var images: [String] = []
    var videoUrl: String?
    var author: CommunityAuthor?
    var likeCount: Int = 0
    var commentCount: Int = 0
    var liked: Bool = false
    var createdAt: String?
    var tags: [String] = []

    struct CommunityAuthor: Decodable, Hashable {
        var id: String?
        var nickname: String?
        var avatar: String?
        var isCreator: Bool = false
    }
}

struct CommentModel: Decodable, Identifiable {
    let id: String
    var content: String?
    var user: CommentUser?
    var likeCount: Int = 0
    var liked: Bool = false
    var createdAt: String?
    var replyCount: Int = 0
    var replies: [CommentModel] = []

    struct CommentUser: Decodable {
        var id: String?
        var nickname: String?
        var avatar: String?
    }
}

struct CommentListRes: Decodable {
    var list: [CommentModel] = []
    var total: Int = 0
    var page: Int = 1
}

// MARK: - 签到 / 任务域（CheckinConfig / DailyTask / TaskCenterData）

struct CheckinConfig: Decodable {
    var signedToday: Bool = false
    var continuousDays: Int = 0
    var vipDouble: Bool = false
    var prizes: [CheckinPrize] = []
    var canClaimExtra: Bool = false

    struct CheckinPrize: Decodable, Identifiable {
        let id: String
        var day: Int = 0
        var reward: String?         // "+10 金币"
        var coin: Int = 0
        var claimed: Bool = false
        var isDouble: Bool = false
    }
}

struct DailyTask: Decodable, Identifiable {
    let id: String
    var name: String?
    var desc: String?
    var reward: Int = 0            // 金币奖励
    var progress: Int = 0
    var target: Int = 1
    var status: String?            // todo / doing / done / claimed
    var icon: String?
}

// MARK: - 邀请域

struct InviteInfo: Decodable {
    var code: String?
    var inviteCount: Int = 0
    var validCount: Int = 0
    var rewardDesc: String?
    var bound: Bool = false
}
