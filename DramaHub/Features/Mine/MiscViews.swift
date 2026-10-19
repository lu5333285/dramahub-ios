import SwiftUI

// MARK: - 我的追剧（collec_history_buy）

struct CollectionView: View {
    var body: some View {
        placeholder(title: "我的追剧", icon: "heart",
                    desc: "对应 jydj mine/collec_history_buy/col_his_buy_logic：追剧、收藏、购买记录（/mine/collect、/mine/collect/infoList、/mine/buyVid）")
    }
}

// MARK: - 我的缓存（mine_video_cache）

struct CacheView: View {
    var body: some View {
        placeholder(title: "我的缓存", icon: "arrow.down.circle",
                    desc: "对应 jydj mine/mine_video_cache + tools_base/video_download：m3u8 分片下载与本地管理，需 /media/drama/download/authorize 授权")
    }
}

// MARK: - 观看历史

struct HistoryView: View {
    @State private var history = PlaybackStore.shared.history()

    var body: some View {
        Group {
            if history.isEmpty {
                placeholder(title: "观看历史", icon: "clock.arrow.circlepath", desc: "还没有观看记录")
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(history) { item in
                            HStack(spacing: 12) {
                                NetworkImage(item.cover)
                                    .frame(width: 90, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(item.title ?? "")
                                        .font(Theme.bodyFont(14))
                                        .foregroundStyle(Theme.textPrimary)
                                        .lineLimit(2)
                                    Text(item.watchedAt.formatted(date: .abbreviated, time: .shortened))
                                        .font(Theme.captionFont(11))
                                        .foregroundStyle(Theme.textTertiary)
                                    Spacer()
                                    NavigationLink(value: item.id) {
                                        Text("继续观看")
                                            .font(Theme.captionFont(12))
                                            .foregroundStyle(.black)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Theme.gold)
                                            .clipShape(Capsule())
                                    }
                                }
                                Spacer()
                            }
                            .padding(10)
                            .background(Theme.bgCard)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                            .navigationDestination(for: String.self) { mediaId in
                                DramaDetailView(mediaId: mediaId)
                            }
                        }
                    }
                    .padding(Theme.hPad)
                }
            }
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle("观看历史")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 设置（mine_setting）

struct SettingsView: View {
    @EnvironmentObject private var session: SessionStore
    @AppStorage("h265Enabled") private var h265Enabled = true

    var body: some View {
        ScrollView {
            VStack(spacing: 1) {
                settingsRow(title: "账号与安全", icon: "person.badge.shield.checkmark")
                settingsRow(title: "播放设置", icon: "play.rectangle")
                settingsRow(title: "消息通知", icon: "bell")
                settingsRow(title: "清除缓存", icon: "trash")
                settingsRow(title: "在线客服", icon: "headphones")
                settingsRow(title: "关于我们", icon: "info.circle")
                settingsRow(title: "用户协议", icon: "doc.text")
                settingsRow(title: "隐私政策", icon: "hand.raised")
            }
            .background(Theme.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radius))

            Toggle("优先使用 H.265 片源", isOn: $h265Enabled)
                .font(Theme.bodyFont(14))
                .foregroundStyle(Theme.textPrimary)
                .padding(Theme.hPad)
                .background(Theme.bgCard)
                .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                .padding(.top, 12)
                .tint(Theme.gold)

            Text("DramaHub for iOS · v2.4.0（架构复刻自 lldj 2.4.0 分析）")
                .font(Theme.captionFont(11))
                .foregroundStyle(Theme.textTertiary)
                .padding(.top, 16)
        }
        .padding(Theme.hPad)
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func settingsRow(title: String, icon: String) -> some View {
        Button {} label: {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                    .foregroundStyle(Theme.textSecondary)
                Text(title)
                    .font(Theme.bodyFont(14))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(Theme.captionFont(11))
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(Theme.hPad)
        }
    }
}

// MARK: - 登录（mine/mobileLoginOnly + mine_setting/bind_phone_logic）

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var session: SessionStore
    @State private var phone = ""
    @State private var code = ""
    @State private var countdown = 0
    @State private var isLogging = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    // 真实品牌 logo（common/app_icon_lldj.png）
                    AssetLibrary.image(Theme.logo)
                        .map { $0.resizable().aspectRatio(contentMode: .fit) }
                        ?? Image(systemName: "tv.and.mediabox")
                            .font(.system(size: 44))
                            .foregroundStyle(Theme.gold)
                        .frame(width: 64, height: 64)
                    Text("登录")
                        .font(Theme.titleFont(22))
                        .foregroundStyle(Theme.textPrimary)
                    Text("未登录手机号将自动注册")
                        .font(Theme.captionFont(12))
                        .foregroundStyle(Theme.textTertiary)
                }
                .padding(.top, 40)

                VStack(spacing: 12) {
                    HStack {
                        Text("+86").foregroundStyle(Theme.textPrimary)
                        TextField(LLDJText.loginPhoneHint, text: $phone)
                            .keyboardType(.phonePad)
                            .foregroundStyle(Theme.textPrimary)
                    }
                    .padding()
                    .background(Theme.bgCard)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius))

                    HStack {
                        TextField("验证码", text: $code)
                            .keyboardType(.numberPad)
                            .foregroundStyle(Theme.textPrimary)
                        Spacer()
                        Button {
                            countdown = 60
                        } label: {
                            Text(countdown > 0 ? "\(countdown)s 后重发" : "获取验证码")
                                .font(Theme.captionFont(12))
                                .foregroundStyle(countdown > 0 ? Theme.textTertiary : Theme.gold)
                        }
                        .disabled(countdown > 0 || phone.isEmpty)
                    }
                    .padding()
                    .background(Theme.bgCard)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                }

                Button {
                    Task { await login() }
                } label: {
                    Text(isLogging ? "登录中…" : "登录 / 注册")
                        .font(Theme.titleFont(16))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.gold)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                }
                .disabled(phone.isEmpty || code.isEmpty || isLogging)

                HStack(spacing: 6) {
                    // 原版真实账号安全提示（提取自 libapp.so 字符串表）
                    Text(LLDJText.loginNotice)
                        .font(Theme.captionFont(10))
                        .foregroundStyle(Theme.textTertiary)
                        .multilineTextAlignment(.leading)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.gold.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                    Text("登录即代表同意")
                        .font(Theme.captionFont(11))
                        .foregroundStyle(Theme.textTertiary)
                    Text("用户协议与隐私政策")
                        .font(Theme.captionFont(11))
                        .foregroundStyle(Theme.gold)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(Theme.captionFont(12))
                        .foregroundStyle(Theme.live)
                }

                Spacer()
            }
            .padding(Theme.hPad)
            .background(Theme.bg.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("关闭") { dismiss() }.foregroundStyle(Theme.textSecondary)
                }
            }
        }
    }

    private func login() async {
        isLogging = true
        defer { isLogging = false }
        do {
            try await session.login(phone: phone, code: code)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - 通用占位页

struct PlaceholderPage: View {
    let title: String
    let icon: String
    let desc: String

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 44))
                .foregroundStyle(Theme.textTertiary)
            Text(title)
                .font(Theme.titleFont(16))
                .foregroundStyle(Theme.textSecondary)
            Text(desc)
                .font(Theme.captionFont(12))
                .foregroundStyle(Theme.textTertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

func placeholder(title: String, icon: String, desc: String) -> PlaceholderPage {
    PlaceholderPage(title: title, icon: icon, desc: desc)
}
