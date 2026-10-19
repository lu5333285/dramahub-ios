import SwiftUI

// MARK: - 每日签到（welfare/sign_daily_page）

@MainActor
final class CheckinViewModel: ObservableObject {
    @Published var config: CheckinConfig?
    @Published var signed = false
    @Published var claimedExtra = false

    private let service = MineService()

    func load() async {
        config = try? await service.checkin()
    }

    func signToday() async {
        signed = true
        if var cfg = config {
            for i in cfg.prizes.indices where cfg.prizes[i].day == (cfg.continuousDays + 1) {
                cfg.prizes[i].claimed = true
            }
            cfg.continuousDays += 1
            cfg.signedToday = true
            config = cfg
        }
    }

    func claimExtra() async { claimedExtra = true }
}

struct CheckinView: View {
    @StateObject private var vm = CheckinViewModel()
    @EnvironmentObject private var session: SessionStore

    var body: some View {
        ScrollView {
            if let cfg = vm.config {
                VStack(alignment: .leading, spacing: 18) {
                    // 连续签到
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("已连续签到 \(cfg.continuousDays) 天")
                                .font(Theme.titleFont(16))
                                .foregroundStyle(Theme.textPrimary)
                            if cfg.vipDouble {
                                HStack(spacing: 4) {
                                    VIPBadge()
                                    Text("会员签到奖励翻倍")
                                        .font(Theme.captionFont(11))
                                        .foregroundStyle(Theme.gold)
                                }
                            }
                        }
                        Spacer()
                        Button { Task { await vm.signToday() } } label: {
                            Text(cfg.signedToday ? "今日已签到" : "签到领金币")
                                .font(Theme.bodyFont(13))
                                .foregroundStyle(.black)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(cfg.signedToday ? Theme.textTertiary : Theme.gold)
                                .clipShape(Capsule())
                        }
                        .disabled(cfg.signedToday)
                    }
                    .padding(Theme.hPad)
                    .background(Theme.bgCard)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius))

                    // 7 日奖励
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(cfg.prizes) { prize in
                            VStack(spacing: 5) {
                                Text("第 \(prize.day) 天")
                                    .font(Theme.captionFont(10))
                                    .foregroundStyle(Theme.textTertiary)
                                Image(systemName: prize.claimed ? "checkmark.circle.fill" : "circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(prize.claimed ? Theme.gold : Theme.textTertiary)
                                CoinBadge(amount: prize.coin, compact: true)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(prize.claimed ? Theme.gold.opacity(0.08) : Theme.bgCard)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }

                    // 额外奖励
                    if cfg.canClaimExtra {
                        Button { Task { await vm.claimExtra() } } label: {
                            HStack {
                                Image(systemName: "gift")
                                Text("领取连续签到额外奖励")
                                    .font(Theme.bodyFont(14))
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundStyle(Theme.gold)
                            .padding(Theme.hPad)
                            .background(Theme.gold.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                        }
                    }
                }
                .padding(Theme.hPad)
            }
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle("每日签到")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load() }
        .alert("签到成功", isPresented: $vm.signed) {
            Button("好的", role: .cancel) { }
        } message: {
            Text("演示模式：金币奖励已到账")
        }
        .alert("领取成功", isPresented: $vm.claimedExtra) {
            Button("好的", role: .cancel) { }
        } message: {
            Text("演示模式：额外奖励已到账")
        }
    }
}

// MARK: - 任务中心（welfare/task_widgets）

@MainActor
final class TaskCenterViewModel: ObservableObject {
    @Published var tasks: [DailyTask] = []
    @Published var claimedId: String?

    private let service = MineService()

    func load() async { tasks = (try? await service.tasks()) ?? [] }

    func claim(_ task: DailyTask) async {
        claimedId = task.id
        if let idx = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[idx].status = "claimed"
        }
    }
}

