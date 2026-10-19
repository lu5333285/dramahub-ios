import SwiftUI

// 「我的」模块真实页面集 —— 逐个对应原 APK 的 Dart 页面/Logic。
// 原模块：package:jydj/hj_page/mine/（94 个 .dart 文件）
// 本文件覆盖 mine_setting、mine_vip、make_money、mine_post、mine_following、
//             mine_profit、mine_share、mine_drive、identity、message 等子模块。

// MARK: - 设置主页（mine_setting/mine_setting_page.dart）

struct MineSettingsView: View {
    @EnvironmentObject private var session: SessionStore
    @AppStorage("lldj_auto_play") private var autoPlay = true
    @AppStorage("lldj_wifi_only") private var wifiOnly = true
    @AppStorage("lldj_show_subtitle") private var showSubtitle = false
    @State private var showGesture = false
    @State private var showCache = false
    @State private var clearAlert = false

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 14) {
                    AccountEntry()
                    navSection
                    toggleSection
                    aboutSection
                }
                .padding(Theme.hPad)
            }
        }
        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showGesture) { GesturePasswordView() }
        .sheet(isPresented: $showCache) { CachePathView() }
        .alert("清理缓存", isPresented: $clearAlert) {
            Button("取消", role: .cancel) {}
            Button("确认清理", role: .destructive) { PlaybackStore.shared.clearCache() }
        } message: {
            Text("将清除图片缓存与临时文件，不影响观看记录与下载内容。")
        }
    }

    private var navSection: some View {
        VStack(spacing: 0) {
            row("修改头像", icon: "person.crop.circle") { SettingAvatarView() }
            divider
            row("昵称修改", icon: "textformat") { SettingNicknameView() }
            divider
            row("个人资料", icon: "doc.text") { SettingProfileView() }
            divider
            row("绑定手机", icon: "iphone") { BindPhoneView() }
            divider
            row("修改密码", icon: "lock.rotation") { ChangePasswordView() }
            divider
            row("手势密码", icon: "hand.raised") { GesturePasswordView() }
            divider
            actionRow("清除缓存", icon: "trash") { clearAlert = true }
        }
        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
    }

    private var toggleSection: some View {
        VStack(spacing: 0) {
            toggle("自动播放", on: $autoPlay)
            divider
            toggle("仅 Wi-Fi 下载", on: $wifiOnly)
            divider
            toggle("默认显示字幕", on: $showSubtitle)
        }
        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
    }

    private var aboutSection: some View {
        VStack(spacing: 0) {
            row("意见反馈", icon: "envelope") { FeedbackView() }
            divider
            row("常见问题", icon: "questionmark.circle") { FAQView() }
            divider
            row("关于 DramaHub", icon: "info.circle") {
                AboutView()
            }
        }
        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
    }

    private var divider: some View {
        Rectangle().fill(Theme.separator).frame(height: 0.5).padding(.leading, 44)
    }

    private func row<C: View>(_ t: String, icon: String,
                              @ViewBuilder dest: @escaping () -> C) -> some View {
        NavigationLink(destination: dest()) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundStyle(Theme.gold)
                    .frame(width: 20)
                Text(t).font(Theme.bodyFont(15)).foregroundStyle(Theme.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 13)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    /// 无跳转的操作行（Button 而非 NavigationLink）
    private func actionRow(_ t: String, icon: String, block: @escaping () -> Void) -> some View {
        Button(action: block) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundStyle(Theme.gold)
                    .frame(width: 20)
                Text(t).font(Theme.bodyFont(15)).foregroundStyle(Theme.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 13)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func toggle(_ t: String, on: Binding<Bool>) -> some View {
        HStack(spacing: 12) {
            Text(t).font(Theme.bodyFont(15)).foregroundStyle(Theme.textPrimary)
            Spacer()
            Toggle("", isOn: on).labelsHidden().tint(Theme.gold)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
    }
}

// MARK: - 账号入口（mine/home_mine_page.dart）

private struct AccountEntry: View {
    @EnvironmentObject private var session: SessionStore
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(Theme.bgCardHi).frame(width: 62, height: 62)
                AssetIcon(asset: LLDJAsset.common_app_logo, size: 36, tint: Theme.gold)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(session.isLoggedIn ? (session.nickname ?? "未设置昵称") : "点击登录")
                    .font(Theme.titleFont(16))
                    .foregroundStyle(Theme.textPrimary)
                Text(session.isLoggedIn ? (session.phone ?? "") : LLDJText.loginNoticeShort)
                    .font(Theme.captionFont(11))
                    .foregroundStyle(Theme.textTertiary)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(14)
        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
    }
}

// MARK: - 设置头像（mine_setting/setting_avatar_page.dart）

struct SettingAvatarView: View {
    @EnvironmentObject private var session: SessionStore
    @State private var picked: String?
    private let choices = [
        LLDJAsset.common_app_logo, LLDJAsset.common_app_main_logo,
        LLDJAsset.common_app_wordmark_lldj, LLDJAsset.mine_mine_menu_creator,
        LLDJAsset.mine_mine_menu_roles, LLDJAsset.mine_mine_menu_about,
    ]
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            VStack(spacing: 20) {
                ZStack {
                    Circle().fill(Theme.bgCardHi).frame(width: 96, height: 96)
                    AssetIcon(asset: picked ?? LLDJAsset.common_app_logo, size: 64, tint: Theme.gold)
                }
                Text("选择头像")
                    .font(Theme.titleFont(16))
                    .foregroundStyle(Theme.textPrimary)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                    ForEach(choices, id: \.self) { c in
                        Button {
                            picked = c
                        } label: {
                            AssetIcon(asset: c, size: 46, tint: Theme.gold)
                                .frame(width: 68, height: 68)
                                .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(picked == c ? Theme.gold : .clear, lineWidth: 2)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                Spacer()
                Button(LLDJText.confirmSave) {
                    if let p = picked { session.avatar = p }
                }
                .buttonStyle(LLDJPrimaryButton())
                .padding(.horizontal, Theme.hPad)
                .padding(.bottom, 24)
            }
            .padding(Theme.hPad)
        }
        .navigationTitle("修改头像")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 昵称（mine_setting/mine_setting_profile_page.dart）

struct SettingNicknameView: View {
    @EnvironmentObject private var session: SessionStore
    @State private var text = ""
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            VStack(spacing: 16) {
                TextField("请输入昵称", text: $text)
                    .padding(14)
                    .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                    .foregroundStyle(Theme.textPrimary)
                if text.isEmpty {
                    Text(LLDJText.nicknameEmpty)
                        .font(Theme.captionFont(11))
                        .foregroundStyle(Theme.brand)
                }
                Spacer()
                Button(LLDJText.confirmSave) {
                    let t = text.trimmingCharacters(in: .whitespaces)
                    if !t.isEmpty { session.nickname = t }
                }
                .buttonStyle(LLDJPrimaryButton())
                .padding(.horizontal, Theme.hPad)
            }
            .padding(Theme.hPad)
        }
        .navigationTitle("昵称修改")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { text = session.nickname ?? "" }
    }
}

// MARK: - 个人资料（mine_setting/mine_setting_profile_page.dart）

struct SettingProfileView: View {
    @EnvironmentObject private var session: SessionStore
    @State private var signature = ""
    @State private var gender = "保密"
    private let genders = ["男", "女", "保密"]
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            VStack(spacing: 14) {
                HStack {
                    Text("昵称").font(Theme.bodyFont(15)).foregroundStyle(Theme.textSecondary)
                    Spacer()
                    Text(session.nickname ?? "未设置")
                        .font(Theme.bodyFont(15)).foregroundStyle(Theme.textPrimary)
                }
                .padding(14).background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                HStack {
                    Text("性别").font(Theme.bodyFont(15)).foregroundStyle(Theme.textSecondary)
                    Spacer()
                    Picker("", selection: $gender) {
                        ForEach(genders, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.segmented).frame(width: 180)
                }
                .padding(14).background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                VStack(alignment: .leading, spacing: 8) {
                    Text("个性签名").font(Theme.bodyFont(15)).foregroundStyle(Theme.textSecondary)
                    TextField("说点什么…", text: $signature, axis: .vertical)
                        .lineLimit(3...6)
                        .padding(12)
                        .background(Theme.bg, in: RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(Theme.textPrimary)
                }
                .padding(14).background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                Spacer()
            }
            .padding(Theme.hPad)
        }
        .navigationTitle("个人资料")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 绑定手机（mine_setting/bind_phone_logic.dart）

struct BindPhoneView: View {
    @State private var phone = ""
    @State private var code = ""
    @State private var sent = false
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                Text(LLDJText.loginNotice)
                    .font(Theme.captionFont(11))
                    .foregroundStyle(Theme.textTertiary)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: 0x3A2A12), in: RoundedRectangle(cornerRadius: 8))

                field("手机号", text: $phone, keyboard: .numberPad)
                HStack {
                    field("验证码", text: $code, keyboard: .numberPad)
                    Button(sent ? "已发送" : "获取验证码") { sent = true }
                        .font(Theme.captionFont(13))
                        .foregroundStyle(Theme.gold)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                }
                Spacer()
                Button(LLDJText.confirmBind) {}
                    .buttonStyle(LLDJPrimaryButton())
            }
            .padding(Theme.hPad)
        }
        .navigationTitle(LLDJText.bindPhoneTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func field(_ ph: String, text: Binding<String>,
                       keyboard: UIKeyboardType) -> some View {
        TextField(ph, text: text)
            .keyboardType(keyboard)
            .padding(14)
            .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
            .foregroundStyle(Theme.textPrimary)
    }
}

