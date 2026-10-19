import SwiftUI

/// 启动页 —— 使用被分析 APK 中的真实素材
/// launch/ic_splash_bg.webp（1125×2436 全屏底图）+ common/app_wordmark_lldj.png（品牌字标）
struct SplashView: View {
    var onFinish: (() -> Void)?

    @State private var appeared = false

    var body: some View {
        ZStack {
            // 真实启动底图
            AnyView(
                AssetLibrary.image(Theme.splashImage)
                    .map { $0.resizable().aspectRatio(contentMode: .fill) }
                    ?? AnyView(Color.black)
            )
            .ignoresSafeArea()

            // 底部品牌字标（原版样式：居中显示）
            VStack {
                Spacer()
                AnyView(
                    AssetLibrary.image(Theme.wordmark)
                        .map { $0.resizable().aspectRatio(contentMode: .fit) }
                        ?? AnyView(
                            Text("lldj")
                                .font(.system(size: 26, weight: .heavy, design: .rounded))
                                .foregroundStyle(.white)
                        )
                )
                .frame(width: 156, height: 52)
                    .opacity(appeared ? 1 : 0)
                    .padding(.bottom, 96)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) { appeared = true }
            // 1.2s 后进入主界面
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                onFinish?()
            }
        }
    }
}