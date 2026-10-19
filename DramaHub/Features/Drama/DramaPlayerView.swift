import SwiftUI
import AVKit

@MainActor
final class DramaPlayerViewModel: ObservableObject {
    @Published var detail: DramaMediaInfo?
    @Published var currentEpisode: DramaMediaInfo.DramaEpisode?
    @Published var playInfo: PlayInfo?
    @Published var isPlaying = false
    @Published var showEpisodes = false
    @Published var errorMessage: String?

    let mediaId: String
    let startEpisodeId: String
    private let service = DramaService()

    init(mediaId: String, startEpisodeId: String) {
        self.mediaId = mediaId
        self.startEpisodeId = startEpisodeId
    }

    func load() async {
        do {
            detail = try await service.detail(id: mediaId)
            guard let ep = detail?.episodes.first(where: { $0.id == startEpisodeId }) else { return }
            currentEpisode = ep
            await play(ep)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func play(_ episode: DramaMediaInfo.DramaEpisode) async {
        do {
            playInfo = try await service.playInfo(episodeId: episode.id)
            currentEpisode = episode
            PlaybackStore.shared.saveResume(dramaId: mediaId, episodeId: episode.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func next() async {
        guard let detail, let current = currentEpisode,
              let idx = detail.episodes.firstIndex(where: { $0.id == current.id }),
              idx + 1 < detail.episodes.count else { return }
        await play(detail.episodes[idx + 1])
    }
}

struct DramaPlayerView: View {
    @StateObject private var vm: DramaPlayerViewModel
    @Environment(\.dismiss) private var dismiss

    init(mediaId: String, startEpisodeId: String) {
        _vm = StateObject(wrappedValue: DramaPlayerViewModel(mediaId: mediaId, startEpisodeId: startEpisodeId))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // 播放器区域（m3u8，AVPlayer 原生支持）
            playerArea

            // 顶部信息
            VStack {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                    Spacer()
                    if let ep = vm.currentEpisode {
                        Text("第 \(ep.index) 集")
                            .font(Theme.titleFont(15))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    Button { vm.showEpisodes = true } label: {
                        Image(systemName: "list.number")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, Theme.hPad)
                .padding(.top, 44)
                Spacer()
            }

            // 底部控制
            VStack(spacing: 12) {
                if let info = vm.playInfo, info.isH265 {
                    HStack(spacing: 6) {
                        Image(systemName: "cpu")
                        Text("H.265 片源，如卡顿可切换线路")
                    }
                    .font(Theme.captionFont(11))
                    .foregroundStyle(Theme.textSecondary)
                }
                HStack {
                    Button { Task { await vm.next() } } label: {
                        Label("下一集", systemImage: "forward.fill")
                            .font(Theme.bodyFont(13))
                            .foregroundStyle(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Theme.gold)
                            .clipShape(Capsule())
                    }
                    Spacer()
                    Text("演示片源")
                        .font(Theme.captionFont(11))
                        .foregroundStyle(Theme.textTertiary)
                }
            }
            .padding(Theme.hPad)
            .padding(.bottom, 24)
        }
        .background(Color.black.ignoresSafeArea())
        .task { await vm.load() }
        .sheet(isPresented: $vm.showEpisodes) {
            episodeSheet
                .presentationDetents([.medium, .large])
        }
    }

    @ViewBuilder
    private var playerArea: some View {
        if let info = vm.playInfo, let url = URL(string: info.url ?? "") {
            VideoPlayer(player: AVPlayer(url: url))
                .ignoresSafeArea()
        } else {
            Rectangle()
                .fill(.black)
                .overlay(ProgressView().tint(Theme.gold))
                .ignoresSafeArea()
        }
    }

    private var episodeSheet: some View {
        NavigationStack {
            ScrollView {
                if let detail = vm.detail {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 10) {
                        ForEach(detail.episodes.prefix(80)) { ep in
                            Button {
                                Task { await vm.play(ep) }
                                vm.showEpisodes = false
                            } label: {
                                Text("\(ep.index)")
                                    .font(Theme.captionFont(12))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 9)
                                    .background(vm.currentEpisode?.id == ep.id ? Theme.gold : Theme.bgCard)
                                    .foregroundStyle(vm.currentEpisode?.id == ep.id ? Color.black : Theme.textSecondary)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    .overlay(alignment: .topTrailing) {
                                        if ep.locked {
                                            Image(systemName: "lock.fill")
                                                .font(.system(size: 8))
                                                .foregroundStyle(Theme.textTertiary)
                                        }
                                    }
                            }
                        }
                    }
                    .padding(Theme.hPad)
                }
            }
            .background(Theme.bg.ignoresSafeArea())
            .navigationTitle("选集")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { vm.showEpisodes = false }.foregroundStyle(Theme.gold)
                }
            }
        }
    }
}
