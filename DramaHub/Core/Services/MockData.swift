import Foundation

/// 演示数据：与真实接口返回结构一致（useMock = true 时启用）
/// 图片使用 picsum.photos 占位，真实环境替换为 CDN 封面
enum MockData {

    // MARK: - 用户

    static let user = UserInfoModel(
        id: "100086",
        nickname: "短剧爱好者",
        avatar: "https://picsum.photos/seed/avatar/200/200",
        phone: "138****8888",
        vipLevel: 1,
        vipExpireAt: "2026-11-19",
        coin: 12800,
        integral: 360,
        balance: 128.5,
        inviteCode: "DJH888",
        createdAt: "2025-03-12"
    )

    static let wallet = WalletModel(coin: 12800, integral: 360, balance: 128.5,
                                    totalIncome: 586.2, todayIncome: 12.8, withdrawable: 128.5)

    // MARK: - 首页

    static let banners = [
        BannerItem(id: "b1", image: "https://picsum.photos/seed/banner1/750/320", jumpType: "media", jumpValue: "d1", title: "热播推荐"),
        BannerItem(id: "b2", image: "https://picsum.photos/seed/banner2/750/320", jumpType: "h5", jumpValue: "https://lldj.tv/act", title: "福利活动"),
        BannerItem(id: "b3", image: "https://picsum.photos/seed/banner3/750/320", jumpType: "media", jumpValue: "d2", title: "新剧上线")
    ]

    static let hotKeywords = ["总裁", "闪婚", "战神", "重生", "逆袭", "甜宠", "离婚", "马甲"]

    static let homeModules = [
        HomeModule(id: "m1", name: "热门短剧", icon: "flame", sort: 0, items: dramaList),
        HomeModule(id: "m2", name: "高分推荐", icon: "star", sort: 1, items: Array(dramaList.reversed())),
        HomeModule(id: "m3", name: "新剧上线", icon: "sparkles", sort: 2, items: dramaList.shuffled())
    ]

    // MARK: - 短剧

    static let dramaList: [MediaContent] = [
        MediaContent(id: "d1", title: "闪婚老公是豪门", cover: "https://picsum.photos/seed/d1/400/560",
                     desc: "一场醉酒后的闪婚，让她意外嫁给了掌控商业帝国的神秘总裁。",
                     type: "drama", episodeCount: 82, playCount: 1280000, likeCount: 86000,
                     isVipOnly: false, coinPrice: 0, tags: ["总裁", "甜宠"], score: 9.2, updatedAt: "今天",
                     author: .init(id: "u1", nickname: "星辉剧场", avatar: nil)),
        MediaContent(id: "d2", title: "战神归来当赘婿", cover: "https://picsum.photos/seed/d2/400/560",
                     desc: "五年戎马，战神归来，却发现妻女受尽屈辱……",
                     type: "drama", episodeCount: 96, playCount: 2100000, likeCount: 152000,
                     isVipOnly: true, coinPrice: 0, tags: ["战神", "热血"], score: 9.5, updatedAt: "昨天",
                     author: .init(id: "u2", nickname: "烽火影业", avatar: nil)),
        MediaContent(id: "d3", title: "重生之将门毒后", cover: "https://picsum.photos/seed/d3/400/560",
                     desc: "重生回及笄之年，她誓要护住将门满门忠烈。",
                     type: "drama", episodeCount: 68, playCount: 980000, likeCount: 71000,
                     isVipOnly: false, coinPrice: 30, tags: ["重生", "古装"], score: 9.0, updatedAt: "2 天前",
                     author: .init(id: "u3", nickname: "锦绣华章", avatar: nil)),
        MediaContent(id: "d4", title: "离婚后我成了顶流", cover: "https://picsum.photos/seed/d4/400/560",
                     desc: "签下离婚协议的那天，她摘掉了婚戒，戴上了王冠。",
                     type: "drama", episodeCount: 54, playCount: 760000, likeCount: 53000,
                     isVipOnly: false, coinPrice: 0, tags: ["逆袭", "娱乐圈"], score: 8.8, updatedAt: "3 天前",
                     author: .init(id: "u1", nickname: "星辉剧场", avatar: nil)),
        MediaContent(id: "d5", title: "霸道总裁的替嫁新娘", cover: "https://picsum.photos/seed/d5/400/560",
                     desc: "替嫁进入豪门，本以为是深渊，却是被他宠上天的开始。",
                     type: "drama", episodeCount: 120, playCount: 3300000, likeCount: 256000,
                     isVipOnly: true, coinPrice: 0, tags: ["总裁", "马甲"], score: 9.4, updatedAt: "4 天前",
                     author: .init(id: "u4", nickname: "甜梦工厂", avatar: nil)),
        MediaContent(id: "d6", title: "县太爷的爆笑日常", cover: "https://picsum.photos/seed/d6/400/560",
                     desc: "一个不靠谱的县太爷，一屋子鸡飞狗跳的师爷衙役。",
                     type: "drama", episodeCount: 40, playCount: 450000, likeCount: 38000,
                     isVipOnly: false, coinPrice: 10, tags: ["古装", "喜剧"], score: 8.5, updatedAt: "5 天前",
                     author: .init(id: "u5", nickname: "乐翻天", avatar: nil))
    ]