struct TaskCenterView: View {
    @StateObject private var vm = TaskCenterViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(vm.tasks) { task in
                    HStack(spacing: 12) {
                        Image(systemName: task.icon ?? "star")
                            .font(.system(size: 20))
                            .foregroundStyle(Theme.gold)
                            .frame(width: 40, height: 40)
                            .background(Theme.bgCard)
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.name ?? "")
                                .font(Theme.bodyFont(14))
                                .foregroundStyle(Theme.textPrimary)
                            Text(task.desc ?? "")
                                .font(Theme.captionFont(10))
                                .foregroundStyle(Theme.textTertiary)
                            if task.target > 1 {
                                ProgressView(value: Double(task.progress), total: Double(task.target))
                                    .tint(Theme.gold)
                                    .frame(width: 120)
                            }
                        }
                        Spacer()
                        switch task.status {
                        case "claimed":
                            Text("已领取")
                                .font(Theme.captionFont(12))
                                .foregroundStyle(Theme.textTertiary)
                        case "done":
                            Button { Task { await vm.claim(task) } } label: {
                                Text("领奖励")
                                    .font(Theme.captionFont(12))
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.gold)
                                    .clipShape(Capsule())
                            }
                        case "doing":
                            Text("\(task.progress)/\(task.target)")
                                .font(Theme.captionFont(12))
                                .foregroundStyle(Theme.gold)
                        default:
                            Text("去完成")
                                .font(Theme.captionFont(12))
                                .foregroundStyle(Theme.textTertiary)
                        }
                    }
                    .padding(Theme.hPad)
                    .background(Theme.bgCard)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                }
            }
            .padding(Theme.hPad)
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle("任务中心")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load() }
        .alert("领取成功", isPresented: .constant(vm.claimedId != nil)) {
            Button("好的", role: .cancel) { vm.claimedId = nil }
        } message: {
            Text("演示模式：金币奖励已到账")
        }
    }
}

// MARK: - 邀请好友（mine_setting/invite_bind_page）

@MainActor
final class InviteViewModel: ObservableObject {
    @Published var info: InviteInfo?
    @Published var bound = false
    @Published var bindCode = ""

    private let service = MineService()

    func load() async { info = try? await service.inviteInfo() }

    func bind() async {
        bound = true
        try? await service.bindInvite(code: bindCode)
    }
}

struct InviteView: View {
    @StateObject private var vm = InviteViewModel()
    @EnvironmentObject private var session: SessionStore

    var body: some View {
        ScrollView {
            if let info = vm.info {
                VStack(spacing: 18) {
                    // 邀请码卡片
                    VStack(spacing: 10) {
                        Text("我的邀请码")
                            .font(Theme.captionFont(12))
                            .foregroundStyle(Theme.textTertiary)
                        Text(info.code ?? "")
                            .font(.system(size: 30, weight: .bold, design: .monospaced))
                            .foregroundStyle(Theme.gold)
                        Text(info.rewardDesc ?? "")
                            .font(Theme.captionFont(12))
                            .foregroundStyle(Theme.textSecondary)
                        Button {
                            UIPasteboard.general.string = info.code
                        } label: {
                            Label("复制邀请码", systemImage: "doc.on.doc")
                                .font(Theme.bodyFont(13))
                                .foregroundStyle(.black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Theme.gold)
                                .clipShape(Capsule())
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(
                        LinearGradient(colors: [Theme.goldDim.opacity(0.3), Theme.bgCard],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radiusLG, style: .continuous))

                    // 统计
                    HStack(spacing: 12) {
                        statItem(value: "\(info.inviteCount)", title: "累计邀请")
                        statItem(value: "\(info.validCount)", title: "有效邀请")
                        statItem(value: "\(info.validCount * 3)", title: "获赠 VIP 天数")
                    }

                    // 邀请方式
                    VStack(alignment: .leading, spacing: 10) {
                        Text("邀请方式")
                            .font(Theme.titleFont(15))
                            .foregroundStyle(Theme.textPrimary)
                        shareRow(icon: "link", title: "复制链接")
                        shareRow(icon: "square.and.arrow.up", title: "分享海报")
                        shareRow(icon: "qrcode", title: "二维码")
                    }

                    // 绑定邀请码
                    if !info.bound {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("绑定邀请码")
                                .font(Theme.titleFont(15))
                                .foregroundStyle(Theme.textPrimary)
                            HStack {
                                TextField("请输入邀请码", text: $vm.bindCode)
                                    .font(Theme.bodyFont(14))
                                    .padding(12)
                                    .background(Theme.bgCard)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .foregroundStyle(Theme.textPrimary)
                                Button { Task { await vm.bind() } } label: {
                                    Text("绑定")
                                        .font(Theme.bodyFont(13))
                                        .foregroundStyle(.black)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(Theme.gold)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .disabled(vm.bindCode.isEmpty)
                            }
                        }
                    }
                }
                .padding(Theme.hPad)
            }
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle("邀请好友")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load() }
        .alert("绑定成功", isPresented: $vm.bound) {
            Button("好的", role: .cancel) { }
        } message: {
            Text("演示模式：邀请码已绑定")
        }
    }

    private func statItem(value: String, title: String) -> some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.textPrimary)
            Text(title)
                .font(Theme.captionFont(11))
                .foregroundStyle(Theme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Theme.bgCard)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
    }

    private func shareRow(icon: String, title: String) -> some View {
        Button {} label: {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                    .foregroundStyle(Theme.gold)
                Text(title)
                    .font(Theme.bodyFont(14))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(Theme.captionFont(11))
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(Theme.hPad)
            .background(Theme.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
        }
    }
}
