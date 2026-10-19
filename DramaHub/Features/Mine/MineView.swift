import SwiftUI

@MainActor
final class MineViewModel: ObservableObject {
    @Published var bills: [BillItemModel] = []
    @Published var history: [PlaybackStore.HistoryItem] = []

    private let mineService = MineService()

    func load() async {
        bills = (try? await mineService.bills(page: 1)) ?? []
        history = PlaybackStore.shared.history()
    }
}

struct MineView: View {
    @Binding var showLogin: Bool
    @StateObject private var vm = MineViewModel()
    @EnvironmentObject private var session: SessionStore

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                walletCard
                menuGrid
                if !vm.history.isEmpty { historySection }
            }
            .padding(Theme.hPad)
        }
        // 真实背景素材：mine/mine_background.webp
        .background(
            ZStack(alignment: .top) {
                Theme.bg.ignoresSafeArea()
                AssetLibrary.image(Theme.mineBg)
                    .map { $0.resizable().aspectRatio(contentMode: .fill) }
                    .ignoresSafeArea()
                    .opacity(0.9)
            }
        )
        .navigationTitle("我的")
        .task { await vm.load() }
    }

    // MARK: - 头部

    private var header: some View {
        HStack(spacing: 12) {
            NetworkImage(session.user?.avatar)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    Text(session.user?.nickname ?? "未登录")
                        .font(Theme.titleFont(17))
                        .foregroundStyle(Theme.textPrimary)
                    if let lv = session.user?.vipLevel, lv > 0 {
                        VIPBadge(level: lv)
                    }
                }
                Text("ID: \(session.user?.id ?? "--") · 邀请码 \(session.user?.inviteCode ?? "--")")
                    .font(Theme.captionFont(11))
                    .foregroundStyle(Theme.textTertiary)
            }
            Spacer()
            if session.isLoggedIn {
                Button("退出") { session.logout() }
                    .font(Theme.captionFont(12))
                    .foregroundStyle(Theme.textSecondary)
            } else {
                Button("登录/注册") { showLogin = true }
                    .font(Theme.bodyFont(13))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(Theme.gold)
                    .clipShape(Capsule())
            }
        }
        .padding(.top, 8)
    }

    // MARK: - 钱包卡片（mine_vip）

    private var walletCard: some View {
        HStack(spacing: 0) {
            walletItem(title: "金币", value: "\(session.user?.coin ?? 0)", color: Theme.gold) { RechargeView() }
            Divider().frame(height: 30).overlay(Theme.separator)
            walletItem(title: "积分", value: "\(session.user?.integral ?? 0)", color: Theme.brand) { ExchangeView() }
            Divider().frame(height: 30).overlay(Theme.separator)
            walletItem(title: "收益(元)", value: String(format: "%.2f", session.user?.balance ?? 0), color: Color.green) { WithdrawView() }
        }
        .padding(.vertical, 16)
        .background(Theme.bgCard)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radius, style: .continuous))
    }

    private func walletItem<D: View>(title: String, value: String, color: Color,
                                     @ViewBuilder destination: () -> D) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(Theme.captionFont(11))
                .foregroundStyle(Theme.textTertiary)
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(color)
            NavigationLink(destination: destination) {
                Text("查看")
                    .font(Theme.captionFont(11))
                    .foregroundStyle(Theme.gold)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - 功能宫格（图标全部取自真实素材 mine/mine_menu_*.png）

    private var menuGrid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
        return LazyVGrid(columns: columns, spacing: 14) {
            menuItem(asset: LLDJAsset.mine_icon_sign_click, title: "每日签到") { CheckinView() }
            menuItem(asset: LLDJAsset.mine_mine_menu_welfare, title: "任务中心") { TaskCenterView() }
            menuItem(asset: LLDJAsset.mine_add_equal, title: "邀请好友") { InviteView() }
            menuItem(asset: LLDJAsset.mine_ic_vip_enter, title: "开通会员") { VIPCenterView() }
            menuItem(asset: LLDJAsset.mine_mine_collect, title: "我的追剧") { CollectionView() }
            menuItem(asset: LLDJAsset.video_cache_start, title: "我的缓存") { CacheView() }
            menuItem(asset: LLDJAsset.mine_mine_menu_records, title: "观看历史") { HistoryView() }
            menuItem(asset: LLDJAsset.mine_setting, title: "设置") { SettingsView() }

            menuItem(asset: LLDJAsset.mine_mine_follow, title: "我的关注") { PlaceholderPage(title: "我的关注", subtitle: LLDJText.myFollow) }
            menuItem(asset: LLDJAsset.mine_mine_menu_likes, title: "我的喜欢") { PlaceholderPage(title: "我的喜欢", subtitle: LLDJText.myLikes) }
            menuItem(asset: LLDJAsset.mine_mine_post, title: "我的发布") { PlaceholderPage(title: "我的发布", subtitle: LLDJText.myRecords) }
            menuItem(asset: LLDJAsset.mine_mine_menu_creator, title: "创作者中心") { PlaceholderPage(title: "创作者中心", subtitle: LLDJText.myCreator) }
            menuItem(asset: LLDJAsset.mine_mine_notification, title: "消息通知") { PlaceholderPage(title: "消息通知", subtitle: LLDJText.myRecords) }
            menuItem(asset: LLDJAsset.mine_mine_menu_roles, title: "我的角色") { PlaceholderPage(title: "我的角色", subtitle: LLDJText.myRoles) }
            menuItem(asset: LLDJAsset.mine_mine_menu_preference, title: "偏好设置") { SettingsView() }
            menuItem(asset: LLDJAsset.mine_mine_menu_about, title: "关于我们") { PlaceholderPage(title: "关于我们", subtitle: LLDJText.officialContact) }
        }
    }

    private func menuItem<D: View>(asset: String, title: String,
                                   @ViewBuilder destination: () -> D) -> some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 8) {
                AssetLibrary.image(asset)
                    .map { $0.resizable().aspectRatio(contentMode: .fit) }
                    ?? Image(systemName: "square.grid.2x2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Theme.textSecondary)
                        .frame(width: 24, height: 24)
                Text(title)
                    .font(Theme.captionFont(11))
                    .foregroundStyle(Theme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radius, style: .continuous))
        }
    }

    // MARK: - 观看历史

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("观看历史")
                    .font(Theme.titleFont(15))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Text("全部")
                    .font(Theme.captionFont(11))
                    .foregroundStyle(Theme.textTertiary)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(vm.history.prefix(10)) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            NetworkImage(item.cover)
                                .frame(width: 100, height: 134)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Text(item.title ?? "")
                                .font(Theme.captionFont(11))
                                .foregroundStyle(Theme.textSecondary)
                                .lineLimit(1)
                        }
                    }
                }
            }
        }
    }
}
