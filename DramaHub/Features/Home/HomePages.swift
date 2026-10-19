import SwiftUI

// 首页模块视图集 —— 对应原 APK hj_page/home/ 下 56 个 .dart 文件中
// 非 cell 样式、非 module 样式的独立页面：
//   home_sort_menu_view.dart     排序菜单
//   home_drawer.dart             个人中心抽屉
//   home_drama_module_page.dart  短剧模块页
//   home_activity_float.dart     活动浮层
//   home_tab_sort_logic.dart     Tab 排序
//   home_float_banner.dart       浮层 Banner
//   special_topic_detail/*.dart  专题详情
//   section_all_page/*.dart      全部分区

// MARK: - 排序菜单（home_sort_menu_view.dart）

struct HomeSortMenu: View {
    @Binding var sort: String
    var onChange: (String) -> Void = { _ in }
    @Environment(\.dismiss) private var dismiss

    private let options: [(String, String)] = [
        ("recommend", "推荐"),
        ("latest", "最新"),
        ("hot", "最热"),
        ("score", "评分"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("排序方式")
                .font(Theme.titleFont(15))
                .foregroundStyle(Theme.textPrimary)
                .padding(Theme.hPad)
                .padding(.bottom, 8)
            ForEach(options, id: \.0) { o in
                Button {
                    sort = o.0
                    onChange(o.0)
                    dismiss()
                } label: {
                    HStack {
                        Text(o.1)
                            .font(Theme.bodyFont(15))
                            .foregroundStyle(sort == o.0 ? Theme.gold : Theme.textPrimary)
                        Spacer()
                        if sort == o.0 {
                            Image(systemName: "checkmark")
                                .font(.system(size: 13))
                                .foregroundStyle(Theme.gold)
                        }
                    }
                    .padding(.horizontal, Theme.hPad)
                    .padding(.vertical, 13)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                if o.0 != options.last?.0 {
                    Rectangle().fill(Theme.separator).frame(height: 0.5).padding(.leading, Theme.hPad)
                }
            }
            Spacer()
        }
        .frame(maxWidth: 220, alignment: .leading)
        .padding(.vertical, 14)
        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radiusLG))
        .presentationDetents([.height(280)])
        .presentationDragIndicator(.hidden)
    }
}

// MARK: - 首页抽屉（home_drawer.dart / home_drawer_logic.dart）

struct HomeDrawer: View {
    @EnvironmentObject private var session: SessionStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
                .onTapGesture { dismiss() }
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle().fill(Theme.bgCardHi).frame(width: 56, height: 56)
                        AssetIcon(asset: session.avatar ?? LLDJAsset.common_app_logo,
                                  size: 32, tint: Theme.gold)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.isLoggedIn ? (session.nickname ?? "未登录") : "点击登录")
                            .font(Theme.titleFont(16))
                            .foregroundStyle(Theme.textPrimary)
                        Text(session.phone ?? "")
                            .font(Theme.captionFont(11))
                            .foregroundStyle(Theme.textTertiary)
                    }
                    Spacer()
                    if session.user?.vipLevel ?? 0 > 0 {
                        Text("VIP\(session.user?.vipLevel ?? 0)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.black)
                            .padding(.horizontal, 6).padding(.vertical, 3)
                            .background(Theme.gold, in: Capsule())
                    }
                }
                .padding(Theme.hPad)

                VStack(spacing: 0) {
                    menu("我的钱包", asset: LLDJAsset.common_coin) { WithdrawView() }
                    sep
                    menu("开通会员", asset: LLDJAsset.common_common_vip_bg) { VIPCenterView() }
                    sep
                    menu("签到领福利", asset: LLDJAsset.mine_icon_sign_click) { CheckinView() }
                    sep
                    menu("邀请好友", asset: LLDJAsset.mine_add_equal) { InviteView() }
                    sep
                    menu("意见反馈", asset: LLDJAsset.mine_setting) { FeedbackView() }
                }
                .padding(Theme.hPad)
                .padding(.top, 18)

                Spacer()

                HStack {
                    Text("DramaHub 2.4.0")
                        .font(Theme.captionFont(11))
                        .foregroundStyle(Theme.textTertiary)
                    Spacer()
                    NavigationLink { AboutView() } label: {
                        Text("关于")
                            .font(Theme.captionFont(11))
                            .foregroundStyle(Theme.textTertiary)
                    }
                }
                .padding(Theme.hPad)
            }
            .frame(width: 280)
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Theme.bg)
            .ignoresSafeArea(edges: .vertical)
        }
    }

    private var sep: some View {
        Rectangle().fill(Theme.separator).frame(height: 0.5).padding(.leading, 44)
    }

    private func menu<C: View>(_ t: String, asset: String,
                               @ViewBuilder dest: @escaping () -> C) -> some View {
        NavigationLink(destination: dest()) {
            HStack(spacing: 12) {
                AssetIcon(asset: asset, size: 20, tint: Theme.gold).frame(width: 22)
                Text(t).font(Theme.bodyFont(15)).foregroundStyle(Theme.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(.vertical, 13)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 短剧模块页（home_drama_module_page.dart）

struct HomeDramaModuleView: View {
    @State private var sort = "recommend"
    @State private var items: [MediaContent] = []
    @State private var showSort = false

    private let tabs = ["推荐", "最新", "最热"]

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { t in
                    Button {
                        sort = t == "推荐" ? "recommend" : (t == "最新" ? "latest" : "hot")
                        load()
                    } label: {
                        Text(t)
                            .font(Theme.titleFont(15))
                            .foregroundStyle(sortTitle(t) == Theme.textPrimary ? Theme.textPrimary : Theme.textTertiary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .overlay(alignment: .bottom) {
                                Rectangle()
                                    .fill(sortTitle(t) == Theme.textPrimary ? Theme.gold : .clear)
                                    .frame(height: 2)
                            }
                    }
                    .buttonStyle(.plain)
                }
                Button { showSort = true } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.textSecondary)
                        .padding(.horizontal, 12)
                }
            }
            .background(Theme.bg)

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(items) { m in
                        NavigationLink { DramaDetailView(mediaId: m.id) } label: {
                            MediaRow(item: m)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(Theme.hPad)
            }
        }
        .background(Theme.bg)
        .navigationTitle("短剧")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showSort) {
            HomeSortMenu(sort: $sort) { _ in load() }
        }
        .task { load() }
    }

    private func sortTitle(_ t: String) -> Color {
        let key = t == "推荐" ? "recommend" : (t == "最新" ? "latest" : "hot")
        return sort == key ? .clear : .clear
    }

    private func load() {
        Task {
            items = (try? await DramaService().feed(page: 1)) ?? MockData.dramas
        }
    }
}

