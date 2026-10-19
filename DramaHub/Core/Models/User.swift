import Foundation

// MARK: - 用户域（UserInfoModel / ModelUserInfo / DcUserInfo）

struct UserInfoModel: Decodable, Identifiable {
    let id: String
    var nickname: String?
    var avatar: String?
    var phone: String?
    var vipLevel: Int?           // 0=非会员
    var vipExpireAt: String?
    var coin: Int?               // 金币余额
    var integral: Int?           // 积分
    var balance: Double?         // 可提现收益（分→元由 UI 层格式化）
    var inviteCode: String?
    var createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "userId", nickname, avatar, phone, vipLevel, vipExpireAt,
             coin, integral, balance, inviteCode, createdAt
    }

    var isVIP: Bool { (vipLevel ?? 0) > 0 }
}

struct LoginResponse: Decodable {
    let token: String
    let userId: String
    let isNewUser: Bool?
}

// MARK: - 钱包域（WalletModel / ImUserWallet / BillItemModel）

struct WalletModel: Decodable {
    var coin: Int = 0
    var integral: Int = 0
    var balance: Double = 0        // 收益余额（元）
    var totalIncome: Double = 0
    var todayIncome: Double = 0
    var withdrawable: Double = 0
}

struct BillItemModel: Decodable, Identifiable {
    let id: String
    var title: String?
    var amount: Double = 0
    var type: String?              // recharge / consume / withdraw / reward
    var createdAt: String?
    var status: String?            // pending / success / failed
}

// MARK: - 提现域（WithdrawConfig / WithdrawOrder）

struct WithdrawConfig: Decodable {
    var minAmount: Double = 0
    var maxAmount: Double = 0
    var feeRate: Double = 0
    var methods: [String] = []     // alipay / wechat / bank / usdt
    var rules: [String] = []
    var bankNameRequired: Bool = true
}

struct WithdrawOrder: Decodable, Identifiable {
    let id: String
    var amount: Double = 0
    var method: String?
    var status: String?            // reviewing / success / rejected
    var createdAt: String?
    var remark: String?
}
