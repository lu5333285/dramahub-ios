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

    private let auth = AuthService()

    init() {
        isLoggedIn = TokenStore.shared.token != nil
        if isLoggedIn { Task { await refreshProfile() } }
    }

    @MainActor
    func refreshProfile() async {
        do {
            user = try await auth.profile()
            wallet = try await auth.wallet()
        } catch {
            if case APIError.unauthorized = error { logout() }
        }
    }

    @MainActor
    func login(phone: String, code: String) async throws {
        let token = try await auth.login(phone: phone, code: code)
        TokenStore.shared.token = token
        isLoggedIn = true
        await refreshProfile()
    }

    func logout() {
        TokenStore.shared.token = nil
        isLoggedIn = false
        user = nil
        wallet = nil
    }
}
