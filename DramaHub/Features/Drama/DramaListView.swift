import SwiftUI

@MainActor
final class DramaListViewModel: ObservableObject {
    @Published var items: [MediaContent] = []
    @Published var isLoading = false
    @Published var keyword = ""

    private let service = DramaService()

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do { items = try await service.feed(page: 1) } catch { }
    }
}

struct DramaListView: View {
    @StateObject private var vm = DramaListViewModel()
    @State private var showSearch = false

    var body: some View {
        ScrollView {
            let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12),
                           GridItem(.flexible(), spacing: 12)]
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(filtered) { item in
                    NavigationLink(value: item) {
                        MediaCell(item: item)
                    }
                }
            }
            .padding(.horizontal, Theme.hPad)
            .padding(.vertical, 12)
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle("短剧")
        .navigationDestination(for: MediaContent.self) { item in
            DramaDetailView(mediaId: item.id)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showSearch = true } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Theme.textPrimary)
                }
            }
        }
        .sheet(isPresented: $showSearch) { SearchView() }
        .task { if vm.items.isEmpty { await vm.load() } }
        .overlay {
            if vm.isLoading && vm.items.isEmpty { ProgressView().tint(Theme.gold) }
        }
    }

    private var filtered: [MediaContent] {
        guard !vm.keyword.isEmpty else { return vm.items }
        return vm.items.filter { $0.title?.contains(vm.keyword) == true }
    }
}

/// 搜索页（home/search_page/search_main_page）
struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var keyword = ""
    @FocusState private var focused: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass").foregroundStyle(Theme.textTertiary)
                    TextField("搜索短剧、演员、专题", text: $keyword)
                        .foregroundStyle(Theme.textPrimary)
                        .focused($focused)
                        .submitLabel(.search)
                    if !keyword.isEmpty {
                        Button { keyword = "" } label: {
                            Image(systemName: "xmark.circle.fill").foregroundStyle(Theme.textTertiary)
                        }
                    }
                }
                .padding(10)
                .background(Theme.bgCard)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                if !keyword.isEmpty {
                    Text("“\(keyword)” 的搜索结果（演示）")
                        .font(Theme.captionFont(12))
                        .foregroundStyle(Theme.textSecondary)
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 16) {
                            ForEach(MockData.dramaList.filter { $0.title?.contains(keyword) == true || ($0.tags?.contains(keyword) ?? false) }) { item in
                                NavigationLink(value: item) {
                                    MediaCell(item: item)
                                }
                            }
                        }
                    }
                } else {
                    Text("历史搜索")
                        .font(Theme.titleFont(14))
                        .foregroundStyle(Theme.textPrimary)
                    FlowLayout(spacing: 8) {
                        ForEach(["总裁", "闪婚", "战神", "重生"], id: \.self) { word in
                            Button(word) { keyword = word }
                                .font(Theme.captionFont(12))
                                .foregroundStyle(Theme.textSecondary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Theme.bgCard)
                                .clipShape(Capsule())
                        }
                    }
                }
                Spacer()
            }
            .padding(Theme.hPad)
            .background(Theme.bg.ignoresSafeArea())
            .navigationDestination(for: MediaContent.self) { item in
                DramaDetailView(mediaId: item.id)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { dismiss() }.foregroundStyle(Theme.gold)
                }
            }
        }
        .onAppear { focused = true }
    }
}

/// 简易流式布局（搜索热词）
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0
        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 { x = 0; y += rowHeight + spacing; rowHeight = 0 }
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }
        return CGSize(width: width, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowHeight: CGFloat = 0
        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX { x = bounds.minX; y += rowHeight + spacing; rowHeight = 0 }
            sub.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }
    }
}
