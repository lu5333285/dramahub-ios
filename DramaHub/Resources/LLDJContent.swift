import SwiftUI

/// 真实文案库 —— 全部提取自被分析 APK（lldj2.4.0V5.apk → libapp.so 的 Dart AOT 字符串表）。
/// 用途：把界面文案还原为原版真实措辞，而非占位描述。
enum LLDJText {

    // MARK: - 登录 / 账号（原文含完整免责与账号安全提示）
    static let loginNotice = """
    本平台登录会自动创建账号，需保存账号凭证或绑定手机号码，才能记录之前的账号信息。\
    受行业限制，无法正常使用时需升级，未绑定手机号码会导致账号信息丢失。\
    请及时绑定手机号码或保存账号凭证，以免造成巨大财产损失！
    """
    static let loginPhoneHint = "正确的手机号"
    static let bindPhoneTitle = "手机绑定"
    static let bindPhoneOnce = "绑定一次"
    static let nicknameEmpty = "转昵称不能为空"

    // MARK: - 支付 / 充值（真实支付通道提示，含风控与黑名单规则）
    static let payChannelNotice = """
    受行业限制，如支付失败可尝试重新发起订单，系统将会随机切换备用的支付通道。\
    支付通道在夜间比较忙碌，尝试多次发起，后台会为您自动切换不同支付通道。
    """
    static let payBlacklist = "发起且未支付，账号可能被加入黑名单。"
    static let payTimeout = "支付超时，无法支付"
    static let payNoResult = "支付无法到账，请重新发起。"
    static let payArriving = "用户权益通常会在数分钟内到账，请刷新"
    static let payFeeNotice = "请放心充值使用，如遇报毒提示忽略即可。"
    static let payManualReview = "充值凭证截图联系在线客服为您查询核实恢复"
    static let payNoSelect = "你都没选择，保存什么"
    static let payOverLimit = "发起支付不能超过"
    static let payInProgress = "进行中"
    static let payMaxPerWithdraw = "单笔提现金额不大于"
    static let payWithdrawFee = "每次提现收取"

    // MARK: - 提现（真实通道/银行列表）
    static let withdrawChannels = [
        "湖北银行黄石分行", "东营市商业银行", "成都农商银行", "广东南粤银行",
        "开封市商业银行", "泰安市商业银行", "农村信用合作社联合社",
    ]
    static let withdrawNoChannel = "无可用提现通道"
    static let withdrawCoinType = "提现币类"
    static let withdrawAmount = "提现金额"
    static let withdrawDetail = "提现明细"
    static let withdrawUnpassed = "未通过原因"
    static let withdrawSaving = "保存中"

    // MARK: - 会员 / 特权（原文）
    static let vipUnlockAll = "解锁全站尊享特权"
    static let vipMemberOnly = "本内容需开通"
    static let vipMemberOnly2 = "会员即可"
    static let vipExpire = "会员到期时间"
    static let vipSaveYear = "会员预计年省"
    static let vipUpgrade = "立即开通"
    static let vipDrop = "可能会导致会员账号掉线"
    static let vipCard = "的会员卡"
    static let vipNotYet = "您还不是"
    static let unlockFull = "可解锁查看完整版"
    static let watchFull = "查看完整版"
    static let collapsePrivilege = "收起特权"
    static let notMemberBenefits = "开通后不限制免费观看次数"

    // MARK: - 签到 / 福利（原文）
    static let checkinTitle = "每日签到领福利"
    static let checkinDone = "已签到"
    static let checkinExpired = "已过期"
    static let redeemCodeOnce = "每个兑换码只能输入一次"
    static let redeemGifts = "可兑换以下豪礼"
    static let welfareTask = "福利任务"

    // MARK: - 社区 / 发布（原文含违规内容红线）
    static let commentPlaceholder = "请在此输入评论"
    static let topicRequired = "至少选择一个话题哦"
    static let noMultiImage = "本功能不支持多人图片"
    static let imageSizeLimit = "图片大小请低于"
    static let imageCountLimit = "图片数量最多"
    static let firstIsCover = "第一张图集默认为封面"
    static let firstIsCoverShort = "默认第一张为封面"
    static let uploadProcessing = "正在上传图片"
    static let videoProcessing = "正在处理视频"
    static let bannedAd = "发布广告图文"
    static let bannedInduce = "发布诱导图文"
    static let bannedMinor = "使用未成年图片"
    static let bannedAdult = "发布儿童色情、兽"
    static let linkExternal = "、网址、二维码等外链"
    static let shareSuffix = "分享时将标题或网址、二维码等外链"

