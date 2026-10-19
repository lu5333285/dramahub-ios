import SwiftUI

/// 异步图片加载 + 内存/磁盘缓存（对应 tools_base/widget/net_image_widget）
final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private static let memoryCache = NSCache<NSURL, UIImage>()
    private static let diskQueue = DispatchQueue(label: "imageloader.disk")

    let url: URL?

    init(_ urlString: String?) {
        self.url = URL(string: urlString ?? "")
    }

    func load() {
        guard let url, image == nil else { return }
        if let cached = Self.memoryCache.object(forKey: url as NSURL) {
            image = cached
            return
        }
        Task.detached(priority: .utility) { [weak self] in
            guard let self else { return }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let uiImage = UIImage(data: data) else { return }
                Self.memoryCache.setObject(uiImage, forKey: url as NSURL)
                await MainActor.run { self.image = uiImage }
            } catch { /* 静默失败，显示占位 */ }
        }
    }
}

struct NetworkImage: View {
    let urlString: String?
    var contentMode: SwiftUI.ContentMode = .fill

    @StateObject private var loader: ImageLoader

    init(_ urlString: String?, contentMode: SwiftUI.ContentMode = .fill) {
        self.urlString = urlString
        self.contentMode = contentMode
        _loader = StateObject(wrappedValue: ImageLoader(urlString))
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                Rectangle()
                    .fill(Theme.bgCardHi)
                    .overlay(Image(systemName: "photo").foregroundStyle(Theme.textTertiary))
            }
        }
        .onAppear { loader.load() }
    }
}
