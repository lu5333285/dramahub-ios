import Foundation

/// 认证服务（/mine/login、/mine/mobileLoginOnly、/mine/info、/mine/wallet）
struct AuthService {
    func login(phone: String, code: String) async throws -> LoginResponse {
        if Config.useMock {
            try await Task.sleep(nanoseconds: 400_000_000)
            return LoginResponse(token: "mock-token-\(phone)", userId: "100086", isNewUser: false)
        }
        return try await APIClient.shared.request(
            .mineMobileLoginOnly(phone: phone, code: code),
            body: ["phone": phone, "code": code])
    }

    func profile() async throws -> UserInfoModel {
        if Config.useMock { return MockData.user }
        return try await APIClient.shared.get(.mineInfo)
    }

    func wallet() async throws -> WalletModel {
        if Config.useMock { return MockData.wallet }
        return try await APIClient.shared.get(.mineWallet)
    }
}

/// 首页服务（/banner/list、/modules/list、/media/recommend）
struct HomeService {
    func load() async throws -> HomeData {
        if Config.useMock {
            try await Task.sleep(nanoseconds: 300_000_000)
            return HomeData(banners: MockData.banners, modules: MockData.homeModules,
                            hotKeywords: MockData.hotKeywords)
        }
        async let banners: [BannerItem] = APIClient.shared.get(.bannerList)
        async let modules: [HomeModule] = APIClient.shared.get(.modulesList())
        return try await HomeData(banners: banners, modules: modules, hotKeywords: MockData.hotKeywords)
    }
}

/// 短剧服务（/media/drama/feed、/vid/info、/vid/play、/media/drama/download/authorize）
struct DramaService {
    func feed(page: Int) async throws -> [MediaContent] {
        if Config.useMock { return MockData.dramaList }
        return try await APIClient.shared.get(.dramaFeed(page: page))
    }

    func detail(id: String) async throws -> DramaMediaInfo {
        if Config.useMock { return MockData.dramaDetail(id: id) }
        return try await APIClient.shared.get(.vidInfo(id: id))
    }

    func playInfo(episodeId: String) async throws -> PlayInfo {
        if Config.useMock { return MockData.playInfo(id: episodeId) }
        return try await APIClient.shared.get(.vidPlay(id: episodeId))
    }

    func downloadAuthorize(episodeId: String) async throws -> DownloadAuth {
        if Config.useMock { return DownloadAuth(authorized: true, remainCount: 10) }
        return try await APIClient.shared.request(.dramaDownloadAuthorize,
                                                  body: ["episodeId": episodeId])
    }
}

/// 社区服务（/vid/community/recommend、/comment/list、/comment/send）
struct CommunityService {
    func posts(page: Int) async throws -> [CommunityPost] {
        if Config.useMock { return MockData.posts }
        return try await APIClient.shared.get(.communityRecommend(page: page))
    }

    func comments(mediaId: String, page: Int) async throws -> CommentListRes {
        if Config.useMock { return CommentListRes(list: MockData.comments, total: 3, page: page) }
        return try await APIClient.shared.get(.commentList(id: mediaId, page: page))
    }

    func sendComment(mediaId: String, content: String) async throws {
        if Config.useMock { return }
        let _: EmptyResp = try await APIClient.shared.request(.commentSend(),
                                                              body: ["mediaId": mediaId, "content": content])
    }

    func likePost(postId: String, liked: Bool) async throws {
        if Config.useMock { return }
        let _: EmptyResp = try await APIClient.shared.request(liked ? .thumbsUp() : .thumbsDown(),
                                                              body: ["id": postId])
    }
}

/// 我的服务（/mine/iIncomes、/mine/transactionH、/userinvite/info、/task/list、/checkin/prize）
struct MineService {
    func bills(page: Int) async throws -> [BillItemModel] {
        if Config.useMock { return MockData.bills }
        return try await APIClient.shared.get(.mineTransactionH)
    }

