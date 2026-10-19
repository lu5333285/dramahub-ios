import SwiftUI

/// 根容器：底部四 Tab（首页 / 短剧 / 社区 / 我的），对应 jydj main_page/main_tabbar
struct RootView: View {
    @EnvironmentObject private var session: SessionStore
    @State private var selectedTab = 0
    @State private var showLogin = false

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack { HomeView() }
                .tabItem { Label("首页", systemImage: "house") }
                .tag(0)

            NavigationStack { DramaListView() }
                .tabItem { Label("短剧", systemImage: "tv") }
                .tag(1)

            NavigationStack { CommunityView() }
                .tabItem { Label("社区", systemImage: "bubble.left.and.bubble.right") }
                .tag(2)

            NavigationStack { MineView(showLogin: $showLogin) }
                .tabItem { Label("我的", systemImage: "person") }
                .tag(3)
        }
        .tint(Theme.gold)
        .sheet(isPresented: $showLogin) {
            LoginView()
        }
        .onChange(of: session.isLoggedIn) { loggedIn in
            if loggedIn { showLogin = false }
        }
    }
}
