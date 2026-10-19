import SwiftUI
import AVKit

/// 通用播放器（对应 hj_page/drama/view/drama_video_player）
struct VideoPlayerView: View {
    let url: URL
    @State private var player: AVPlayer?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VideoPlayer(player: player)
            .ignoresSafeArea()
            .background(.black)
            .onAppear {
                let item = AVPlayerItem(url: url)
                let p = AVPlayer(playerItem: item)
                player = p
                p.play()
            }
            .onDisappear { player?.pause() }
    }
}