    func inviteInfo() async throws -> InviteInfo {
        if Config.useMock { return MockData.inviteInfo }
        return try await APIClient.shared.get(.userinviteInfo())
    }

    func bindInvite(code: String) async throws {
        if Config.useMock { return }
        let _: EmptyResp = try await APIClient.shared.request(.mineInviteBind(), body: ["code": code])
    }

    func tasks() async throws -> [DailyTask] {
        if Config.useMock { return MockData.tasks }
        return try await APIClient.shared.get(.taskList())
    }

    func checkin() async throws -> CheckinConfig {
        if Config.useMock { return MockData.checkin }
        return try await APIClient.shared.request(.checkinPrize(), body: nil as EmptyResp?)
    }

    func claimTask(id: String) async throws {
        if Config.useMock { return }
        let _: EmptyResp = try await APIClient.shared.request(.taskReceive(id: id), body: nil as EmptyResp?)
    }
}

/// 支付服务（/vip/product、/product/buy、/withdraw/cfg、/withdraw、/withdraw/order、/coupon/list）
struct PayService {
    func vipProducts() async throws -> [VipProductModel] {
        if Config.useMock { return MockData.vipProducts }
        return try await APIClient.shared.get(.vipProduct)
    }

    func rechargePackages() async throws -> [RechargePackage] {
        if Config.useMock { return MockData.rechargePackages }
        // 原版金币档位由 /vip/product 与支付引导 /payment/guide 下发
        return try await APIClient.shared.get(.paymentGuide())
    }

    func createOrder(productId: String, method: PayMethod) async throws -> PayInfoModel {
        if Config.useMock {
            return PayInfoModel(orderId: "mock-\(productId)", payUrl: nil, method: method.rawValue,
                                amount: MockData.rechargePackages.first { $0.id == productId }?.price ?? 0)
        }
        return try await APIClient.shared.request(.productBuy(),
                                                  body: ["productId": productId, "payType": method.rawValue])
    }

    func withdrawConfig() async throws -> WithdrawConfig {
        if Config.useMock { return MockData.withdrawConfig }
        return try await APIClient.shared.get(LLDJEndpoint.e073)
    }

    func withdrawOrders() async throws -> [WithdrawOrder] {
        if Config.useMock { return MockData.withdrawOrders }
        return try await APIClient.shared.get(.withdrawOrder)
    }

    func applyWithdraw(amount: Double, method: String, account: String) async throws {
        struct WithdrawRequest: Encodable {
            let amount: Double
            let method: String
            let account: String
        }
        if Config.useMock { return }
        let _: EmptyResp = try await APIClient.shared.request(.withdrawApply(),
                                                              body: WithdrawRequest(amount: amount,
                                                                                    method: method,
                                                                                    account: account))
    }
}

/// AI 服务（/ai/mod/v2/list、/ai/{sub}/generate、/ai/{sub}/list）
struct AIService {
    func modules() async throws -> [AIModule] {
        if Config.useMock { return MockData.aiModules }
        return try await APIClient.shared.get(.aiModList())
    }

    func records() async throws -> [AIRecord] {
        if Config.useMock { return MockData.aiRecords }
        // 演示：取绘画类记录
        return try await APIClient.shared.get(.aiList("img"))
    }

    func generate(sub: String, params: [String: String]) async throws -> String {
        if Config.useMock { return "mock-task-id" }
        let resp: PayInfoModel = try await APIClient.shared.request(.aiGenerate(sub), body: params)
        return resp.orderId ?? "mock-task-id"
    }
}

/// 直播服务（/live/module/list/91porn、/live/anchor/list/91porn）
struct LiveService {
    func modules() async throws -> [LiveModule] {
        if Config.useMock { return MockData.liveModules }
        return try await APIClient.shared.get(.liveModuleList())
    }

    func anchors(moduleId: String) async throws -> [LiveAnchor] {
        if Config.useMock { return MockData.liveAnchors }
        return try await APIClient.shared.get(.liveAnchorList(moduleId: moduleId))
    }
}

