import SwiftUI

@main
struct DramaHubApp: App {
    @StateObject private var session = SessionStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
        }
    }
}

/// 全局会话态：登录状态、钱包摘要、未读消息（对应 jydj 的 global_store / bottom_bar_provider / msg_provider）
final class SessionStore: ObservableObject {
    @Published var isLoggedIn = false
    @Published var user: UserInfoModel?
    @Published var wallet: WalletModel?
    @Published var unreadCount = 0

    /// 昵称（对应 /mine/info 的 nickname，落盘以便启动即读）
    @Published var nickname: String? {
        didSet { UserDefaults.standard.set(nickname, forKey: SessionKeys.nickname) }
    }
    /// 手机号（脱敏展示）
    @Published var phone: String? {
        didSet { UserDefaults.standard.set(phone, forKey: SessionKeys.phone) }
    }
    /// 头像资源名
    @Published var avatar: String? {
        didSet { UserDefaults.standard.set(avatar, forKey: SessionKeys.avatar) }
    }

    private let auth = AuthService()

    init() {
        isLoggedIn = TokenStore.shared.token != nil
        nickname = UserDefaults.standard.string(forKey: SessionKeys.nickname)
        phone = UserDefaults.standard.string(forKey: SessionKeys.phone)
        avatar = UserDefaults.standard.string(forKey: SessionKeys.avatar)
        if isLoggedIn { Task { await refreshProfile() } }
    }

    @MainActor
    func refreshProfile() async {
        do {
            let info = try await auth.profile()
            user = info
            if let n = info.nickname, !n.isEmpty { nickname = n }
            if let p = info.phone, !p.isEmpty { phone = mask(p) }
            wallet = try await auth.wallet()
        } catch {
            if case APIError.unauthorized = error { logout() }
        }
    }

    @MainActor
    func login(phone: String, code: String) async throws {
        let token = try await auth.login(phone: phone, code: code)
        TokenStore.shared.token = token.token
        isLoggedIn = true
        self.phone = mask(phone)
        await refreshProfile()
    }

    func logout() {
        TokenStore.shared.token = nil
        isLoggedIn = false
        user = nil
        wallet = nil
        for k in [SessionKeys.nickname, SessionKeys.phone, SessionKeys.avatar] {
            UserDefaults.standard.removeObject(forKey: k)
        }
        nickname = nil
        phone = nil
        avatar = nil
    }

    /// 手机号脱敏：138****8888
    private func mask(_ p: String) -> String {
        guard p.count == 11 else { return p }
        return p.prefix(3) + "****" + p.suffix(4)
    }
}

/// 会话本地存储键
enum SessionKeys {
    static let nickname = "lldj_nickname"
    static let phone = "lldj_phone"
    static let avatar = "lldj_avatar"
}
