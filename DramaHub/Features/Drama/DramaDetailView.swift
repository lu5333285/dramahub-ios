import SwiftUI

@MainActor
final class DramaDetailViewModel: ObservableObject {
    @Published var detail: DramaMediaInfo?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showPaywall = false
    @Published var paywallTargetEpisode: DramaMediaInfo.DramaEpisode?
    @Published var playingEpisode: DramaMediaInfo.DramaEpisode?
    @Published var toast: String?

    let mediaId: String
    private let service = DramaService()

    init(mediaId: String) { self.mediaId = mediaId }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do { detail = try await service.detail(id: mediaId) } catch { errorMessage = error.localizedDescription }
    }

    /// 点击剧集：免费直接播；锁定先弹付费墙（drama_paywall_view）
    func selectEpisode(_ episode: DramaMediaInfo.DramaEpisode) {
        if episode.free || !episode.locked {
            play(episode)
        } else {
            paywallTargetEpisode = episode
            showPaywall = true
        }
    }

    private func play(_ episode: DramaMediaInfo.DramaEpisode) {
        guard let detail else { return }
        PlaybackStore.shared.saveResume(dramaId: detail.id, episodeId: episode.id)
        PlaybackStore.shared.addHistory(id: detail.id, title: detail.title, cover: detail.cover)
        playingEpisode = episode
    }

    /// 金币解锁（/product/buy 或 /mine/privilege/consume）
    func unlockWithCoin(price: Int) {
        showPaywall = false
        if var ep = paywallTargetEpisode {
            ep.locked = false
            if var d = detail, let idx = d.episodes.firstIndex(where: { $0.id == ep.id }) {
                d.episodes[idx] = ep
                detail = d
            }
            play(ep)
        }
        toast = "已用 \(price) 金币解锁（演示）"
    }

    func unlockWithVIP() {
        showPaywall = false
        toast = "演示模式：前往「我的-开通会员」"
    }
}

struct DramaDetailView: View {
    @StateObject private var vm: DramaDetailViewModel
    @EnvironmentObject private var session: SessionStore

    init(mediaId: String) {
        _vm = StateObject(wrappedValue: DramaDetailViewModel(mediaId: mediaId))
    }

    var body: some View {
        ScrollView {
            if let detail = vm.detail {
                VStack(alignment: .leading, spacing: 16) {
                    header(detail)
                    actionBar(detail)
                    episodeGrid(detail)
                }
                .padding(Theme.hPad)
            }
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load() }
        .overlay { if vm.isLoading { ProgressView().tint(Theme.gold) } }
        // 付费墙
        .sheet(isPresented: $vm.showPaywall) {
            if let ep = vm.paywallTargetEpisode {
                PaywallSheet(episode: ep,
                             coinPrice: vm.detail?.coinPrice ?? 0,
                             isVip: session.user?.isVIP ?? false,
                             onCoinUnlock: { vm.unlockWithCoin(price: vm.detail?.coinPrice ?? 0) },
                             onVIPUnlock: { vm.unlockWithVIP() })
                    .presentationDetents([.medium])
            }
        }
        // 播放器
        .fullScreenCover(item: $vm.playingEpisode) { episode in
            DramaPlayerView(mediaId: vm.mediaId, startEpisodeId: episode.id)
        }
        .toast(message: vm.toast)
    }

    // MARK: - 头部