    static func dramaDetail(id: String) -> DramaMediaInfo {
        let base = dramaList.first { $0.id == id } ?? dramaList[0]
        let episodeTotal = base.episodeCount ?? 20
        let paid = (base.coinPrice ?? 0) > 0
        var episodes: [DramaMediaInfo.DramaEpisode] = []
        episodes.reserveCapacity(episodeTotal)
        for i in 1...episodeTotal {
            let ep = DramaMediaInfo.DramaEpisode(
                id: "\(base.id)-ep\(i)", index: i,
                title: "第 \(i) 集",
                locked: i > 3 && paid && i % 5 == 0,
                free: i <= 3, duration: 180
            )
            episodes.append(ep)
        }
        return DramaMediaInfo(
            id: base.id, title: base.title, cover: base.cover, desc: base.desc,
            episodes: episodes,
            isVipOnly: base.isVipOnly, coinPrice: base.coinPrice,
            playCount: base.playCount, likeCount: base.likeCount,
            favorited: false, resumeEpisodeId: "\(base.id)-ep2"
        )
    }

    static func playInfo(id: String) -> PlayInfo {
        PlayInfo(url: "https://example.com/hls/\(id)/playlist.m3u8",
                 backupUrls: ["https://example.com/hls/\(id)/backup.m3u8"],
                 isH265: false, duration: 182, needUnlock: false, unlockPrice: 30, freeSeconds: 60)
    }

    // MARK: - VIP / 充值

    static let vipProducts = [
        VipProductModel(id: "v1", name: "月卡", price: 29.9, originalPrice: 39.9, durationDays: 30,
                        dailyPrice: 0.99, privileges: ["全站免费看", "免广告", "蓝光画质", "缓存下载"], isHot: false, tag: nil),
        VipProductModel(id: "v2", name: "季卡", price: 69.9, originalPrice: 119.7, durationDays: 90,
                        dailyPrice: 0.78, privileges: ["全站免费看", "免广告", "蓝光画质", "缓存下载", "专属客服"], isHot: true, tag: "超值"),
        VipProductModel(id: "v3", name: "年卡", price: 198, originalPrice: 478.8, durationDays: 365,
                        dailyPrice: 0.54, privileges: ["全站免费看", "免广告", "4K 画质", "缓存下载", "专属客服", "生日礼包"], isHot: false, tag: "最划算")
    ]

    static let rechargePackages = [
        RechargePackage(id: "r1", coin: 600, bonusCoin: 0, price: 6, tag: nil),
        RechargePackage(id: "r2", coin: 3000, bonusCoin: 300, price: 30, tag: "热卖"),
        RechargePackage(id: "r3", coin: 6800, bonusCoin: 1000, price: 68, tag: "超值"),
        RechargePackage(id: "r4", coin: 12800, bonusCoin: 2500, price: 128, tag: nil),
        RechargePackage(id: "r5", coin: 32800, bonusCoin: 8000, price: 328, tag: nil),
        RechargePackage(id: "r6", coin: 64800, bonusCoin: 20000, price: 648, tag: nil)
    ]

    static let bills: [BillItemModel] = [
        BillItemModel(id: "t1", title: "金币充值", amount: 30, type: "recharge", createdAt: "2026-10-18 14:22", status: "success"),
        BillItemModel(id: "t2", title: "解锁《战神归来当赘婿》第 12 集", amount: -30, type: "consume", createdAt: "2026-10-17 21:05", status: "success"),
        BillItemModel(id: "t3", title: "每日签到奖励", amount: 10, type: "reward", createdAt: "2026-10-17 09:12", status: "success"),
        BillItemModel(id: "t4", title: "邀请好友奖励", amount: 300, type: "reward", createdAt: "2026-10-15 18:40", status: "success"),
        BillItemModel(id: "t5", title: "提现到支付宝", amount: -50, type: "withdraw", createdAt: "2026-10-12 10:00", status: "success")
    ]

