import Foundation

// MARK: - 媒资域（MediaContent / DramaMediaInfo / DramaFeedItem / VideoModel）

/// 统一媒资内容：短剧、长视频、漫画、小说共用（对应 hj_model/media_content.dart）
struct MediaContent: Decodable, Identifiable, Hashable {
    let id: String
    var title: String?
    var cover: String?
    var desc: String?
    var type: String?              // drama / video / cartoon / novel
    var episodeCount: Int?
    var playCount: Int?
    var likeCount: Int?
    var isVipOnly: Bool?
    var coinPrice: Int?            // 金币解锁价（0 = 免费）
    var tags: [String]?
    var score: Double?
    var updatedAt: String?
    var author: MediaAuthor?

    struct MediaAuthor: Decodable, Hashable {
        var id: String?
        var nickname: String?
        var avatar: String?
    }
}

/// 短剧详情（DramaMediaInfo）
struct DramaMediaInfo: Decodable, Identifiable {
    let id: String
    var title: String?
    var cover: String?
    var desc: String?
    var episodes: [DramaEpisode] = []
    var isVipOnly: Bool?
    var coinPrice: Int?
    var playCount: Int?
    var likeCount: Int?
    var favorited: Bool?
    var resumeEpisodeId: String?   // 续播（drama_resume_store）

    struct DramaEpisode: Decodable, Identifiable {
        let id: String
        var index: Int = 0
        var title: String?
        var locked: Bool = false
        var free: Bool = false
        var duration: Int?          // 秒
    }
}

/// 播放信息（DramaUnlockResult / 对应 /vid/play）
struct PlayInfo: Decodable {
    var url: String?               // m3u8 地址
    var backupUrls: [String] = []  // 备用线路
    var isH265: Bool = false
    var duration: Int = 0
    var needUnlock: Bool = false
    var unlockPrice: Int = 0
    var freeSeconds: Int = 0       // 免费试看秒数（free_play_manager）
}

/// 付费墙（DramaPaywall）
struct Paywall: Decodable {
    var title: String?
    var desc: String?
    var coinPrice: Int = 0
    var vipPrice: Double = 0
    var freeRemain: Int = 0        // 今日剩余免费次数
}

/// 下载授权（DramaDownloadAuth）
struct DownloadAuth: Decodable {
    var authorized: Bool = false
    var remainCount: Int = 0
}
