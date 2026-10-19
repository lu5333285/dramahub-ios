import SwiftUI

// 通用列表组件 —— 对应原 APK hj_page/widget/、tools_base/indicator/ 下的复用组件。
// 抽出来供 Mine / Community / Drama 各 Feature 共用，避免每处重复写。

// MARK: - 媒资行（对应 drama_list_page 的 list item）

struct MediaRow: View {
    let item: MediaContent
    var showLock: Bool = true

    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                NetworkImage(item.cover)
                    .frame(width: 92, height: 122)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                if showLock, item.isVipOnly == true {
                    AssetIcon(asset: LLDJAsset.common_common_vip_bg,
                              size: 16, tint: Theme.gold)
                        .frame(width: 22, height: 22)
                        .background(.ultraThinMaterial, in: Circle())
                        .padding(4)
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title ?? "")
                    .font(Theme.bodyFont(15))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(2)
                if let ep = item.episodeCount, ep > 0 {
                    Text("共 \(ep) 集")
                        .font(Theme.captionFont(11))
                        .foregroundStyle(Theme.gold)
                }
                if let sc = item.score, sc > 0 {
                    HStack(spacing: 3) {
                        Text(String(format: "%.1f", sc))
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundStyle(Theme.brand)
                        if let a = item.author?.nickname {
                            Text("· \(a)")
                                .font(Theme.captionFont(11))
                                .foregroundStyle(Theme.textTertiary)
                                .lineLimit(1)
                        }
                    }
                }
                if let tags = item.tags, !tags.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(tags.prefix(2), id: \.self) { t in
                            Text(t)
                                .font(.system(size: 10))
                                .foregroundStyle(Theme.textSecondary)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Theme.bgCardHi, in: Capsule())
                        }
                    }
                }
                Spacer()
                HStack(spacing: 10) {
                    if let p = item.playCount, p > 0 {
                        Label("\(p)", systemImage: "play.circle")
                            .font(Theme.captionFont(10))
                            .foregroundStyle(Theme.textTertiary)
                    }
                    if let c = item.coinPrice, c > 0 {
                        HStack(spacing: 3) {
                            AssetIcon(asset: LLDJAsset.common_coin, size: 11, tint: Theme.gold)
                            Text("\(c)")
                                .font(Theme.captionFont(10))
                                .foregroundStyle(Theme.gold)
                        }
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .padding(10)
        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
    }
}

// MARK: - 社区帖子卡片（对应 community/post_detail_page 与 community_tab 的 cell）

struct CommunityPostCell: View {
    let post: CommunityPost
    var onTap: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                NetworkImage(post.author?.avatar).frame(width: 28, height: 28)
                    .clipShape(Circle())
                Text(post.author?.nickname ?? "匿名")
                    .font(Theme.captionFont(12))
                    .foregroundStyle(Theme.textSecondary)
                if post.author?.isCreator == true {
                    Text("创作者")
                        .font(.system(size: 9))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 5).padding(.vertical, 2)
                        .background(Theme.gold, in: Capsule())
                }
                Spacer()
                Text(post.createdAt ?? "")
                    .font(Theme.captionFont(10))
                    .foregroundStyle(Theme.textTertiary)
            }

            Text(post.content ?? "")
                .font(Theme.bodyFont(14))
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(3)

            if post.videoUrl != nil {
                NetworkImage(post.images.first)
                    .frame(height: 170)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(.white.opacity(0.85))
                    )
            } else if !post.images.isEmpty {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 3),
                          spacing: 4) {
                    ForEach(Array(post.images.prefix(3).enumerated()), id: \.offset) { _, u in
                        NetworkImage(u)
                            .frame(height: 92)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
            }

            HStack(spacing: 16) {
                meta("hand.thumbsup", post.likeCount)
                meta("bubble.left", post.commentCount)
                Spacer()
                AssetIcon(asset: LLDJAsset.community_link_copy_icon, size: 14, tint: Theme.textTertiary)
            }
        }
        .padding(12)
        .background(Theme.bgCard, in: RoundedRectangle(cornerRadius: Theme.radius))
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
    }

    private func meta(_ icon: String, _ n: Int) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 11))
            Text("\(n)").font(Theme.captionFont(11))
        }
        .foregroundStyle(post.liked ? Theme.brand : Theme.textTertiary)
    }
}

// MARK: - 社区用户（对应 /follow/list、/friend/list 的返回项）

struct CommunityUser: Decodable, Identifiable, Hashable {
    let id: String
    var nickname: String?
    var avatar: String?
    var signature: String?
    var followed: Bool = false

    enum CodingKeys: String, CodingKey {
        case id = "userId", nickname, avatar, signature, followed
    }

    init(id: String, nickname: String? = nil, avatar: String? = nil,
         signature: String? = nil, followed: Bool = false) {
        self.id = id
        self.nickname = nickname
        self.avatar = avatar
        self.signature = signature
        self.followed = followed
    }
}

// MARK: - 银行卡（对应 /mine/txnact/yh/get）

struct BankCardModel: Decodable, Identifiable, Hashable {
    let id: String
    var bankName: String?
    var cardNo: String?
    var realName: String?
    var isDefault: Bool = false

    enum CodingKeys: String, CodingKey {
        case id = "bankId", bankName, cardNo, realName, isDefault
    }

    init(id: String, bankName: String? = nil, cardNo: String? = nil,
         realName: String? = nil, isDefault: Bool = false) {
        self.id = id
        self.bankName = bankName
        self.cardNo = cardNo
        self.realName = realName
        self.isDefault = isDefault
    }
}

// MARK: - 空态（统一替代散落的占位实现）

struct LLDJEmpty: View {
    let icon: String
    let title: String
    var desc: String = ""

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundStyle(Theme.textTertiary)
            Text(title)
                .font(Theme.titleFont(15))
                .foregroundStyle(Theme.textSecondary)
            if !desc.isEmpty {
                Text(desc)
                    .font(Theme.captionFont(11))
                    .foregroundStyle(Theme.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
}