    // MARK: - 提现

    static let withdrawConfig = WithdrawConfig(
        minAmount: 10, maxAmount: 500, feeRate: 0.03,
        methods: ["alipay", "wechat", "bank"],
        rules: ["1. 每次提现金额最低 10 元，单笔提现最大 500 元。",
                "2. 提现收取 3% 手续费，到账时间 72 小时内。",
                "3. 仅支持银行卡提现，收款账户卡号与姓名一致。",
                "4. 申请提现后请随时关注收款账户进款通知。"],
        bankNameRequired: true
    )

    static let withdrawOrders: [WithdrawOrder] = [
        WithdrawOrder(id: "w1", amount: 50, method: "alipay", status: "success", createdAt: "2026-10-12", remark: "已到账"),
        WithdrawOrder(id: "w2", amount: 100, method: "bank", status: "reviewing", createdAt: "2026-10-18", remark: "审核中")
    ]

    // MARK: - 签到 / 任务

    static let checkinPrizes: [CheckinConfig.CheckinPrize] = {
        var list: [CheckinConfig.CheckinPrize] = []
        for i in 1...7 {
            let coin = i == 3 ? 50 : i == 7 ? 200 : 10
            list.append(CheckinConfig.CheckinPrize(
                id: "c\(i)", day: i,
                reward: "第 \(i) 天 +\(coin)",
                coin: coin,
                claimed: i <= 2, isDouble: false
            ))
        }
        return list
    }()

    static let checkin = CheckinConfig(
        signedToday: false, continuousDays: 3, vipDouble: true,
        prizes: checkinPrizes,
        canClaimExtra: true
    )

    static let tasks: [DailyTask] = [
        DailyTask(id: "k1", name: "每日签到", desc: "完成每日签到", reward: 10, progress: 0, target: 1, status: "todo", icon: "calendar"),
        DailyTask(id: "k2", name: "观看短剧 5 分钟", desc: "有效观看时长累计 5 分钟", reward: 20, progress: 3, target: 5, status: "doing", icon: "play.tv"),
        DailyTask(id: "k3", name: "分享 1 部短剧", desc: "分享任意短剧给好友", reward: 30, progress: 1, target: 1, status: "done", icon: "square.and.arrow.up"),
        DailyTask(id: "k4", name: "发布 1 条社区动态", desc: "在社区发布图文或视频", reward: 50, progress: 0, target: 1, status: "todo", icon: "bubble.left"),
        DailyTask(id: "k5", name: "邀请 1 位好友", desc: "好友通过你的邀请码注册", reward: 300, progress: 0, target: 1, status: "todo", icon: "person.badge.plus")
    ]

    // MARK: - 邀请

    static let inviteInfo = InviteInfo(code: "DJH888", inviteCount: 12, validCount: 8,
                                       rewardDesc: "每邀请 1 位好友注册得 3 日 VIP", bound: false)

    // MARK: - 社区

    static let posts: [CommunityPost] = [
        CommunityPost(id: "p1", content: "这部《闪婚老公是豪门》也太甜了吧！第 42 集男主替女主挡酒那段我直接尖叫！",
                     images: ["https://picsum.photos/seed/p1a/300/400", "https://picsum.photos/seed/p1b/300/400"],
                     videoUrl: nil,
                     author: .init(id: "u9", nickname: "追剧小达人", avatar: "https://picsum.photos/seed/av9/100/100", isCreator: true),
                     likeCount: 328, commentCount: 46, liked: false, createdAt: "2 小时前", tags: ["闪婚老公是豪门"]),
        CommunityPost(id: "p2", content: "求推荐类似《战神归来》这种爽文改编的短剧，越虐越解气那种！",
                     images: [], videoUrl: nil,
                     author: .init(id: "u10", nickname: "夜猫子", avatar: "https://picsum.photos/seed/av10/100/100", isCreator: false),
                     likeCount: 89, commentCount: 23, liked: true, createdAt: "5 小时前", tags: ["求剧"]),
        CommunityPost(id: "p3", content: "自己剪了一段混剪，这运镜绝了",
                     images: [], videoUrl: "https://example.com/video/p3.mp4",
                     author: .init(id: "u11", nickname: "剪辑师阿哲", avatar: "https://picsum.photos/seed/av11/100/100", isCreator: true),
                     likeCount: 1206, commentCount: 156, liked: false, createdAt: "昨天", tags: ["混剪"])
    ]

