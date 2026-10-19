import SwiftUI

// MARK: - 金币充值（mine_vip/mine_charge_coin_page）

@MainActor
final class RechargeViewModel: ObservableObject {
    @Published var packages: [RechargePackage] = []
    @Published var selectedId: String?
    @Published var method: PayMethod = .alipay
    @Published var isPaying = false
    @Published var paid = false

    private let service = PayService()

    func load() async {
        packages = (try? await service.rechargePackages()) ?? []
        selectedId = packages.first?.id
    }

    func pay() async {
        guard let id = selectedId else { return }
        isPaying = true
        defer { isPaying = false }
        _ = try? await service.createOrder(productId: id, method: method)
        paid = true
    }
}

struct RechargeView: View {
    @StateObject private var vm = RechargeViewModel()
    @EnvironmentObject private var session: SessionStore

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("当前金币")
                        .font(Theme.captionFont(12))
                        .foregroundStyle(Theme.textSecondary)
                    Spacer()
                    CoinBadge(amount: session.user?.coin ?? 0)
                }

                Text("选择档位")
                    .font(Theme.titleFont(15))
                    .foregroundStyle(Theme.textPrimary)

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(vm.packages) { pkg in
                        Button { vm.selectedId = pkg.id } label: {
                            VStack(spacing: 4) {
                                HStack(spacing: 2) {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 10))
                                        .foregroundStyle(Theme.gold)
                                    Text("\(pkg.coin.formatted())")
                                        .font(.system(size: 17, weight: .bold, design: .rounded))
                                        .foregroundStyle(Theme.textPrimary)
                                }
                                if pkg.bonusCoin > 0 {
                                    Text("赠 \(pkg.bonusCoin.formatted())")
                                        .font(Theme.captionFont(10))
                                        .foregroundStyle(Theme.brand)
                                }
                                Text("¥\(Int(pkg.price))")
                                    .font(Theme.captionFont(11))
                                    .foregroundStyle(Theme.textTertiary)
                                if let tag = pkg.tag {
                                    Text(tag)
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundStyle(.black)
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 1.5)
                                        .background(Theme.gold)
                                        .clipShape(RoundedRectangle(cornerRadius: 3))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(vm.selectedId == pkg.id ? Theme.gold.opacity(0.12) : Theme.bgCard)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.radius)
                                    .stroke(vm.selectedId == pkg.id ? Theme.gold : .clear, lineWidth: 1.2)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                        }
                    }
                }

                Text("支付方式")
                    .font(Theme.titleFont(15))
                    .foregroundStyle(Theme.textPrimary)
                VStack(spacing: 0) {
                    ForEach(PayMethod.allCases, id: \.self) { m in
                        Button { vm.method = m } label: {
                            HStack {
                                AnyView(
                                    AssetLibrary.image(m.asset)
                                        .map { AnyView($0.resizable().aspectRatio(contentMode: .fit)) }
                                        ?? Image(systemName: m.icon)
                                            .foregroundStyle(Theme.textSecondary)
                                )
                                .frame(width: 24, height: 24)
                                Text(m.displayName)
                                    .font(Theme.bodyFont(14))
                                    .foregroundStyle(Theme.textPrimary)
                                Spacer()
                                Image(systemName: vm.method == m ? "largecircle.fill.circle" : "circle")
                                    .foregroundStyle(vm.method == m ? Theme.gold : Theme.textTertiary)
                            }
                            .padding(.vertical, 12)
                        }
                        if m != PayMethod.allCases.last {
                            Divider().overlay(Theme.separator)
                        }
                    }
                }
                .padding(.horizontal, Theme.hPad)
                .background(Theme.bgCard)
                .clipShape(RoundedRectangle(cornerRadius: Theme.radius))

                Button { Task { await vm.pay() } } label: {
                    Text(vm.isPaying ? "支付中…" : "立即支付")
                        .font(Theme.titleFont(16))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.gold)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                }
                .disabled(vm.selectedId == nil || vm.isPaying)

                // 原版真实文案（提取自 libapp.so 字符串表）
                Text(LLDJText.payChannelNotice)
                    .font(Theme.captionFont(10))
                    .foregroundStyle(Theme.textTertiary)
                    .padding(.horizontal, 4)

                Text(LLDJText.payFeeNotice)
                    .font(Theme.captionFont(10))
                    .foregroundStyle(Theme.textTertiary)
                    .padding(.horizontal, 4)
            }
            .padding(Theme.hPad)
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle("金币充值")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load() }
        .alert("支付成功", isPresented: $vm.paid) {
            Button("好的", role: .cancel) { }
        } message: {
            Text(LLDJText.payArriving)
        }
    }
}

// MARK: - 积分兑换（widgets/integral_exchange_logic）

struct ExchangeView: View {
    @EnvironmentObject private var session: SessionStore
    @State private var amount = "100"
    @State private var exchanged = false

