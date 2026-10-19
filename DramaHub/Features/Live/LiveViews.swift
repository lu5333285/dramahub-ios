import SwiftUI

// MARK: - 直播列表（live/live_main_page + live_detail_page）

@MainActor
final class LiveListViewModel: ObservableObject {
    @Published var modules: [LiveModule] = []
    @Published var anchors: [LiveAnchor] = []
    @Published var selectedModuleId: String?
    @Published var isLoading = false

    private let service = LiveService()

    func load() async {
        isLoading = true
        defer { isLoading = false }
        modules = (try? await service.modules()) ?? []
        if selectedModuleId == nil { selectedModuleId = modules.first?.id }
        if let moduleId = selectedModuleId {
            anchors = (try? await service.anchors(moduleId: moduleId)) ?? []
        }
    }

    func select(_ module: LiveModule) async {
        selectedModuleId = module.id
        anchors = (try? await service.anchors(moduleId: module.id)) ?? []
    }
}

struct LiveListView: View {
    @StateObject private var vm = LiveListViewModel()

    private let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

    var body: some View {
        ScrollView {
            // 模块 Tab
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(vm.modules) { module in
                        Button { Task { await vm.select(module) } } label: {
                            HStack(spacing: 4) {
                                Image(systemName: module.icon ?? "circle")
                                    .font(.system(size: 11))
                                Text(module.name ?? "")
                                    .font(Theme.bodyFont(13))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(vm.selectedModuleId == module.id ? Theme.live : Theme.bgCard)
                            .foregroundStyle(vm.selectedModuleId == module.id ? .white : Theme.textSecondary)
                            .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, Theme.hPad)
            }
            .padding(.top, 8)

            // 主播九宫格（nine_grid_bg）
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(vm.anchors) { anchor in
                    VStack(spacing: 0) {
                        NetworkImage(anchor.cover)
                            .aspectRatio(3 / 4, contentMode: .fit)
                            .overlay(alignment: .topLeading) {
                                HStack(spacing: 3) {
                                    Circle().fill(Theme.live).frame(width: 5, height: 5)
                                    Text("直播中")
                                        .font(Theme.captionFont(9))
                                        .foregroundStyle(.white)
                                }
                                .padding(.horizontal, 5)
                                .padding(.vertical, 3)
                                .background(.black.opacity(0.45))
                                .clipShape(Capsule())
                                .padding(6)
                            }
                            .overlay(alignment: .bottomTrailing) {
                                HStack(spacing: 3) {
                                    Image(systemName: "eye")
                                    Text("\(formatViewers(anchor.viewers))")
                                }
                                .font(Theme.captionFont(9))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 3)
                                .background(.black.opacity(0.45))
                                .clipShape(Capsule())
                                .padding(6)
                            }
                            .clipped()
                        VStack(alignment: .leading, spacing: 3) {
                            Text(anchor.nickname ?? "")
                                .font(Theme.bodyFont(12))
                                .foregroundStyle(Theme.textPrimary)
                                .lineLimit(1)
                            if !anchor.tags.isEmpty {
                                Text(anchor.tags.joined(separator: " · "))
                                    .font(Theme.captionFont(9))
                                    .foregroundStyle(Theme.textTertiary)
                                    .lineLimit(1)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    }
                    .background(Theme.bgCard)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
            .padding(Theme.hPad)
            .padding(.top, 10)
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle("直播")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load() }
    }

    private func formatViewers(_ count: Int) -> String {
        if count >= 10000 { return String(format: "%.1f万", Double(count) / 10000) }
        return "\(count)"
    }
}

// MARK: - AI 首页（ai/ai_home_page）

@MainActor
final class AIHomeViewModel: ObservableObject {
    @Published var modules: [AIModule] = []
    @Published var records: [AIRecord] = []

    private let service = AIService()

    func load() async {
        modules = (try? await service.modules()) ?? []
        records = (try? await service.records()) ?? []
    }
}

struct AIHomeView: View {
    @StateObject private var vm = AIHomeViewModel()

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(vm.modules) { module in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: module.icon ?? "sparkles")
                                .font(.system(size: 22))
                                .foregroundStyle(Theme.gold)
                            Spacer()
                            if module.hot {
                                Text("HOT")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .background(Theme.live)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                        }
                        Text(module.name ?? "")
                            .font(Theme.titleFont(15))
                            .foregroundStyle(Theme.textPrimary)
                        Text(module.desc ?? "")
                            .font(Theme.captionFont(11))
                            .foregroundStyle(Theme.textTertiary)
                            .lineLimit(2)
                        Spacer()
                        HStack {
                            if module.isVipFree {
                                VIPBadge(text: "会员免费")
                            } else {
                                CoinBadge(amount: module.coinCost, compact: true)
                                Text("/次")
                                    .font(Theme.captionFont(10))
                                    .foregroundStyle(Theme.textTertiary)
                            }
                            Spacer()
                            Text("去生成")
                                .font(Theme.captionFont(11))
                                .foregroundStyle(.black)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Theme.gold)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(12)
                    .frame(height: 150)
                    .background(Theme.bgCard)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius, style: .continuous))
                }
            }
            .padding(Theme.hPad)

            // 生成记录（ai_record）
            if !vm.records.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("生成记录")
                        .font(Theme.titleFont(15))
                        .foregroundStyle(Theme.textPrimary)
                    ForEach(vm.records) { record in
                        HStack(spacing: 12) {
                            NetworkImage(record.cover)
                                .frame(width: 56, height: 56)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(recordTypeName(record.type))
                                    .font(Theme.bodyFont(13))
                                    .foregroundStyle(Theme.textPrimary)
                                Text(record.createdAt ?? "")
                                    .font(Theme.captionFont(10))
                                    .foregroundStyle(Theme.textTertiary)
                            }
                            Spacer()
                            Text(recordStatusName(record.status))
                                .font(Theme.captionFont(11))
                                .foregroundStyle(record.status == "success" ? Color.green : Theme.gold)
                        }
                        .padding(10)
                        .background(Theme.bgCard)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                    }
                }
                .padding(Theme.hPad)
            }
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle("AI 创作")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load() }
    }

    private func recordTypeName(_ type: String?) -> String {
        switch type {
        case "img": return "AI 绘画"
        case "video": return "图生视频"
        case "novel": return "AI 小说"
        default: return "生成任务"
        }
    }

    private func recordStatusName(_ status: String?) -> String {
        switch status {
        case "success": return "已完成"
        case "doing": return "生成中"
        case "failed": return "失败"
        default: return "排队中"
        }
    }
}