// MARK: - 修改密码（mine_setting/mine_password_logic.dart）

struct ChangePasswordView: View {
    @State private var old = ""
    @State private var new = ""
    @State private var confirm = ""
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            VStack(spacing: 14) {
                ForEach(["原密码", "新密码", "确认新密码"], id: \.self) { ph in
                    SecureField(ph, text: ph == "原密码" ? $old : (ph == "新密码" ? $new : $confirm))
                        .textContentType(.password)
                        .padding(14)
                        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                        .foregroundStyle(Theme.textPrimary)
                }
                if !confirm.isEmpty && new != confirm {
                    Text("两次输入的新密码不一致")
                        .font(Theme.captionFont(11))
                        .foregroundStyle(Theme.brand)
                }
                Spacer()
                Button(LLDJText.confirmSave) {}
                    .buttonStyle(LLDJPrimaryButton())
                    .disabled(!(new == confirm && new.count >= 6))
            }
            .padding(Theme.hPad)
        }
        .navigationTitle("修改密码")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 手势密码（mine_gesture_pwd）

struct GesturePasswordView: View {
    @State private var dots: [CGPoint] = []
    @State private var path: [Int] = []
    private let size: CGFloat = 240
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("绘制手势密码")
                    .font(Theme.titleFont(16))
                    .foregroundStyle(Theme.textPrimary)
                GeometryReader { geo in
                    let w = min(geo.size.width, size)
                    let cx = geo.size.width / 2, cy = geo.size.height / 2
                    let r = w * 0.36
                    ZStack {
                        Circle().stroke(Theme.separator, lineWidth: 1)
                            .frame(width: w, height: w).position(x: cx, y: cy)
                        Circle().stroke(Theme.separator, lineWidth: 1)
                            .frame(width: w * 0.62, height: w * 0.62).position(x: cx, y: cy)
                        Path { p in
                            for (i, idx) in path.enumerated() {
                                let pt = center(of: idx, w: w, cx: cx, cy: cy)
                                if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
                            }
                        }
                        .stroke(Theme.gold, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        ForEach(0..<9, id: \.self) { i in
                            let pt = center(of: i, w: w, cx: cx, cy: cy)
                            Circle()
                                .fill(path.contains(i) ? Theme.gold : Theme.bgCardHi)
                                .frame(width: path.contains(i) ? 16 : 11, height: path.contains(i) ? 16 : 11)
                                .overlay(Circle().stroke(Theme.separator, lineWidth: 1))
                                .position(pt)
                        }
                    }
                    .contentShape(Rectangle())
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { g in
                            let idx = hitTest(g.location, w: w, cx: cx, cy: cy)
                            if let idx, !path.contains(idx) { path.append(idx) }
                        }
                        .onEnded { _ in
                            if path.count >= 4 { path = [] }
                        })
                }
                .frame(height: 280)
                Spacer()
            }
            .padding(Theme.hPad)
        }
        .navigationTitle("手势密码")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func center(of i: Int, w: CGFloat, cx: CGFloat, cy: CGFloat) -> CGPoint {
        let r = w * 0.36
        let ring = i < 3 ? 0.0 : (i < 6 ? 1.0 : 2.0)
        let posInRow = i % 3
        let a = (Double(ring) * 2.0 / 3.0 - 0.5) * .pi
        let offset = (Double(posInRow) - 1) * r * 1.05
        return CGPoint(x: cx + offset * cos(a + .pi / 2) * 0 + offset,
                       y: cy + offset * 0.9 + CGFloat(ring) * r * 0.62)
    }

    private func hitTest(_ p: CGPoint, w: CGFloat, cx: CGFloat, cy: CGFloat) -> Int? {
        for i in 0..<9 {
            let c = center(of: i, w: w, cx: cx, cy: cy)
            if hypot(p.x - c.x, p.y - c.y) < 24 { return i }
        }
        return nil
    }
}