    /// 100 积分 = 10 金币（演示比例）
    private var coinValue: Int { (Int(amount) ?? 0) / 10 }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("可用积分")
                    .font(Theme.captionFont(12))
                    .foregroundStyle(Theme.textSecondary)
                Spacer()
                Text("\(session.user?.integral ?? 0)")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.brand)
            }
            .padding(Theme.hPad)
            .background(Theme.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radius))

            Text("兑换金币")
                .font(Theme.titleFont(15))
                .foregroundStyle(Theme.textPrimary)
            TextField("积分数量", text: $amount)
                .keyboardType(.numberPad)
                .font(Theme.bodyFont(16))
                .padding()
                .background(Theme.bgCard)
                .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                .foregroundStyle(Theme.textPrimary)

            HStack {
                Text("可得金币")
                    .font(Theme.bodyFont(14))
                    .foregroundStyle(Theme.textSecondary)
                Spacer()
                CoinBadge(amount: coinValue)
            }

            Text("兑换比例：100 积分 = 10 金币（对应 /integral/exchangeIntegral）")
                .font(Theme.captionFont(11))
                .foregroundStyle(Theme.textTertiary)

            Spacer()

            Button {
                exchanged = true
            } label: {
                Text("立即兑换")
                    .font(Theme.titleFont(16))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.gold)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
            }
            .disabled(coinValue <= 0)
        }
        .padding(Theme.hPad)
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle("积分兑换")
        .navigationBarTitleDisplayMode(.inline)
        .alert("兑换成功", isPresented: $exchanged) {
            Button("好的", role: .cancel) { }
        } message: {
            Text("演示模式：获得 \(coinValue) 金币")
        }
    }
}

// MARK: - VIP 会员中心（mine_vip/mine_charge_vip_page）

@MainActor
final class VIPCenterViewModel: ObservableObject {
    @Published var products: [VipProductModel] = []
    @Published var selectedId: String?
    @Published var subscribed = false

    private let service = PayService()

    func load() async {
        products = (try? await service.vipProducts()) ?? []
        selectedId = products.first { $0.isHot }?.id ?? products.first?.id
    }

    func subscribe() async {
        guard let id = selectedId else { return }
        _ = try? await service.createOrder(productId: id, method: .alipay)
        subscribed = true
    }
}

struct VIPCenterView: View {
    @StateObject private var vm = VIPCenterViewModel()
    @EnvironmentObject private var session: SessionStore

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 会员状态
                VStack(spacing: 8) {
                    HStack {
                        Text(session.user?.isVIP == true ? "会员有效期至 \(session.user?.vipExpireAt ?? "")" : "您还未开通会员")
                            .font(Theme.titleFont(15))
                            .foregroundStyle(Theme.textPrimary)
                    }
                    Text("全站短剧免费看 · 免广告 · 蓝光画质 · 缓存下载")
                        .font(Theme.captionFont(12))
                        .foregroundStyle(Theme.textTertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    LinearGradient(colors: [Theme.goldDim.opacity(0.35), Theme.bgCard],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: Theme.radiusLG, style: .continuous))

                // 套餐
                ForEach(vm.products) { product in
                    Button { vm.selectedId = product.id } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 6) {
                                    Text(product.name ?? "")
                                        .font(Theme.titleFont(16))
                                        .foregroundStyle(Theme.textPrimary)
                                    if product.isHot { VIPBadge(text: "推荐") }
                                }
                                Text("¥\(String(format: "%.2f", product.dailyPrice))/天")
                                    .font(Theme.captionFont(11))
                                    .foregroundStyle(Theme.textTertiary)
                                Text(product.privileges.joined(separator: " · "))
                                    .font(Theme.captionFont(11))
                                    .foregroundStyle(Theme.textSecondary)
                                    .lineLimit(1)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("¥\(String(format: "%.1f", product.price))")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundStyle(Theme.gold)
                                Text("¥\(String(format: "%.1f", product.originalPrice))")
                                    .font(Theme.captionFont(10))
                                    .foregroundStyle(Theme.textTertiary)
                                    .strikethrough()
                            }
                            Image(systemName: vm.selectedId == product.id ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(vm.selectedId == product.id ? Theme.gold : Theme.textTertiary)
                        }
                        .padding(Theme.hPad)
                        .background(vm.selectedId == product.id ? Theme.gold.opacity(0.08) : Theme.bgCard)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.radius)
                                .stroke(vm.selectedId == product.id ? Theme.gold : .clear, lineWidth: 1.2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                    }
                }

                Button { Task { await vm.subscribe() } } label: {
                    Text("立即开通")
                        .font(Theme.titleFont(16))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.gold)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                }

                Text("会员服务协议：虚拟商品一经开通不支持退款；连续包月可随时取消。")
                    .font(Theme.captionFont(10))
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(Theme.hPad)
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle("开通会员")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load() }
        .alert("开通成功", isPresented: $vm.subscribed) {
            Button("好的", role: .cancel) { }
        } message: {
            Text("演示模式：会员已生效")
        }
    }
}

// MARK: - 提现（make_money/withdrawal_page）

@MainActor
final class WithdrawViewModel: ObservableObject {
    @Published var config: WithdrawConfig?
    @Published var orders: [WithdrawOrder] = []
    @Published var amount = ""
    @Published var method = "alipay"
    @Published var account = ""
    @Published var submitted = false

