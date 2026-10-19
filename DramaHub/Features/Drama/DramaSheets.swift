import SwiftUI

// Drama 模块视图集 —— 对应原 APK hj_page/drama/ 与 hj_page/video/ 下的 .dart 文件：
//   drama/view/drama_paywall_view.dart     付费墙
//   drama/view/drama_episode_sheet.dart    选集面板
//   drama/view/drama_menu.dart             播放菜单
//   drama/view/drama_more_settings_sheet.dart 更多设置
//   drama/view/drama_bottom_bar.dart       底部操作栏
//   video/view/video_detail_bottom_menu.dart
//   video/view/video_mask_buy_view.dart    金币解锁遮罩

// MARK: - 选集面板（drama_episode_sheet.dart）

struct DramaEpisodeSheet: View {
    let episodes: [DramaMediaInfo.DramaEpisode]
    let currentId: String?
    var onSelect: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var lockedOnly = false

    private var shown: [DramaMediaInfo.DramaEpisode] {
        lockedOnly ? episodes.filter { $0.locked && !$0.free } : episodes
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("选集")
                    .font(Theme.titleFont(16))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Button("全部") { lockedOnly = false }
                    .font(Theme.captionFont(12))
                    .foregroundStyle(lockedOnly ? Theme.textTertiary : Theme.gold)
                Button("仅解锁") { lockedOnly = true }
                    .font(Theme.captionFont(12))
                    .foregroundStyle(lockedOnly ? Theme.gold : Theme.textTertiary)
                    .padding(.leading, 12)
                Button { dismiss() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Theme.textTertiary)
                }
                .padding(.leading, 12)
            }
            .padding(Theme.hPad)
            .padding(.bottom, 12)

            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4),
                          spacing: 10) {
                    ForEach(shown) { ep in
                        Button { onSelect(ep.id); dismiss() } label: {
                            VStack(spacing: 3) {
                                Text("\(ep.index)")
                                    .font(Theme.bodyFont(14))
                                if !ep.free, ep.locked {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 8))
                                }
                            }
                            .foregroundStyle(color(ep))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(bg(ep), in: RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(ep.id == currentId ? Theme.gold : .clear, lineWidth: 1.5)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(Theme.hPad)
            }
        }
        .padding(.top, 16)
        .frame(maxHeight: 420)
        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radiusLG))
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
    }

    private func color(_ ep: DramaMediaInfo.DramaEpisode) -> Color {
        if ep.id == currentId { return .black }
        if ep.locked && !ep.free { return Theme.textTertiary }
        return Theme.textPrimary
    }

    private func bg(_ ep: DramaMediaInfo.DramaEpisode) -> Color {
        ep.id == currentId ? Theme.gold : Theme.bgCardHi
    }
}

// MARK: - 播放菜单（drama_menu.dart / video_menu_view.dart）

struct DramaMenuSheet: View {
    var onSpeed: (Double) -> Void = { _ in }
    var onQuality: (String) -> Void = { _ in }
    var onReport: () -> Void = {}
    var onSettings: () -> Void = {}

    @Environment(\.dismiss) private var dismiss
    @State private var speed: Double = 1.0
    @State private var quality = "自动"
    private let speeds: [Double] = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
    private let qualities = ["自动", "1080P", "720P", "540P"]