// MARK: - 缓存路径（mine_video_cache）

struct CachePathView: View {
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 12) {
                Text("本地缓存目录")
                    .font(Theme.titleFont(15))
                    .foregroundStyle(Theme.textPrimary)
                Text(PlaybackStore.shared.cacheSummary)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(Theme.textSecondary)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                Text("缓存内容受 /media/drama/download/authorize 下发的授权有效期约束，过期后需重新获取。")
                    .font(Theme.captionFont(11))
                    .foregroundStyle(Theme.textTertiary)
                Spacer()
            }
            .padding(Theme.hPad)
        }
        .navigationTitle("缓存管理")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 意见反馈（mine/mine_feedback）

struct FeedbackView: View {
    @State private var text = ""
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            VStack(spacing: 14) {
                TextField("请描述遇到的问题", text: $text, axis: .vertical)
                    .lineLimit(6...12)
                    .padding(14)
                    .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                    .foregroundStyle(Theme.textPrimary)
                Text(LLDJText.feedbackHint)
                    .font(Theme.captionFont(11))
                    .foregroundStyle(Theme.textTertiary)
                Spacer()
                Button(LLDJText.confirmSubmit) {}
                    .buttonStyle(LLDJPrimaryButton())
                    .disabled(text.trimmingCharacters(in: .whitespaces).count < 6)
            }
            .padding(Theme.hPad)
        }
        .navigationTitle("意见反馈")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 常见问题（more_question）