// MARK: - 移植补齐：真实端点方法（对应 libapp.so 中提取的路径）

extension CommunityService {
    /// 我的发布（/mine/publish）
    func myPublish() async throws -> [CommunityPost] {
        if Config.useMock { return MockData.posts }
        return try await APIClient.shared.get(LLDJEndpoint.e041)
    }

    /// 关注列表（/follow/list）
    func following() async throws -> [CommunityUser] {
        if Config.useMock { return MockData.users }
        return try await APIClient.shared.get(LLDJEndpoint.e061)
    }

    /// 关注动态（/follow/dynamics/list）
    func followDynamics() async throws -> [CommunityPost] {
        if Config.useMock { return MockData.posts }
        return try await APIClient.shared.get(LLDJEndpoint.e062)
    }
}

extension HomeService {
    /// 我的收藏（/mine/collect）
    func myLikes() async throws -> [MediaContent] {
        if Config.useMock { return MockData.dramas }
        return try await APIClient.shared.get(LLDJEndpoint.e040)
    }

    /// 我的已购（/media/my_buy）
    func myPurchases() async throws -> [MediaContent] {
        if Config.useMock { return MockData.dramas }
        return try await APIClient.shared.get(LLDJEndpoint.e011)
    }

    /// 书架（/media_bookshelf/list）
    func bookshelf() async throws -> [MediaContent] {
        if Config.useMock { return MockData.dramas }
        return try await APIClient.shared.get(LLDJEndpoint.e034)
    }
}

extension PayService {
    /// 银行卡列表（/mine/txnact/yh/get）
    func bankCards() async throws -> [BankCardModel] {
        if Config.useMock { return MockData.bankCards }
        return try await APIClient.shared.get(LLDJEndpoint.e070)
    }

    /// 添加银行卡（/mine/txnact/yh/add）
    func addBankCard(bank: String, no: String, name: String) async throws {
        if Config.useMock { return }
        let _: EmptyResp = try await APIClient.shared.request(
            .e069,
            body: ["bankName": bank, "cardNo": no, "realName": name])
    }

    /// 提现配置（/withdraw/cfg）—— 已在 PayService 主体定义，此处不重复

    /// 提现下单（/withdraw/order）—— 同上

    /// 我的账单（/mine/zhangdan）
    func statements(page: Int) async throws -> [BillItemModel] {
        if Config.useMock { return MockData.bills }
        return try await APIClient.shared.get(LLDJEndpoint.e072)
    }
}

extension CommunityService {
    /// 标签下帖子（/tag/media/list、/tag/vid/list）
    func tagPosts(tag: String) async throws -> [CommunityPost] {
        if Config.useMock { return MockData.posts }
        return try await APIClient.shared.get(LLDJEndpoint.e030)
            .q([("tagId", tag), ("page", "1")])
    }

    /// 社区搜索（/search/list）
    func search(keyword: String) async throws -> [CommunityPost] {
        if Config.useMock { return MockData.posts }
        return try await APIClient.shared.get(LLDJEndpoint.e032)
            .q([("keyword", keyword), ("page", "1")])
    }
}

extension DramaService {
    /// 短剧专题（/media/drama/topics）
    func topics() async throws -> [String] {
        if Config.useMock { return ["都市逆袭", "甜宠日常", "战神归来", "重生复仇"] }
        return try await APIClient.shared.get(LLDJEndpoint.e015)
    }

    /// 专题下作品（/media/drama/topic/works）
    func topicWorks(id: String) async throws -> [MediaContent] {
        if Config.useMock { return MockData.dramas }
        return try await APIClient.shared.get(LLDJEndpoint.e016)
            .q([("topicId", id), ("page", "1")])
    }

    /// 短剧库（/vid/library）
    func library() async throws -> [MediaContent] {
        if Config.useMock { return MockData.dramas }
        return try await APIClient.shared.get(LLDJEndpoint.e024)
    }
}