    private func header(_ detail: DramaMediaInfo) -> some View {
        HStack(alignment: .top, spacing: 12) {
            NetworkImage(detail.cover)
                .frame(width: 120, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(detail.title ?? "").font(Theme.titleFont(17)).foregroundStyle(Theme.textPrimary)
                    if detail.isVipOnly == true { VIPBadge() }
                }
                .lineLimit(2)

                Text(detail.desc ?? "")
                    .font(Theme.captionFont(12))
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(3)

                HStack(spacing: 12) {
                    Label("\(formatCount(detail.playCount ?? 0)) 播放", systemImage: "play")
                    Label("\(formatCount(detail.likeCount ?? 0)) 点赞", systemImage: "hand.thumbsup")
                }
                .font(Theme.captionFont(11))
                .foregroundStyle(Theme.textTertiary)

                if let resumeEp = detail.episodes.first(where: { $0.id == detail.resumeEpisodeId }) {
                    Button { vm.selectEpisode(resumeEp) } label: {
                        Label("继续观看第 \(resumeEp.index) 集", systemImage: "play.circle")
                            .font(Theme.bodyFont(13))
                            .foregroundStyle(.black)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Theme.gold)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }

    // MARK: - 操作栏

    private func actionBar(_ detail: DramaMediaInfo) -> some View {
        HStack(spacing: 20) {
            actionButton(icon: detail.favorited == true ? "heart.fill" : "heart", title: "追剧")
            actionButton(icon: "square.and.arrow.up", title: "分享")
            actionButton(icon: "arrow.down.circle", title: "缓存")
            Spacer()
            if let price = detail.coinPrice, price > 0 { CoinBadge(amount: price) }
        }
        .font(Theme.captionFont(12))
    }

    private func actionButton(icon: String, title: String) -> some View {
        Button {} label: {
            VStack(spacing: 4) {
                Image(systemName: icon).font(.system(size: 18))
                Text(title)
            }
            .foregroundStyle(Theme.textSecondary)
        }
    }

    // MARK: - 剧集网格（drama_episode_sheet）

    private func episodeGrid(_ detail: DramaMediaInfo) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("选集").font(Theme.titleFont(15)).foregroundStyle(Theme.textPrimary)
                Text("共 \(detail.episodes.count) 集")
                    .font(Theme.captionFont(11))
                    .foregroundStyle(Theme.textTertiary)
                Spacer()
            }
            let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 5)
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(detail.episodes.prefix(60)) { ep in
                    Button { vm.selectEpisode(ep) } label: {
                        Text("\(ep.index)")
                            .font(Theme.captionFont(12))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(ep.locked ? Theme.bgCard : Theme.gold.opacity(0.15))
                            .foregroundStyle(ep.locked ? Theme.textSecondary : Theme.gold)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .overlay(alignment: .topTrailing) {
                                if ep.locked {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 8))
                                        .foregroundStyle(Theme.textTertiary)
                                        .offset(x: 2, y: -2)
                                }
                            }
                    }
                }
            }
        }
    }

    private func formatCount(_ count: Int) -> String {
        if count >= 10000 { return String(format: "%.1f万", Double(count) / 10000) }
        return "\(count)"
    }
}

// MARK: - 付费墙（drama_paywall_view / comic_buy_alert）

struct PaywallSheet: View {
    let episode: DramaMediaInfo.DramaEpisode
    let coinPrice: Int
    let isVip: Bool
    let onCoinUnlock: () -> Void
    let onVIPUnlock: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.shield")
                .font(.system(size: 44))
                .foregroundStyle(Theme.gold)
            Text("解锁第 \(episode.index) 集")
                .font(Theme.titleFont(18))
                .foregroundStyle(Theme.textPrimary)
            Text(episode.title ?? "")
                .font(Theme.captionFont(12))
                .foregroundStyle(Theme.textTertiary)

            VStack(spacing: 12) {
                Button(action: onCoinUnlock) {
                    HStack {
                        Image(systemName: "circle.fill").foregroundStyle(Theme.gold)
                        Text("金币解锁")
                            .font(Theme.bodyFont(15))
                            .foregroundStyle(Theme.textPrimary)
                        Spacer()
                        CoinBadge(amount: coinPrice)
                    }
                    .padding()
                    .background(Theme.bgCardHi)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                }

                Button(action: onVIPUnlock) {
                    HStack {
                        VIPBadge()
                        Text("开通会员 全站免费看")
                            .font(Theme.bodyFont(15))
                            .foregroundStyle(.black)
                        Spacer()
                        Image(systemName: "chevron.right").foregroundStyle(.black.opacity(0.6))
                    }
                    .padding()
                    .background(LinearGradient(colors: [Theme.gold, Color(hex: 0xD9A227)],
                                               startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                }
            }
            .padding(.horizontal)

            if isVip {
                Text("会员有效期内无需付费")
                    .font(Theme.captionFont(11))
                    .foregroundStyle(Theme.textTertiary)
            }
            Spacer()
        }
        .padding(.top, 28)
        .background(Theme.bg)
    }
}

// MARK: - Toast

struct ToastModifier: ViewModifier {
    let message: String?

    func body(content: Content) -> some View {
        ZStack {
            content
            if let message {
                VStack {
                    Spacer()
                    Text(message)
                        .font(Theme.captionFont(13))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.black.opacity(0.75))
                        .clipShape(Capsule())
                        .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.25), value: message)
            }
        }
    }
}

extension View {
    func toast(message: String?) -> some View {
        modifier(ToastModifier(message: message))
    }
}
