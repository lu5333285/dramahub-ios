import SwiftUI

/// 设计规范。深色主题 + 金色会员色，对应原版短剧类 App 视觉（mine/vip、rank_crown、coin 资产暗示）
enum Theme {
    // 背景层级（深 → 浅）
    static let bg        = Color(hex: 0x0F0F13)
    static let bgCard    = Color(hex: 0x1B1B22)
    static let bgCardHi  = Color(hex: 0x24242E)
    static let separator = Color.white.opacity(0.08)

    // 文本
    static let textPrimary   = Color.white
    static let textSecondary = Color(hex: 0x9C9CA6)
    static let textTertiary  = Color(hex: 0x6B6B75)

    // 品牌色
    static let gold    = Color(hex: 0xF5C244)   // 金币 / VIP
    static let goldDim = Color(hex: 0x8A6D1F)
    static let brand   = Color(hex: 0xE5484D)   // 主品牌红
    static let live    = Color(hex: 0xFF5C5C)

    // 尺寸
    static let radius: CGFloat = 12
    static let radiusLG: CGFloat = 18
    static let hPad: CGFloat = 16

    // 字体
    static func titleFont(_ size: CGFloat = 17) -> Font { .system(size: size, weight: .semibold) }
    static func bodyFont(_ size: CGFloat = 14) -> Font { .system(size: size) }
    static func captionFont(_ size: CGFloat = 11) -> Font { .system(size: size) }
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

/// 金币徽标（mine/coin）
struct CoinBadge: View {
    let amount: Int
    var compact = false

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "circle.fill")
                .font(.system(size: compact ? 10 : 12))
                .foregroundStyle(Theme.gold)
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

/// VIP 标识（vip_entry_card / vip_badge_style）
struct VIPBadge: View {
    var text = "VIP"

    var body: some View {
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
    }
}
