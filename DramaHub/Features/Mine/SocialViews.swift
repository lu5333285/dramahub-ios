import SwiftUI

// 「我的」子模块续 —— 对应原 APK hj_page/mine/ 下其余 .dart 文件：
//   mine_post/            我的发布（mine_publish_main/sub）
//   mine_following/       我的关注（mine_following_view / follow_sub）
//   mine_share/           我的分享（mine_share_page / mine_share_record）
//   mine_drive/           我的推广（mine_drive_page）
//   mine_profit/          收益与银行卡（bank_card_home_page）
//   make_money/           提现与收益明细（withdrawal_page / mine_withdrawal_record）
//   collec_history_buy/   购买记录（col_his_buy_page）

// MARK: - 我的发布（mine_post/mine_publish_main_page.dart）

struct MyPublishView: View {
    @EnvironmentObject private var session: SessionStore
    @State private var tab = 0
    @State private var posts: [CommunityPost] = []
    @State private var loading = false

    private let tabs = ["全部", "视频", "图文", "审核中"]

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $tab) {
                ForEach(tabs, id: \.self) { Text($0).tag(tabs.firstIndex(of: $0) ?? 0) }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, Theme.hPad)
            .padding(.vertical, 10)

            if loading && posts.isEmpty {
                Spacer()
                ProgressView().tint(Theme.gold)
                Spacer()
            } else if posts.isEmpty {
                Spacer()
                placeholder(title: "我的发布", icon: "square.and.pencil",
                            desc: LLDJText.myRecords)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(posts) { p in
                            CommunityPostCell(post: p)
                        }
                    }
                    .padding(Theme.hPad)
                }
            }
        }
        .background(Theme.bg)
        .navigationTitle("我的发布")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            guard session.isLoggedIn else { return }
            loading = true
            defer { loading = false }
            posts = (try? await CommunityService().myPublish()) ?? []
        }
    }
}

// MARK: - 我的关注（mine_following/mine_following_view.dart）

struct MyFollowingView: View {
    @State private var users: [CommunityUser] = []
    var body: some View {
        Group {
            if users.isEmpty {
                placeholder(title: "我的关注", icon: "heart",
                            desc: LLDJText.myFollow)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(users) { u in
                            HStack(spacing: 12) {
                                NetworkImage(u.avatar).frame(width: 44, height: 44)
                                    .clipShape(Circle())
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(u.nickname)
                                        .font(Theme.bodyFont(15))
                                        .foregroundStyle(Theme.textPrimary)
                                    Text(u.signature ?? "")
                                        .font(Theme.captionFont(11))
                                        .foregroundStyle(Theme.textTertiary)
                                        .lineLimit(1)
                                }
                                Spacer()
                                Button("已关注") {}
                                    .font(Theme.captionFont(12))
                                    .foregroundStyle(Theme.textSecondary)
                                    .padding(.horizontal, 12).padding(.vertical, 5)
                                    .background(Theme.bgCardHi, in: Capsule())
                                    .disabled(true)
                            }
                            .padding(.horizontal, Theme.hPad)
                            .padding(.vertical, 12)
                            Divider().overlay(Theme.separator).padding(.leading, 72)
                        }
                    }
                }
            }
        }
        .background(Theme.bg)
        .navigationTitle("我的关注")
        .navigationBarTitleDisplayMode(.inline)
        .task { users = (try? await CommunityService().following()) ?? [] }
    }
}

// MARK: - 我的喜欢（mine/like）

struct MyLikeView: View {
    @State private var items: [MediaContent] = []
    var body: some View {
        Group {
            if items.isEmpty {
                placeholder(title: "我的喜欢", icon: "hand.thumbsup", desc: LLDJText.myLikes)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(items) { m in
                            MediaRow(item: m)
                        }
                    }
                    .padding(Theme.hPad)
                }
            }
        }
        .background(Theme.bg)
        .navigationTitle("我的喜欢")
        .navigationBarTitleDisplayMode(.inline)
        .task { items = (try? await HomeService().myLikes()) ?? [] }
    }
}

// MARK: - 我的分享（mine_share/mine_share_page.dart）