    static let comments: [CommentModel] = [
        CommentModel(id: "cm1", content: "第 42 集真的封神！反复看了三遍", user: .init(id: "u20", nickname: "剧荒少女", avatar: nil),
                     likeCount: 56, liked: false, createdAt: "1 小时前", replyCount: 2,
                     replies: [
                        CommentModel(id: "cm1r1", content: "同刷三遍！", user: .init(id: "u21", nickname: "阿伟", avatar: nil),
                                     likeCount: 3, liked: false, createdAt: "30 分钟前", replyCount: 0, replies: [])
                     ]),
        CommentModel(id: "cm2", content: "求问这个 BGM 叫什么，太上头了", user: .init(id: "u22", nickname: "音乐控", avatar: nil),
                     likeCount: 12, liked: false, createdAt: "2 小时前", replyCount: 0, replies: []),
        CommentModel(id: "cm3", content: "女主这件外套有同款链接吗？", user: .init(id: "u23", nickname: "穿搭bot", avatar: nil),
                     likeCount: 8, liked: false, createdAt: "3 小时前", replyCount: 1, replies: [])
    ]

    // MARK: - 直播

    static let liveModules = [
        LiveModule(id: "lm1", name: "推荐", icon: "star", anchorCount: 42),
        LiveModule(id: "lm2", name: "新人", icon: "sparkles", anchorCount: 18),
        LiveModule(id: "lm3", name: "排行榜", icon: "crown", anchorCount: 30)
    ]

    static let liveAnchors: [LiveAnchor] = [
        LiveAnchor(id: "a1", nickname: "小鱼儿", avatar: "https://picsum.photos/seed/a1/100/100",
                   cover: "https://picsum.photos/seed/a1c/300/400", viewers: 12043, isLive: true, tags: ["才艺"], moduleId: "lm1"),
        LiveAnchor(id: "a2", nickname: "夜色微光", avatar: "https://picsum.photos/seed/a2/100/100",
                   cover: "https://picsum.photos/seed/a2c/300/400", viewers: 8932, isLive: true, tags: ["聊天"], moduleId: "lm1"),
        LiveAnchor(id: "a3", nickname: "可乐加冰", avatar: "https://picsum.photos/seed/a3/100/100",
                   cover: "https://picsum.photos/seed/a3c/300/400", viewers: 4521, isLive: true, tags: ["唱歌"], moduleId: "lm2"),
        LiveAnchor(id: "a4", nickname: "山川湖海", avatar: "https://picsum.photos/seed/a4/100/100",
                   cover: "https://picsum.photos/seed/a4c/300/400", viewers: 3344, isLive: true, tags: ["舞蹈"], moduleId: "lm1")
    ]

    // MARK: - AI

    static let aiModules: [AIModule] = [
        AIModule(id: "ai1", name: "AI 绘画", desc: "输入描述，生成精美图片", icon: "paintpalette",
                 category: "img", coinCost: 20, isVipFree: false, hot: true),
        AIModule(id: "ai2", name: "文生图", desc: "一句话变成一幅画", icon: "text.below.photo",
                 category: "text_to_image", coinCost: 10, isVipFree: false, hot: false),
        AIModule(id: "ai3", name: "AI 换脸", desc: "视频换脸，一键生成", icon: "person.crop.artframe",
                 category: "changeface", coinCost: 100, isVipFree: false, hot: true),
        AIModule(id: "ai4", name: "图生视频", desc: "让静态图片动起来", icon: "video.circle",
                 category: "imagetovideo", coinCost: 200, isVipFree: false, hot: false),
        AIModule(id: "ai5", name: "AI 小说", desc: "AI 帮你写连载小说", icon: "book.closed",
                 category: "text_to_novel", coinCost: 50, isVipFree: false, hot: false),
        AIModule(id: "ai6", name: "AI 女友", desc: "智能陪伴聊天", icon: "heart.circle",
                 category: "girl", coinCost: 0, isVipFree: true, hot: true)
    ]

    static let aiRecords: [AIRecord] = [
        AIRecord(id: "r1", type: "img", status: "success", resultUrl: "https://picsum.photos/seed/airec1/300/300",
                 cover: "https://picsum.photos/seed/airec1/200/200", createdAt: "今天 14:20", coinCost: 20),
        AIRecord(id: "r2", type: "video", status: "doing", resultUrl: nil,
                 cover: "https://picsum.photos/seed/airec2/200/200", createdAt: "今天 13:05", coinCost: 200)
    ]

    // MARK: - 消息中心

    static let messageCount = 3
}
