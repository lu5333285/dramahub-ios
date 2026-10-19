import Foundation

// MARK: - IM 域（ImTokenInfo / ImUserModel / ModelFriend）

struct ImTokenInfo: Decodable {
    var token: String?
    var wsUrl: String?
    var expireAt: String?
}

struct ImUser: Decodable, Identifiable {
    let id: String
    var nickname: String?
    var avatar: String?
    var online: Bool = false
}

struct ImMessage: Decodable, Identifiable {
    let id: String
    var fromUser: String?
    var toUser: String?
    var content: String?
    var type: String = "text"      // text / image / video / share
    var createdAt: String?
    var isSelf: Bool = false
}