struct MyShareView: View {
    @State private var amount = "0"
    @State private var code = ""
    var body: some View {
        ZStack {
            AssetBackground(asset: LLDJAsset.mine_mine_background)
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 6) {
                        Text("累计收益")
                            .font(Theme.captionFont(12))
                            .foregroundStyle(Theme.textSecondary)
                        Text("¥\(amount)")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundStyle(Theme.gold)
                        Text("可提现收益以钱包余额为准")
                            .font(Theme.captionFont(11))
                            .foregroundStyle(Theme.textTertiary)
                    }
                    .padding(.vertical, 24)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("邀请码")
                            .font(Theme.bodyFont(14))
                            .foregroundStyle(Theme.textSecondary)
                        HStack {
                            TextField(code.isEmpty ? LLDJText.unboundInvite : code, text: $code)
                                .padding(12)
                                .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(Theme.textPrimary)
                            Button("复制") {
                                UIPasteboard.general.string = code
                            }
                            .font(Theme.captionFont(12))
                            .foregroundStyle(Theme.gold)
                        }
                        Text(LLDJText.inviteNotice)
                            .font(Theme.captionFont(11))
                            .foregroundStyle(Theme.textTertiary)
                    }
                    .padding(14)
                    .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))

                    NavigationLink { ShareRecordView() } label: {
                        HStack {
                            Text("分享记录").font(Theme.bodyFont(15))
                                .foregroundStyle(Theme.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.right").font(.system(size: 11))
                                .foregroundStyle(Theme.textTertiary)
                        }
                        .padding(14)
                        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                .padding(Theme.hPad)
            }
        }
        .navigationTitle("我的分享")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 分享记录（mine_share/mine_share_record_page.dart）

struct ShareRecordView: View {
    private let records: [(String, String, String)] = [
        ("分享至微信", "裂变宝-短剧", "3 天前"),
        ("生成推广海报", "首页横幅位", "5 天前"),
        ("分享至朋友圈", "邀请新用户", "1 周前"),
    ]
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(records, id: \.0) { r in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(r.0).font(Theme.bodyFont(14)).foregroundStyle(Theme.textPrimary)
                            Text(r.1).font(Theme.captionFont(11)).foregroundStyle(Theme.textTertiary)
                        }
                        Spacer()
                        Text(r.2).font(Theme.captionFont(11)).foregroundStyle(Theme.textTertiary)
                    }
                    .padding(.horizontal, Theme.hPad).padding(.vertical, 14)
                    Divider().overlay(Theme.separator).padding(.leading, Theme.hPad)
                }
            }
            .background(Theme.bgCard)
        }
        .background(Theme.bg)
        .navigationTitle("分享记录")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 我的推广（mine_drive/mine_drive_page.dart）

struct MyDriveView: View {
    @State private var link = "https://lldj.tv/i?code="
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text("我的推广链接")
                        .font(Theme.titleFont(16))
                        .foregroundStyle(Theme.textPrimary)
                    Text(link)
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(14)
                        .frame(maxWidth: .infinity)
                        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                    Button("复制链接") { UIPasteboard.general.string = link }
                        .buttonStyle(LLDJPrimaryButton())
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("推广说明")
                        .font(Theme.titleFont(15))
                        .foregroundStyle(Theme.textPrimary)
                    Text(LLDJText.inviteNotice)
                        .font(Theme.captionFont(12))
                        .foregroundStyle(Theme.textSecondary)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                Spacer()
            }
            .padding(Theme.hPad)
        }
        .navigationTitle("我的推广")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 银行卡（mine_profit/bank_card_home_page.dart）

struct BankCardHomeView: View {
    @State private var cards: [BankCardModel] = []
    @State private var showAdd = false

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 14) {
                    if cards.isEmpty {
                        Text("暂未添加银行卡")
                            .font(Theme.captionFont(12))
                            .foregroundStyle(Theme.textTertiary)
                            .padding(.vertical, 20)
                    } else {
                        ForEach(cards) { c in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text(c.bankName ?? "银行")
                                        .font(Theme.titleFont(15))
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Text("默认").font(Theme.captionFont(10))
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                                Text(masked(c.cardNo))
                                    .font(.system(size: 18, design: .monospaced))
                                    .foregroundStyle(.white)
                                HStack {
                                    Text(c.realName ?? "")
                                    Spacer()
                                    Button("解绑") { remove(c) }
                                        .font(Theme.captionFont(12))
                                        .foregroundStyle(.white.opacity(0.8))
                                }
                                .font(Theme.captionFont(12))
                                .foregroundStyle(.white.opacity(0.8))
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                LinearGradient(colors: [Theme.vip, Theme.vipDeep],
                                               startPoint: .topLeading, endPoint: .bottomTrailing),
                                in: RoundedRectangle(cornerRadius: Theme.radiusLG))
                        }
                    }
                    Button("添加银行卡") { showAdd = true }
                        .buttonStyle(LLDJPrimaryButton())
                    Text(LLDJText.withdrawChannelsHint)
                        .font(Theme.captionFont(11))
                        .foregroundStyle(Theme.textTertiary)
                }
                .padding(Theme.hPad)
            }
        }
        .navigationTitle("银行卡")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAdd) { AddBankCardView { cards.append($0) } }
        .task { cards = (try? await PayService().bankCards()) ?? [] }
    }

    private func masked(_ no: String?) -> String {
        guard let no, no.count >= 8 else { return "**** **** **** ****" }
        return "****  ****  ****  " + no.suffix(4)
    }

    private func remove(_ c: BankCardModel) {
        cards.removeAll { $0.id == c.id }
    }
}

