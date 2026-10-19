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
        .background(Theme.bg.ignoresSafeArea())
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
                    if session.user?.isVIP == true { VIPBadge() }
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

    // MARK: - 功能宫格

    private var menuGrid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
        return LazyVGrid(columns: columns, spacing: 14) {
            menuItem(icon: "calendar.badge.checkmark", title: "每日签到", color: Theme.gold) { CheckinView() }
            menuItem(icon: "list.bullet.clipboard", title: "任务中心", color: Color.orange) { TaskCenterView() }
            menuItem(icon: "person.badge.plus", title: "邀请好友", color: Color.purple) { InviteView() }
            menuItem(icon: "crown", title: "开通会员", color: Theme.gold) { VIPCenterView() }
            menuItem(icon: "heart", title: "我的追剧", color: Theme.live) { CollectionView() }
            menuItem(icon: "arrow.down.circle", title: "我的缓存", color: Color.blue) { CacheView() }
            menuItem(icon: "clock.arrow.circlepath", title: "观看历史", color: Color.teal) { HistoryView() }
            menuItem(icon: "gearshape", title: "设置", color: Theme.textSecondary) { SettingsView() }
        }
    }

    private func menuItem<D: View>(icon: String, title: String, color: Color,
                                   @ViewBuilder destination: () -> D) -> some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(color)
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