    // MARK: - 直播（原文）
    static let liveSelfRoom = "当前在此直播间哦"
    static let liveWatching = "正在观看此媒体"
    static let livePlaying = "正在播放：第"
    static let liveAnchorOffline = "当前主播离线，请前往观看其她热门主播喔"
    static let liveCard = "立即开通直播卡"
    static let liveCharge = "充值"

    // MARK: - 阅读 / 播放（原文）
    static let pullMore = "上拉加载更多"
    static let noMore = "没有更多数据了"
    static let switchLine = "请切换线路播放"
    static let playFailed = "播放失败，已安全处理"
    static let retrying = "正在自动重试中"
    static let retryingShort = "正在自动重试中"
    static let downloading = "已下载完成了"
    static let cacheTooLarge = "缓存文件超过"
    static let downloadingToBrowser = "的下载链接到手机自带浏览器"

    // MARK: - 我的 / 设置（原文）
    static let myOrder = "我的订单"
    static let myRecords = "我的记录"
    static let myCollection = "我的收藏"
    static let myRoles = "我的角色"
    static let myFollow = "我的关注"
    static let myLikes = "我的喜欢"
    static let myPreference = "偏好设置"
    static let myCreator = "创作者中心"
    static let myWelfare = "我的福利"
    static let officialContact = "官方联系方式"
    static let feedback = "问题反馈，点击联系"
    static let feedbackInfo = "信息：机型，系统，地区，问题症状"
    static let needChangeIcon = "定要更换图标吗"
    static let moveToNewAccount = "信息会转移至新账号上。"
    static let lostAccountTip = "账号丢失的用户可在"
    static let infoInvalid = "无效信息无法帮助技术人员排查问题。"
    static let deleteRecord = "是否删除该生成记录"

    // MARK: - AI 模块（原文）
    static let aiCoupon = "领取优惠券"
    static let aiRecordDelete = "是否删除该生成记录"

    // MARK: - 通用
    static let hoursAgo = "小时前"
    static let nothingHere = "什么也没有"
    static let appVersionUpdate = "的版本需要更新了"
    static let localCacheOutdated = "本地文件大小大于远端文件大小，清除本地目录"
    static let saveNothing = "你都没选择，保存什么"
    static let privacyAndProtocol = "用户协议与隐私政策"
    static let underageNotice = "本应用禁止未成年人使用"
}

/// 真实资源图标的语义映射（把业务概念绑定到 APK 真实素材）
enum LLDJIcon {
    // 首页
    static let homeHot     = LLDJAsset.home_home_hot
    static let homeSearch  = LLDJAsset.home_home_search
    static let homeMenu    = LLDJAsset.home_home_menu
    static let homeRank    = LLDJAsset.home_rank_crown
    static let homeSort    = LLDJAsset.home_home_sort_list
    static let homeGrid    = LLDJAsset.home_grid_style
    static let homeList    = LLDJAsset.home_list_style
    static let jumpToTop   = LLDJAsset.home_jump_to_top
    static let historyDelete = LLDJAsset.home_history_delete
    static let searchClose = LLDJAsset.home_search_close

    // 我的
    static let vipEnter    = LLDJAsset.mine_ic_vip_enter
    static let vipBg       = LLDJAsset.mine_mine_vip_bg
    static let vipMore     = LLDJAsset.mine_vip_more_title
    static let coin        = LLDJAsset.mine_ic_coin
    static let checkinCoin = LLDJAsset.mine_check_in_coin
    static let checkedCoin = LLDJAsset.mine_checked_in_coin
    static let alipay      = LLDJAsset.mine_ic_alipay
    static let wechatPay   = LLDJAsset.mine_ic_wechat
    static let unionPay    = LLDJAsset.mine_ic_union
    static let usdt        = LLDJAsset.mine_ic_usdt
    static let shopIcon    = LLDJAsset.mine_mine_shop_icon
    static let withdraw    = LLDJAsset.mine_mine_withdraw_nor
    static let signClick   = LLDJAsset.mine_icon_sign_click
    static let signLock    = LLDJAsset.mine_ic_sign_lock
    static let signExpired = LLDJAsset.mine_ic_sign_expired
    static let inviteSteps = LLDJAsset.mine_invite_steps
    static let signTitle   = LLDJAsset.mine_sign_reward_title
    static let day7Reward  = LLDJAsset.mine_sign_day7_reward
    static let resignBg     = LLDJAsset.mine_icon_resign_bg
    static let proxyBanner = LLDJAsset.mine_proxy_banner
    static let shareBg     = LLDJAsset.mine_share_bg
    static let codeBg      = LLDJAsset.mine_code_bg
    static let welfareBg   = LLDJAsset.mine_welfare_normal_bg
    static let welfareVip  = LLDJAsset.mine_welfare_vip_bg

