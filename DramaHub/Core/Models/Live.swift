import Foundation

// MARK: - 直播域（LiveModule / LiveAnchor / LiveRecom）

struct LiveModule: Decodable, Identifiable {
    let id: String
    var name: String?
    var icon: String?
    var anchorCount: Int = 0
}

struct LiveAnchor: Decodable, Identifiable {
    let id: String
    var nickname: String?
    var avatar: String?
    var cover: String?
    var viewers: Int = 0
    var isLive: Bool = true
    var tags: [String] = []
    var moduleId: String?
}

// MARK: - AI 域（AiModList / AICategoryMod）

struct AIModule: Decodable, Identifiable {
    let id: String
    var name: String?              // AI 绘画 / 文生图 / 换脸 / 图生视频 / AI 小说 / AI 女友
    var desc: String?
    var icon: String?
    var category: String?
    var coinCost: Int = 0
    var isVipFree: Bool = false
    var hot: Bool = false
}

/// AI 生成记录（AiRecordModel）
struct AIRecord: Decodable, Identifiable {
    let id: String
    var type: String?              // img / video / novel
    var status: String?            // pending / doing / success / failed
    var resultUrl: String?
    var cover: String?
    var createdAt: String?
    var coinCost: Int = 0
}