// MARK: - 添加银行卡（make_money/withdrawal_page.dart 内的加卡流程）

struct AddBankCardView: View {
    var onDone: (BankCardModel) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var bank = ""
    @State private var no = ""
    @State private var name = ""
    private let banks = LLDJText.withdrawChannels

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()
                VStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("开户银行").font(Theme.captionFont(12))
                            .foregroundStyle(Theme.textSecondary)
                        Picker("", selection: $bank) {
                            Text("请选择").tag("")
                            ForEach(banks, id: \.self) { Text($0).tag($0) }
                        }
                        .pickerStyle(.menu)
                        .tint(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: 8))
                    }
                    field("银行卡号", $no, .numberPad)
                    field("持卡人姓名", $name, .default)
                    Spacer()
                    Button(LLDJText.confirmSave) {
                        onDone(BankCardModel(id: UUID().uuidString,
                                             bankName: bank, cardNo: no,
                                             realName: name))
                        dismiss()
                    }
                    .buttonStyle(LLDJPrimaryButton())
                    .disabled(bank.isEmpty || no.count < 8 || name.isEmpty)
                }
                .padding(Theme.hPad)
            }
            .navigationTitle("添加银行卡")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func field(_ ph: String, _ t: Binding<String>, _ k: UIKeyboardType) -> some View {
        TextField(ph, text: t).keyboardType(k)
            .padding(12)
            .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: 8))
            .foregroundStyle(Theme.textPrimary)
    }
}

// MARK: - 提现记录（make_money/mine_withdrawal_record_page.dart）

struct WithdrawalRecordView: View {
    @State private var orders: [WithdrawOrder] = []
    var body: some View {
        Group {
            if orders.isEmpty {
                placeholder(title: "提现记录", icon: "list.bullet.rectangle",
                            desc: LLDJText.withdrawDetail)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(orders) { o in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("¥\(o.amount)")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .foregroundStyle(Theme.gold)
                                    Text(o.createdAt?.formatted(date: .abbreviated, time: .shortened) ?? "")
                                        .font(Theme.captionFont(11))
                                        .foregroundStyle(Theme.textTertiary)
                                }
                                Spacer()
                                Text(o.status ?? "处理中")
                                    .font(Theme.captionFont(12))
                                    .foregroundStyle(statusColor(o.status))
                            }
                            .padding(.horizontal, Theme.hPad).padding(.vertical, 14)
                            Divider().overlay(Theme.separator).padding(.leading, Theme.hPad)
                        }
                    }
                    .background(Theme.bgCard)
                }
            }
        }
        .background(Theme.bg)
        .navigationTitle("提现记录")
        .navigationBarTitleDisplayMode(.inline)
        .task { orders = (try? await PayService().withdrawOrders()) ?? [] }
    }

    private func statusColor(_ s: String?) -> Color {
        switch s {
        case "成功", "已到账": return Theme.gold
        case "失败", "已驳回": return Theme.brand
        default: return Theme.textSecondary
        }
    }
}

// MARK: - 购买记录（collec_history_buy/col_his_buy_page.dart）

struct PurchaseHistoryView: View {
    @State private var items: [MediaContent] = []
    @State private var tab = 0
    private let tabs = ["已购买", "已追剧", "已过期"]

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $tab) {
                ForEach(tabs, id: \.self) { Text($0).tag(tabs.firstIndex(of: $0) ?? 0) }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, Theme.hPad).padding(.vertical, 10)

            Group {
                if items.isEmpty {
                    placeholder(title: "购买记录", icon: "bag", desc: LLDJText.myBuyEmpty)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(items) { m in MediaRow(item: m) }
                        }
                        .padding(Theme.hPad)
                    }
                }
            }
        }
        .background(Theme.bg)
        .navigationTitle("购买记录")
        .navigationBarTitleDisplayMode(.inline)
        .task { items = (try? await HomeService().myPurchases()) ?? [] }
    }
}