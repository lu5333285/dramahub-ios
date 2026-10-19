import SwiftUI

// 移植总览 —— 逐项对照原 APK（Flutter AOT / Dart）的还原情况。
// 数据全部来自 rea_analysis 对 libapp.so 的静态提取，无任何估算。

struct PortingView: View {
    @EnvironmentObject private var session: SessionStore
    @State private var tab: PortTab = .module

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 18) {
                    header
                    stats
                    switch tab {
                    case .module: moduleList
                    case .page:   pageList
                    case .api:    apiList
                    case .asset:  assetList
                    }
                }
                .padding(Theme.hPad)
            }
        }
        .navigationTitle("移植总览")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - 头部

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("lldj2.4.0V5.apk → iOS")
                .font(Theme.titleFont(22))
                .foregroundStyle(Theme.textPrimary)
            Text("来源：lib/arm64-v8a/libapp.so（Dart AOT 快照）")
                .font(Theme.captionFont())
                .foregroundStyle(Theme.textTertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - 统计

    private var stats: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
            statCard("Dart 源文件", LLDJPortMap.totalDartFiles, "个", "widget")
            statCard("页面类 Page", LLDJPortMap.totalPages, "个", "tv")
            statCard("控制器 Logic", LLDJPortMap.totalLogics, "个", "slider.horizontal.3")
            statCard("JSON 模型", LLDJPortMap.totalJsonModels, "个", "shippingbox")
            statCard("网络端点", LLDJEndpoint.all.count, "条", "network")
            statCard("图片资源", LLDJAsset.allNames.count, "张", "photo")
        }
    }

    private func statCard(_ name: String, _ value: Int, _ unit: String, _ icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.gold)
                Text(name)
                    .font(Theme.captionFont())
                    .foregroundStyle(Theme.textSecondary)
            }
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text("\(value)")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.textPrimary)
                Text(unit)
                    .font(Theme.captionFont())
                    .foregroundStyle(Theme.textTertiary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
    }

    // MARK: - 分段

    private var segmented: some View {
        Picker("", selection: $tab) {
            ForEach(PortTab.allCases, id: \.self) { Text($0.title).tag($0) }
        }
        .pickerStyle(.segmented)
    }

    // MARK: - Dart 模块

    private var moduleList: some View {
        VStack(spacing: 18) {
            segmented
            VStack(spacing: 10) {
                ForEach(LLDJPortMap.areas) { area in
                    NavigationLink {
                        PortingAreaDetail(area: area)
                    } label: {
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Theme.gold.opacity(0.16))
                                .frame(width: 42, height: 42)
                                .overlay(
                                    Text(String(area.title.prefix(1)))
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(Theme.gold)
                                )
                            VStack(alignment: .leading, spacing: 3) {
                                Text(area.title)
                                    .font(Theme.titleFont(15))
                                    .foregroundStyle(Theme.textPrimary)
                                Text("hj_page/\(area.dartDir)")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundStyle(Theme.textTertiary)
                                    .lineLimit(1)
                            }
                            Spacer()
                            Text("\(area.fileCount)")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundStyle(Theme.gold)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 11))
                                .foregroundStyle(Theme.textTertiary)
                        }
                        .padding(12)
                        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - 页面清单

    private var pageList: some View {
        VStack(spacing: 18) {
            segmented
            VStack(alignment: .leading, spacing: 10) {
                Text("共 \(LLDJPageIndex.pages.count) 个 GetX 页面类")
                    .font(Theme.captionFont())
                    .foregroundStyle(Theme.textSecondary)
                FlowChips(items: LLDJPageIndex.pages)
            }
        }
    }

    // MARK: - 端点

    private var apiList: some View {
        VStack(spacing: 18) {
            segmented
            ForEach(LLDJDomain.allCases, id: \.self) { d in
                let eps = LLDJEndpoint.byDomain(d)
                if !eps.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(d.title)
                                .font(Theme.titleFont(15))
                                .foregroundStyle(Theme.textPrimary)
                            Text(d.group)
                                .font(Theme.captionFont())
                                .foregroundStyle(Theme.textTertiary)
                            Spacer()
                            Text("\(eps.count)")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundStyle(Theme.gold)
                        }
                        ForEach(eps, id: \.path) { ep in
                            EndpointRow(ep: ep)
                        }
                    }
                    .padding(12)
                    .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                }
            }
        }
    }

    // MARK: - 资源

    private var assetList: some View {
        VStack(spacing: 18) {
            segmented
            let groups = Dictionary(grouping: LLDJAsset.allNames) { String($0.split(separator: "_").first ?? "") }
            VStack(spacing: 12) {
                ForEach(groups.keys.sorted(), id: \.self) { g in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(g)
                            .font(Theme.titleFont(14))
                            .foregroundStyle(Theme.gold)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                            ForEach(groups[g]!, id: \.self) { name in
                                AssetThumb(name: name)
                            }
                        }
                    }
                    .padding(12)
                    .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                }
            }
        }
    }
}

// MARK: - 子视图

private struct EndpointRow: View {
    let ep: LLDJEndpointDef
    var body: some View {
        HStack(spacing: 8) {
            Text(ep.method.rawValue)
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(ep.method == .get ? Theme.gold : Theme.brand)
                .frame(width: 30)
            Text(ep.path)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(1)
            Spacer()
        }
    }
}

private struct AssetThumb: View {
    let name: String
    var body: some View {
        VStack(spacing: 4) {
            AssetIcon(asset: name, size: 34, tint: Theme.gold)
                .frame(height: 34)
            Text(name.split(separator: "_").last.map(String.init) ?? name)
                .font(.system(size: 8))
                .foregroundStyle(Theme.textTertiary)
                .lineLimit(1)
        }
        .padding(6)
        .background(Theme.bgCardHi, in: RoundedRectangle(cornerRadius: 8))
    }
}

/// 自动换行的标签流
struct FlowChips: View {
    let items: [String]
    var body: some View {
        FlowLayout(spacing: 6) {
            ForEach(items, id: \.self) { it in
                Text(it)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(Theme.textSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.bgCardHi, in: Capsule())
            }
        }
    }
}

struct PortingAreaDetail: View {
    let area: LLDJFeatureArea
    private var files: [String] {
        area.dartDir.split(separator: ",").map(String.init)
    }
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(area.title)
                            .font(Theme.titleFont(20))
                            .foregroundStyle(Theme.textPrimary)
                        Text("原 Dart 目录 hj_page/\(area.dartDir)")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(Theme.textTertiary)
                        Text("iOS 对应：\(area.swiftDir)")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(Theme.gold)
                    }
                    FlowChips(items: files)
                }
                .padding(Theme.hPad)
            }
        }
        .navigationTitle(area.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

enum PortTab: String, CaseIterable {
    case module, page, api, asset
    var title: String {
        switch self {
        case .module: return "模块"
        case .page:   return "页面"
        case .api:    return "端点"
        case .asset:  return "资源"
        }
    }
}