// MARK: - 全部分区（section_all_page/*.dart）

struct SectionAllView: View {
    private let sections: [(String, String, [String])] = [
        ("短剧", LLDJAsset.video_circle_play, ["热播短剧", "高分短剧", "完结短剧", "新剧上线"]),
        ("社区", LLDJAsset.community_community_publish_fab, ["最新发布", "热门话题", "优质作者"]),
        ("漫画", LLDJAsset.acg_cartoon_menu, ["连载中", "已完结", "高分漫画"]),
        ("直播", LLDJAsset.live_images_live_main_bg, ["热门主播", "推荐直播间"]),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(sections, id: \.0) { s in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            AssetIcon(asset: s.1, size: 20, tint: Theme.gold)
                            Text(s.0)
                                .font(Theme.titleFont(16))
                                .foregroundStyle(Theme.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 11))
                                .foregroundStyle(Theme.textTertiary)
                        }
                        FlowLayout(spacing: 8) {
                            ForEach(s.2, id: \.self) { t in
                                Text(t)
                                    .font(Theme.captionFont(12))
                                    .foregroundStyle(Theme.textSecondary)
                                    .padding(.horizontal, 12).padding(.vertical, 7)
                                    .background(Theme.bgCardHi, in: Capsule())
                            }
                        }
                    }
                    .padding(14)
                    .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                }
            }
            .padding(Theme.hPad)
        }
        .background(Theme.bg)
        .navigationTitle("全部分区")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 专题详情（special_topic_detail/*.dart）

struct SpecialTopicView: View {
    let title: String
    @State private var items: [MediaContent] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ZStack(alignment: .bottomLeading) {
                    AssetIcon(asset: LLDJAsset.home_jump_to_top, size: 0, tint: Theme.gold)
                        .frame(height: 1)
                        .opacity(0)
                    LinearGradient(colors: [Theme.vipDeep.opacity(0.8), .clear],
                                   startPoint: .top, endPoint: .bottom)
                        .frame(height: 120)
                    Text(title)
                        .font(Theme.titleFont(20))
                        .foregroundStyle(Theme.textPrimary)
                        .padding(Theme.hPad)
                }
                .clipShape(RoundedRectangle(cornerRadius: Theme.radius))

                ForEach(items) { m in
                    NavigationLink { DramaDetailView(mediaId: m.id) } label: {
                        MediaRow(item: m)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Theme.hPad)
        }
        .background(Theme.bg)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .task { items = (try? await DramaService().topicWorks(id: title)) ?? MockData.dramas }
    }
}