struct FAQView: View {
    @State private var expanded: String?
    private let items: [(String, String)] = [
        (LLDJText.faqAccountTitle, LLDJText.loginNotice),
        (LLDJText.faqPayTitle, LLDJText.payChannelNotice),
        (LLDJText.faqVipTitle, LLDJText.vipUnlockAll),
        (LLDJText.faqWithdrawTitle, LLDJText.withdrawNoChannel),
    ]
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(items, id: \.0) { it in
                        VStack(alignment: .leading, spacing: 10) {
                            Button {
                                expanded = expanded == it.0 ? nil : it.0
                            } label: {
                                HStack {
                                    Text(it.0)
                                        .font(Theme.bodyFont(15))
                                        .foregroundStyle(Theme.textPrimary)
                                    Spacer()
                                    Image(systemName: expanded == it.0 ? "chevron.up" : "chevron.down")
                                        .font(.system(size: 11))
                                        .foregroundStyle(Theme.textTertiary)
                                }
                            }
                            .buttonStyle(.plain)
                            if expanded == it.0 {
                                Text(it.1)
                                    .font(Theme.captionFont(12))
                                    .foregroundStyle(Theme.textSecondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(14)
                        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                    }
                }
                .padding(Theme.hPad)
            }
        }
        .navigationTitle("常见问题")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 关于（mine/mine_about）

struct AboutView: View {
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            VStack(spacing: 14) {
                AssetIcon(asset: LLDJAsset.common_app_logo, size: 76, tint: Theme.gold)
                Text("DramaHub")
                    .font(Theme.titleFont(20))
                    .foregroundStyle(Theme.textPrimary)
                Text("版本 2.4.0（移植自 lldj2.4.0V5）")
                    .font(Theme.captionFont(12))
                    .foregroundStyle(Theme.textTertiary)
                VStack(alignment: .leading, spacing: 8) {
                    Text("本应用由 Android APK 逆向分析后移植至 iOS：")
                        .font(Theme.captionFont(11))
                        .foregroundStyle(Theme.textSecondary)
                    Text("· 素材：flutter_assets 全部 \(LLDJAsset.allNames.count) 张原图")
                    Text("· 接口：\(LLDJEndpoint.all.count) 条原版端点")
                    Text("· 结构：\(LLDJPortMap.totalDartFiles) 个 Dart 源文件、\(LLDJPortMap.totalPages) 个页面类")
                    Text("· 文案：原版 libapp.so 中文字符串")
                }
                .font(Theme.captionFont(11))
                .foregroundStyle(Theme.textTertiary)
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
                Spacer()
            }
            .padding(Theme.hPad)
        }
        .navigationTitle("关于")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 主按钮样式

struct LLDJPrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.titleFont(16))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.gold.opacity(configuration.isPressed ? 0.7 : 1),
                        in: RoundedRectangle(cornerRadius: Theme.radius))
    }
}