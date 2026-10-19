import SwiftUI

// 社区模块视图集 —— 对应原 APK hj_page/community/ 下 32 个 .dart 文件：
//   community_main_page_page/community_main_page.dart   社区主框架（多 Tab）
//   community_tab_page/community_tab_page.dart           分区 Tab
//   community_module_page/community_module_page.dart     模块页
//   community_tag_page/community_tag_page.dart           标签页
//   community_tag_page/subviews/tag_detail_subview.dart 标签详情
//   publish_page/chose_tag_page.dart                     发布时选话题
//   post_detail_page/post_detail_page.dart               帖子详情

// MARK: - 话题选择（publish_page/chose_tag_page.dart）

struct ChoseTagView: View {
    @Binding var selected: [String]
    @Environment(\.dismiss) private var dismiss

    private let groups: [(String, [String])] = [
        ("推荐", ["都市", "甜宠", "逆袭", "战神", "重生", "穿越"]),
        ("情感", ["青梅竹马", "契约婚姻", "破镜重圆", "暗恋"]),
        ("爽文", ["打脸", "扮猪吃虎", "马甲", "团宠"]),
        ("标签", ["热门", "新品", "完结", "高分"]),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        if !selected.isEmpty {
                            HStack(spacing: 8) {
                                Text("已选").font(Theme.captionFont(12))
                                    .foregroundStyle(Theme.textSecondary)
                                ForEach(selected, id: \.self) { t in
                                    Button {
                                        selected.removeAll { $0 == t }
                                    } label: {
                                        HStack(spacing: 3) {
                                            Text(t).font(Theme.captionFont(11))
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.system(size: 9))
                                        }
                                        .foregroundStyle(.black)
                                        .padding(.horizontal, 8).padding(.vertical, 4)
                                        .background(Theme.gold, in: Capsule())
                                    }
                                    .buttonStyle(.plain)
                                }
                                Spacer()
                            }
                            .padding(14)
                            .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                        }
                        ForEach(groups, id: \.0) { g in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(g.0)
                                    .font(Theme.titleFont(14))
                                    .foregroundStyle(Theme.gold)
                                FlowLayout(spacing: 8) {
                    ForEach(g.1, id: \.self) { t in
                        Button {
                            if !selected.contains(t) { selected.append(t) }
                        } label: {
                            Text(t)
                                .font(Theme.captionFont(12))
                                .foregroundStyle(Theme.textSecondary)
                                .padding(.horizontal, 12).padding(.vertical, 7)
                                .background(Theme.bgCardHi, in: Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                            }
                            .padding(14)
                            .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                        }
                        Spacer()
                    }
                    .padding(Theme.hPad)
                }
            }
            .navigationTitle("选择话题")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                        .font(Theme.bodyFont(14))
                        .foregroundStyle(Theme.gold)
                }
            }
        }
    }
}

/// 可点击的标签流（复用 PortingView 的 FlowChips，增加 onTap）
private struct TagFlowChips: View {
    let items: [String]
    var onTap: (String) -> Void

    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(items, id: \.self) { it in
                Button { onTap(it) } label: {
                    Text(it)
                        .font(Theme.captionFont(12))
                        .foregroundStyle(Theme.textSecondary)
                        .padding(.horizontal, 12).padding(.vertical, 7)
                        .background(Theme.bgCardHi, in: Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - 标签详情（community_tag_page/subviews/tag_detail_subview.dart）

struct TagDetailView: View {
    let tag: String
    @State private var posts: [CommunityPost] = []
    @State private var sort = "最新"

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                ForEach(["最新", "最热"], id: \.self) { s in
                    Button(s) { sort = s }
                        .font(Theme.captionFont(12))
                        .foregroundStyle(sort == s ? .black : Theme.textSecondary)
                        .padding(.horizontal, 14).padding(.vertical, 6)
                        .background(sort == s ? Theme.gold : Theme.bgCardHi,
                                    in: Capsule())
                }
                Spacer()
            }
            .padding(Theme.hPad).padding(.vertical, 10)

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(posts) { p in CommunityPostCell(post: p) }
                }
                .padding(Theme.hPad)
            }
        }
        .background(Theme.bg)
        .navigationTitle("# \(tag)")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            posts = (try? await CommunityService().tagPosts(tag: tag)) ?? []
        }
    }
}