    var body: some View {
        VStack(spacing: 0) {
            sheetTitle("播放设置")
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    group("倍速") {
                        HStack(spacing: 8) {
                            ForEach(speeds, id: \.self) { s in
                                Button(String(format: "%g×", s)) {
                                    speed = s
                                    onSpeed(s)
                                }
                                .font(Theme.captionFont(12))
                                .foregroundStyle(speed == s ? .black : Theme.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(speed == s ? Theme.gold : Theme.bgCardHi,
                                            in: RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    group("清晰度") {
                        HStack(spacing: 8) {
                            ForEach(qualities, id: \.self) { q in
                                Button(q) {
                                    quality = q
                                    onQuality(q)
                                }
                                .font(Theme.captionFont(12))
                                .foregroundStyle(quality == q ? .black : Theme.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(quality == q ? Theme.gold : Theme.bgCardHi,
                                            in: RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    VStack(spacing: 0) {
                        action("举报内容", icon: "exclamationmark.bubble") { onReport(); dismiss() }
                        divider
                        action("播放设置", icon: "gearshape") { onSettings() }
                    }
                    .background(Theme.bgCardHi, in: RoundedRectangle(cornerRadius: Theme.radius))
                }
                .padding(Theme.hPad)
            }
        }
        .frame(maxHeight: 480)
        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radiusLG))
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
    }

    private var divider: some View {
        Rectangle().fill(Theme.separator).frame(height: 0.5).padding(.leading, 44)
    }

    private func sheetTitle(_ t: String) -> some View {
        HStack {
            Text(t).font(Theme.titleFont(16)).foregroundStyle(Theme.textPrimary)
            Spacer()
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill").foregroundStyle(Theme.textTertiary)
            }
        }
        .padding(Theme.hPad)
        .padding(.bottom, 12)
    }

    private func group<C: View>(_ title: String, @ViewBuilder c: () -> C) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(Theme.captionFont(12))
                .foregroundStyle(Theme.textSecondary)
            c()
        }
    }

    private func action(_ t: String, icon: String, block: @escaping () -> Void) -> some View {
        Button(action: block) {
            HStack(spacing: 12) {
                Image(systemName: icon).font(.system(size: 14))
                    .foregroundStyle(Theme.gold).frame(width: 20)
                Text(t).font(Theme.bodyFont(15)).foregroundStyle(Theme.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 14).padding(.vertical, 13)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 更多设置（drama_more_settings_sheet.dart）

struct DramaMoreSettingsSheet: View {
    @Binding var autoPlayNext: Bool
    @Binding var showSubtitle: Bool
    @Binding var preferWifi: Bool
    var onClearCache: () -> Void = {}
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("更多设置").font(Theme.titleFont(16)).foregroundStyle(Theme.textPrimary)
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(Theme.textTertiary)
                }
            }
            .padding(Theme.hPad).padding(.bottom, 12)

            VStack(spacing: 0) {
                toggleRow("自动播放下一集", $autoPlayNext)
                sep
                toggleRow("显示字幕", $showSubtitle)
                sep
                toggleRow("仅 Wi-Fi 预加载", $preferWifi)
                sep
                Button { onClearCache(); dismiss() } label: {
                    HStack {
                        Text("清除播放缓存")
                            .font(Theme.bodyFont(15))
                            .foregroundStyle(Theme.brand)
                        Spacer()
                    }
                    .padding(.horizontal, 14).padding(.vertical, 13)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .background(Theme.bgCardHi, in: RoundedRectangle(cornerRadius: Theme.radius))
            .padding(.horizontal, Theme.hPad)
            Spacer()
        }
        .padding(.top, 16)
        .frame(maxHeight: 400)
        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radiusLG))
        .presentationDetents([.height(340)])
        .presentationDragIndicator(.hidden)
    }

    private var sep: some View {
        Rectangle().fill(Theme.separator).frame(height: 0.5).padding(.leading, 14)
    }

    private func toggleRow(_ t: String, _ b: Binding<Bool>) -> some View {
        HStack {
            Text(t).font(Theme.bodyFont(15)).foregroundStyle(Theme.textPrimary)
            Spacer()
            Toggle("", isOn: b).labelsHidden().tint(Theme.gold)
        }
        .padding(.horizontal, 14).padding(.vertical, 8)
    }
}

// MARK: - 金币解锁遮罩（video_mask_buy_view.dart / video_detail_mask_buy_view.dart）

struct CoinUnlockMask: View {
    let coverURL: String?
    let coinPrice: Int
    var onUnlock: () -> Void
    var onVIP: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(colors: [.clear, .black.opacity(0.85)],
                           startPoint: .center, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                Spacer()
                Text(LLDJText.unlockFull)
                    .font(Theme.titleFont(16))
                    .foregroundStyle(Theme.textPrimary)

                HStack(spacing: 10) {
                    Button {
                        onVIP()
                    } label: {
                        VStack(spacing: 4) {
                            AssetIcon(asset: LLDJAsset.common_common_vip_bg,
                                      size: 26, tint: Theme.gold)
                            Text(LLDJText.vipUpgrade)
                                .font(Theme.captionFont(12))
                                .foregroundStyle(Theme.gold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.vip, in: RoundedRectangle(cornerRadius: Theme.radius))
                    }
                    .buttonStyle(.plain)

                    Button {
                        onUnlock()
                    } label: {
                        HStack(spacing: 6) {
                            AssetIcon(asset: LLDJAsset.common_coin, size: 18, tint: .black)
                            Text("\(coinPrice)")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.gold, in: RoundedRectangle(cornerRadius: Theme.radius))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - 底部操作栏（drama_bottom_bar.dart）

struct DramaBottomBar: View {
    var onEpisode: () -> Void = {}
    var onFavorite: () -> Void = {}
    var onShare: () -> Void = {}
    var onMenu: () -> Void = {}

    var body: some View {
        HStack(spacing: 0) {
            bar("选集", icon: "square.grid.3x3", action: onEpisode)
            bar("收藏", icon: "heart", action: onFavorite)
            bar("分享", icon: "square.and.arrow.up", action: onShare)
            bar("更多", icon: "ellipsis", action: onMenu)
        }
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Rectangle().fill(Theme.separator).frame(height: 0.5)
        }
    }

    private func bar(_ t: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: icon).font(.system(size: 16))
                Text(t).font(.system(size: 10))
            }
            .foregroundStyle(Theme.textSecondary)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}