import SwiftUI

/// 设计规范。配色与素材取自被分析 APK 的真实资产
/// （采样自 mine/vip_center_header_bg.webp → #322C68、mine/coin_icon.webp → #FFC56E、
///   live_images/live_main_bg.webp → #05010D）
enum Theme {
    // 背景层级（深 → 浅）
    static let bg        = Color(hex: 0x0A0A0F)   // 近 live_main_bg 的深紫黑
    static let bgCard    = Color(hex: 0x16161E)
    static let bgCardHi  = Color(hex: 0x22222C)
    static let separator = Color.white.opacity(0.08)

    // 文本
    static let textPrimary   = Color.white
    static let textSecondary = Color(hex: 0x9C9CA6)
    static let textTertiary  = Color(hex: 0x6B6B75)

    // 品牌色（全部来自真实资产采样）
    static let gold    = Color(hex: 0xFFC56E)   // coin_icon.webp 主色
    static let goldDim = Color(hex: 0x8A6D1F)
    static let vip     = Color(hex: 0x322C68)   // vip_center_header_bg.webp 主色
    static let vipDeep = Color(hex: 0x23165B)
    static let brand   = Color(hex: 0xE5484D)
    static let live    = Color(hex: 0xFF5C5C)

    // 尺寸
    static let radius: CGFloat = 12
    static let radiusLG: CGFloat = 18
    static let hPad: CGFloat = 16

    // 字体
    static func titleFont(_ size: CGFloat = 17) -> Font { .system(size: size, weight: .semibold) }
    static func bodyFont(_ size: CGFloat = 14) -> Font { .system(size: size) }
    static func captionFont(_ size: CGFloat = 11) -> Font { .system(size: size) }

    // MARK: - 真实背景素材
    // 直接引用被分析 APK 中的图片资源（Asset Catalog 名称）

    /// 启动图（launch/ic_splash_bg.webp，1125×2436 全屏底图）
    static let splashImage = LLDJAsset.launch_ic_splash_bg

    /// 首页顶部渐变背景（home/aw_bg.webp）
    static let homeHeaderBg = LLDJAsset.home_aw_bg

    /// 我的页背景（mine/mine_background.webp）
    static let mineBg = LLDJAsset.mine_mine_background

    /// VIP 中心头图（mine/vip_center_header_bg.webp）
    static let vipHeaderBg = LLDJAsset.mine_vip_center_header_bg

    /// 通用 VIP 背景（common/common_vip_bg.webp）
    static let commonVipBg = LLDJAsset.common_common_vip_bg

    /// 直播模块背景（live_images/live_main_bg.webp）
    static let liveBg = LLDJAsset.live_images_live_main_bg

    /// 品牌 logo（common/app_icon_lldj.png）
    static let logo = LLDJAsset.common_app_icon_lldj

    /// 品牌字标（common/app_wordmark_lldj.png）
    static let wordmark = LLDJAsset.common_app_wordmark_lldj
}

extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255,
                  opacity: alpha)
    }
}

/// 通用容器卡片
struct Card<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(Theme.hPad)
            .background(Theme.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radius, style: .continuous))
    }
}

/// 金币徽标（使用真实素材 mine/coin_icon.webp + check_in_coin.webp）
struct CoinBadge: View {
    let amount: Int
    var compact = false

    var body: some View {
        HStack(spacing: 4) {
            AssetIcon(asset: LLDJAsset.mine_coin_icon,
                      fallback: "circle.fill",
                      size: compact ? 11 : 14,
                      tint: Theme.gold)
            Text("\(amount.formatted())")
                .font(compact ? Theme.captionFont(10) : Theme.captionFont(12))
                .foregroundStyle(Theme.gold)
        }
        .padding(.horizontal, compact ? 6 : 8)
        .padding(.vertical, compact ? 3 : 4)
        .background(Theme.gold.opacity(0.12))
        .clipShape(Capsule())
    }
}

/// VIP 标识（使用真实素材 mine/vip_1.webp ~ vip_4.webp 四档等级）
struct VIPBadge: View {
    var level: Int = 1
    var text: String? = nil

    /// 对应真实资产 mine_vip_1 ~ mine_vip_4
    private var levelAsset: String {
        let lv = min(max(level, 1), 4)
        return "mine_vip_\(lv)"
    }

    var body: some View {
        if let text {
            Text(text)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.black)
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(
                    LinearGradient(colors: [Theme.gold, Color(hex: 0xD9A227)],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
        } else {
            Group {
                if let img = AssetLibrary.image(levelAsset) {
                    img.resizable().aspectRatio(contentMode: .fit)
                } else {
                    Text("VIP").font(.system(size: 10, weight: .bold)).foregroundStyle(Theme.gold)
                }
            }
        }
    }
}
