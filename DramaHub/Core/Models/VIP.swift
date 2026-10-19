import Foundation

// MARK: - VIP 域（VipProductModel / VipProductListModel / NewPrivilege）

struct VipProductModel: Decodable, Identifiable {
    let id: String
    var name: String?              // 月卡 / 季卡 / 年卡
    var price: Double = 0
    var originalPrice: Double = 0
    var durationDays: Int = 0
    var dailyPrice: Double = 0     // 折合每日
    var privileges: [String] = []
    var isHot: Bool = false
    var tag: String?
}

struct VIPStatus: Decodable {
    var isVip: Bool = false
    var level: Int = 0
    var expireAt: String?
    var autoRenew: Bool = false
}

// MARK: - 充值域（RechargeListModel / RechargeTypeModel）

struct RechargePackage: Decodable, Identifiable {
    let id: String
    var coin: Int = 0
    var bonusCoin: Int = 0         // 赠送
    var price: Double = 0
    var tag: String?               // 热卖 / 超值
}

enum PayMethod: String, Decodable, CaseIterable {
    case alipay, wechat, unionpay, usdt, manual

    var displayName: String {
        switch self {
        case .alipay: return "支付宝"
        case .wechat: return "微信支付"
        case .unionpay: return "云闪付"
        case .usdt: return "USDT"
        case .manual: return "人工充值"
        }
    }

    var icon: String {
        switch self {
        case .alipay: return "y.circle"
        case .wechat: return "message.circle"
        case .unionpay: return "creditcard.circle"
        case .usdt: return "dollarsign.circle"
        case .manual: return "headphones.circle"
        }
    }

    /// 真实支付渠道图标（取自被分析 APK 的 mine/ic_*.png）
    var asset: String {
        switch self {
        case .alipay: return LLDJAsset.mine_ic_alipay
        case .wechat: return LLDJAsset.mine_ic_wechat
        case .unionpay: return LLDJAsset.mine_ic_union
        case .usdt: return LLDJAsset.mine_ic_usdt
        case .manual: return LLDJAsset.mine_mine_offical
        }
    }
}

struct PayInfoModel: Decodable {
    var orderId: String?
    var payUrl: String?
    var method: String?
    var amount: Double = 0
}