// MARK: - 动态消息（mine/message/message_center_page.dart）

struct MessageCenterView: View {
    @State private var tab = 0
    @State private var items: [DynamicMessage] = []
    private let tabs = ["互动", "关注", "系统"]

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $tab) {
                ForEach(tabs, id: \.self) { Text($0).tag(tabs.firstIndex(of: $0) ?? 0) }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, Theme.hPad).padding(.vertical, 10)

            Group {
                if items.isEmpty {
                    LLDJEmpty(icon: "bell", title: "暂无消息",
                              desc: "点赞、评论、关注等互动消息会显示在这里")
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(items) { m in
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle().fill(Theme.bgCardHi).frame(width: 42, height: 42)
                                        Image(systemName: m.icon)
                                            .font(.system(size: 16))
                                            .foregroundStyle(Theme.gold)
                                    }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(m.title)
                                            .font(Theme.bodyFont(14))
                                            .foregroundStyle(Theme.textPrimary)
                                        Text(m.body)
                                            .font(Theme.captionFont(11))
                                            .foregroundStyle(Theme.textTertiary)
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                    Text(m.time)
                                        .font(Theme.captionFont(10))
                                        .foregroundStyle(Theme.textTertiary)
                                }
                                .padding(.horizontal, Theme.hPad).padding(.vertical, 12)
                                Divider().overlay(Theme.separator).padding(.leading, 68)
                            }
                        }
                        .background(Theme.bgCard)
                    }
                }
            }
        }
        .background(Theme.bg)
        .navigationTitle("消息")
        .navigationBarTitleDisplayMode(.inline)
        .task { items = MockData.dynamicMessages }
    }
}

// MARK: - 动态消息模型（对应 /msg/dynamic/list）

struct DynamicMessage: Identifiable {
    let id: String
    let icon: String
    let title: String
    let body: String
    let time: String
}

extension MockData {
    static let dynamicMessages: [DynamicMessage] = [
        DynamicMessage(id: "m1", icon: "hand.thumbsup", title: "点赞",
                       body: "橘子汽水 赞了你的作品", time: "10 分钟前"),
        DynamicMessage(id: "m2", icon: "bubble.left", title: "评论",
                       body: "午夜场 回复：好看，已追", time: "1 小时前"),
        DynamicMessage(id: "m3", icon: "person.badge.plus", title: "关注",
                       body: "追剧小分队 关注了你", time: "昨天"),
        DynamicMessage(id: "m4", icon: "megaphone", title: "系统通知",
                       body: "会员到期时间临近，请及时续费", time: "3 天前"),
    ]
}

// MARK: - 社区搜索（community/hot_search.dart）

struct CommunitySearchView: View {
    @State private var keyword = ""
    @State private var hot: [String] = ["短剧", "追剧", "原神", "新剧上线", "甜宠", "逆袭"]
    @State private var results: [CommunityPost] = []

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.textTertiary)
                    TextField("搜索社区内容", text: $keyword)
                        .font(Theme.bodyFont(14))
                        .foregroundStyle(Theme.textPrimary)
                        .submitLabel(.search)
                        .onSubmit { search() }
                }
                .padding(.horizontal, 12).padding(.vertical, 9)
                .background(Theme.bgCard, in: Capsule())
                if !keyword.isEmpty {
                    Button("取消") { keyword = "" }
                        .font(Theme.captionFont(13))
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            .padding(Theme.hPad)

            if results.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("热门搜索")
                        .font(Theme.captionFont(12))
                        .foregroundStyle(Theme.textSecondary)
                    TagFlowChips(items: hot) { k in
                        keyword = k
                        search()
                    }
                    Spacer()
                }
                .padding(Theme.hPad)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(results) { p in CommunityPostCell(post: p) }
                    }
                    .padding(Theme.hPad)
                }
            }
        }
        .background(Theme.bg)
        .navigationTitle("搜索")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func search() {
        guard !keyword.isEmpty else { return }
        Task {
            results = (try? await CommunityService().search(keyword: keyword)) ?? []
        }
    }
}