    private let service = PayService()

    func load() async {
        config = try? await service.withdrawConfig()
        orders = (try? await service.withdrawOrders()) ?? []
    }

    var canSubmit: Bool {
        guard let amountValue = Double(amount), let cfg = config else { return false }
        return amountValue >= cfg.minAmount && amountValue <= cfg.maxAmount && !account.isEmpty
    }

    func submit() async {
        guard let amountValue = Double(amount) else { return }
        try? await service.applyWithdraw(amount: amountValue, method: method, account: account)
        submitted = true
    }
}

struct WithdrawView: View {
    @StateObject private var vm = WithdrawViewModel()
    @EnvironmentObject private var session: SessionStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("可提现收益（元）")
                        .font(Theme.captionFont(12))
                        .foregroundStyle(Theme.textSecondary)
                    Spacer()
                    Text(String(format: "%.2f", session.user?.balance ?? 0))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.green)
                }
                .padding(Theme.hPad)
                .background(Theme.bgCard)
                .clipShape(RoundedRectangle(cornerRadius: Theme.radius))

                Text("提现金额")
                    .font(Theme.titleFont(15))
                    .foregroundStyle(Theme.textPrimary)
                HStack {
                    Text("¥").foregroundStyle(Theme.textPrimary)
                    TextField("请输入金额", text: $vm.amount)
                        .keyboardType(.decimalPad)
                        .foregroundStyle(Theme.textPrimary)
                }
                .font(Theme.titleFont(20))
                .padding()
                .background(Theme.bgCard)
                .clipShape(RoundedRectangle(cornerRadius: Theme.radius))

                if let cfg = vm.config {
                    Text("单笔范围 ¥\(Int(cfg.minAmount)) ~ ¥\(Int(cfg.maxAmount))，手续费 \(Int(cfg.feeRate * 100))%")
                        .font(Theme.captionFont(11))
                        .foregroundStyle(Theme.textTertiary)
                }

                Text("提现方式")
                    .font(Theme.titleFont(15))
                    .foregroundStyle(Theme.textPrimary)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(vm.config?.methods ?? ["alipay"], id: \.self) { m in
                            Button { vm.method = m } label: {
                                Text(methodName(m))
                                    .font(Theme.captionFont(12))
                                    .foregroundStyle(vm.method == m ? .black : Theme.textSecondary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(vm.method == m ? Theme.gold : Theme.bgCard)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }

                Text("收款账号")
                    .font(Theme.titleFont(15))
                    .foregroundStyle(Theme.textPrimary)
                TextField("账号 / 卡号", text: $vm.account)
                    .font(Theme.bodyFont(14))
                    .padding()
                    .background(Theme.bgCard)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                    .foregroundStyle(Theme.textPrimary)

                if let cfg = vm.config, !cfg.rules.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(LLDJText.vipUnlockAll)
                            .font(Theme.titleFont(14))
                            .foregroundStyle(Theme.textPrimary)
                        ForEach(cfg.rules, id: \.self) { rule in
                            Text(rule)
                                .font(Theme.captionFont(11))
                                .foregroundStyle(Theme.textTertiary)
                        }
                    }
                    .padding(Theme.hPad)
                    .background(Theme.bgCard)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                }

                Button { Task { await vm.submit() } } label: {
                    Text("申请提现")
                        .font(Theme.titleFont(16))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.gold)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                }
                .disabled(!vm.canSubmit)

                // 提现记录
                if !vm.orders.isEmpty {
                    Text("提现记录")
                        .font(Theme.titleFont(15))
                        .foregroundStyle(Theme.textPrimary)
                    ForEach(vm.orders) { order in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("¥\(String(format: "%.2f", order.amount))")
                                    .font(Theme.bodyFont(14))
                                    .foregroundStyle(Theme.textPrimary)
                                Text("\(methodName(order.method ?? "")) · \(order.createdAt ?? "")")
                                    .font(Theme.captionFont(10))
                                    .foregroundStyle(Theme.textTertiary)
                            }
                            Spacer()
                            Text(statusText(order.status))
                                .font(Theme.captionFont(12))
                                .foregroundStyle(statusColor(order.status))
                        }
                        .padding(Theme.hPad)
                        .background(Theme.bgCard)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                    }
                }
            }
            .padding(Theme.hPad)
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle("收益提现")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load() }
        .alert("提交成功", isPresented: $vm.submitted) {
            Button("好的", role: .cancel) { }
        } message: {
            Text("演示模式：提现申请已提交，等待审核")
        }
    }

    private func methodName(_ raw: String) -> String {
        PayMethod(rawValue: raw)?.displayName ?? raw
    }

    private func statusText(_ status: String?) -> String {
        switch status {
        case "success": return "已到账"
        case "reviewing": return "审核中"
        case "rejected": return "已驳回"
        default: return "处理中"
        }
    }

    private func statusColor(_ status: String?) -> Color {
        switch status {
        case "success": return Color.green
        case "reviewing": return Theme.gold
        case "rejected": return Theme.live
        default: return Theme.textTertiary
        }
    }
}