    // 我的菜单项
    static let menuWelfare = LLDJAsset.mine_mine_menu_welfare
    static let menuCollect = LLDJAsset.mine_mine_collect
    static let menuFollow  = LLDJAsset.mine_mine_follow
    static let menuPost    = LLDJAsset.mine_mine_post
    static let menuLikes   = LLDJAsset.mine_mine_menu_likes
    static let menuRoles   = LLDJAsset.mine_mine_menu_roles
    static let menuRecords = LLDJAsset.mine_mine_menu_records
    static let menuSetting = LLDJAsset.mine_setting
    static let menuAbout   = LLDJAsset.mine_mine_menu_about
    static let menuCreator = LLDJAsset.mine_mine_menu_creator
    static let notification = LLDJAsset.mine_mine_notification
    static let official   = LLDJAsset.mine_mine_offical

    // 社区
    static let communityMain = LLDJAsset.community_community_main_sel
    static let communityCoin = LLDJAsset.community_community_coin
    static let communitySign = LLDJAsset.community_community_sign
    static let publishAdd   = LLDJAsset.community_publish_add
    static let publishFab   = LLDJAsset.community_community_publish_fab
    static let likeEmpty    = LLDJAsset.community_like_empty
    static let likeCount    = LLDJAsset.community_like_count
    static let comment      = LLDJAsset.comment_msg_icon
    static let hotSearch    = LLDJAsset.community_hot_search
    static let lockedWhite  = LLDJAsset.community_locked_white

    // 播放
    static let play        = LLDJAsset.video_play
    static let pause       = LLDJAsset.video_pause_icon
    static let fullScreen  = LLDJAsset.video_full_screen
    static let lineSwitch  = LLDJAsset.video_line_switch
    static let download    = LLDJAsset.video_download
    static let downloadFree = LLDJAsset.video_download_free
    static let cacheStart  = LLDJAsset.video_cache_start
    static let cacheSel    = LLDJAsset.video_cache_selected
    static let updateVideo = LLDJAsset.video_update_video
    static let fullDrama   = LLDJAsset.video_full_drama
    static let chevronRight = LLDJAsset.video_chevron_right

    // 通用
    static let back        = LLDJAsset.common_common_back
    static let arrowRight  = LLDJAsset.common_arrow_right_grey
    static let arrowDown   = LLDJAsset.common_arrow_down
    static let closeButton = LLDJAsset.common_close_button
    static let empty       = LLDJAsset.common_placeholder_rect
    static let emptySquare = LLDJAsset.common_placeholder_square
    static let coinCommon  = LLDJAsset.common_coin
    static let check       = LLDJAsset.common_check
    static let adClose     = LLDJAsset.common_ad_close
    static let copy        = LLDJAsset.mine_icon_copy

    // AI
    static let aiDraw      = LLDJAsset.ai_ai_draw
    static let aiGirlFriend = LLDJAsset.ai_ai_girl_friend_bg
    static let aiMate      = LLDJAsset.ai_ai_mate_enter
    static let aiNovel     = LLDJAsset.ai_ai_novel_enter
    static let aiChangeFace = LLDJAsset.ai_ai_changeface_right
    static let aiRecord    = LLDJAsset.ai_ai_record_add
    static let aiCouponBg  = LLDJAsset.ai_ai_coupon_bg

    // 直播
    static let liveBg      = LLDJAsset.live_images_live_main_bg
    static let liveCharge  = LLDJAsset.live_images_live_charge
    static let nineGrid    = LLDJAsset.live_images_nine_grid_bg
    static let sixGrid     = LLDJAsset.live_images_six_grid_bg
    static let liveShare   = LLDJAsset.live_images_live_share
}
// MARK: - 补充文案（设置 / 反馈 / FAQ 等）

extension LLDJText {
    static let loginNoticeShort = "登录后可同步收藏与播放记录"
    static let confirmSave = "保存"
    static let confirmSubmit = "提交"
    static let confirmBind = "绑定手机"
    static let feedbackHint = "请详细描述遇到的问题，无效信息无法帮助技术人员排查问题。"
    static let faqAccountTitle = "账号丢失怎么办？"
    static let faqPayTitle = "支付失败如何处理？"
    static let faqVipTitle = "会员权益包含什么？"
    static let faqWithdrawTitle = "为什么无法提现？"
}
