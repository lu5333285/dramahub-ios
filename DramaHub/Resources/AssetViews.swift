import SwiftUI

/// 真实素材图标视图：优先按 Asset Catalog 名取图，取不到回退到 SF Symbol。
/// 统一封装避免各处 Optional.map { } ?? AnyView(...) 的类型推断问题。
struct AssetIcon: View {
    /// Asset Catalog 资源名（如 LLDJAsset.mine_setting）
    let asset: String
    /// 回退的 SF Symbol 名
    var fallback: String = "square.grid.2x2"
    var size: CGFloat = 24
    /// 回退图标的着色（仅 SF Symbol 生效）
    var tint: Color = Theme.textSecondary

    var body: some View {
        Group {
            if let img = AssetLibrary.image(asset) {
                img.resizable().aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: fallback)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(tint)
            }
        }
        .frame(width: size, height: size)
    }
}

/// 真实素材背景视图：按资源名铺满，缺失时用底色
struct AssetBackground: View {
    let asset: String
    var opacity: Double = 1.0
    /// 缺失时的底色
    var base: Color = Theme.bg

    var body: some View {
        ZStack(alignment: .top) {
            base.ignoresSafeArea()
            if let img = AssetLibrary.image(asset) {
                img.resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
            }
        }
        .opacity(opacity)
    }
}
