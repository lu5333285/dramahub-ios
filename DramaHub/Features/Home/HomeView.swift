import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var homeData = HomeData(banners: [], modules: [], hotKeywords: [])
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = HomeService()

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            homeData = try await service.load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @State private var selectedModule = 0

    var body: some View {
        ScrollView {
            // 快捷入口（直播 / AI 创作，对应首页动态模块位）
            HStack(spacing: 12) {
                NavigationLink { LiveListView() } label: {
                    quickEntry(icon: "video.fill", title: "直播", tint: Theme.live)
                }
                NavigationLink { AIHomeView() } label: {
                    quickEntry(icon: "sparkles", title: "AI 创作", tint: Theme.gold)
                }
                NavigationLink { SearchView() } label: {
                    quickEntry(icon: "magnifyingglass", title: "搜索", tint: Color.blue)
                }
            }
            .padding(.horizontal, Theme.hPad)
            .padding(.top, 8)

            // 顶部 Banner（banner/list）
            BannerCarousel(items: vm.homeData.banners)
                .frame(height: 160)
                .padding(.horizontal, Theme.hPad)
                .padding(.top, 8)

            // 模块 Tab（modules/list，支持排序）
            if !vm.homeData.modules.isEmpty {
                moduleTabs
                    .padding(.top, 12)

                // 内容网格
                let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(currentItems) { item in
                        NavigationLink(value: item) {
                            MediaCell(item: item)
                        }
                    }
                }
                .padding(.horizontal, Theme.hPad)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle("首页")
        .navigationDestination(for: MediaContent.self) { item in
            DramaDetailView(mediaId: item.id)
        }
        .task { if vm.homeData.modules.isEmpty { await vm.load() } }
        .overlay {
            if vm.isLoading && vm.homeData.modules.isEmpty { ProgressView().tint(Theme.gold) }
        }
    }

    private var currentItems: [MediaContent] {
        vm.homeData.modules.indices.contains(selectedModule)
            ? vm.homeData.modules[selectedModule].items : []
    }

    private func quickEntry(icon: String, title: String, tint: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(tint)
            Text(title)
                .font(Theme.bodyFont(13))
                .foregroundStyle(Theme.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Theme.bgCard)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private var moduleTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(vm.homeData.modules.enumerated()), id: \.element.id) { index, module in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) { selectedModule = index }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: module.icon ?? "circle")
                                .font(.system(size: 12))
                            Text(module.name ?? "")
                                .font(Theme.bodyFont(13))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(selectedModule == index ? Theme.gold : Theme.bgCard)
                        .foregroundStyle(selectedModule == index ? Color.black : Theme.textSecondary)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, Theme.hPad)
        }
    }
}

/// Banner 轮播（home_sub_module/widget/module_banner_bar）
struct BannerCarousel: View {
    let items: [BannerItem]
    @State private var index = 0

    var body: some View {
        TabView(selection: $index) {
            ForEach(Array(items.enumerated()), id: \.element.id) { i, item in
                ZStack(alignment: .bottomLeading) {
                    NetworkImage(item.image)
                        .frame(maxWidth: .infinity)
                        .clipped()
                    if let title = item.title {
                        Text(title)
                            .font(Theme.titleFont(15))
                            .foregroundStyle(.white)
                            .padding(12)
                            .shadow(color: .black.opacity(0.6), radius: 6)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: Theme.radius, style: .continuous))
                .tag(i)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
    }
}

/// 媒资单元格（home_cell_style/video_simple_cell）
struct MediaCell: View {
    let item: MediaContent

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .topTrailing) {
                NetworkImage(item.cover)
                    .aspectRatio(3 / 4, contentMode: .fit)
                    .clipped()
                if item.isVipOnly == true { VIPBadge().padding(6) }
                if let count = item.episodeCount {
                    Text("全 \(count) 集")
                        .font(Theme.captionFont(10))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(.black.opacity(0.55))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .padding(6)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            Text(item.title ?? "")
                .font(Theme.bodyFont(13))
                .fontWeight(.medium)
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(1)

            HStack(spacing: 6) {
                Text("\(formatPlayCount(item.playCount ?? 0)) 播放")
                    .font(Theme.captionFont(10))
                    .foregroundStyle(Theme.textTertiary)
                Spacer()
                if let price = item.coinPrice, price > 0 {
                    CoinBadge(amount: price, compact: true)
                } else {
                    Text("免费")
                        .font(Theme.captionFont(10))
                        .foregroundStyle(Theme.gold)
                }
            }
        }
    }

    private func formatPlayCount(_ count: Int) -> String {
        if count >= 10000 { return String(format: "%.1f万", Double(count) / 10000) }
        return "\(count)"
    }
}
