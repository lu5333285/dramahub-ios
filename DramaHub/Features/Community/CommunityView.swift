import SwiftUI

@MainActor
final class CommunityViewModel: ObservableObject {
    @Published var posts: [CommunityPost] = []
    @Published var isLoading = false

    private let service = CommunityService()

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do { posts = try await service.posts(page: 1) } catch { }
    }

    func toggleLike(_ post: CommunityPost) {
        guard let idx = posts.firstIndex(where: { $0.id == post.id }) else { return }
        posts[idx].liked.toggle()
        posts[idx].likeCount += posts[idx].liked ? 1 : -1
        Task { try? await service.likePost(postId: post.id, liked: posts[idx].liked) }
    }
}

struct CommunityView: View {
    @StateObject private var vm = CommunityViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(vm.posts) { post in
                    NavigationLink(value: post) {
                        PostCell(post: post, onLike: { vm.toggleLike(post) })
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Theme.hPad)
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle("社区")
        .navigationDestination(for: CommunityPost.self) { post in
            PostDetailView(postId: post.id)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink { PublishView() } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(Theme.textPrimary)
                }
            }
        }
        .task { if vm.posts.isEmpty { await vm.load() } }
    }
}

struct PostCell: View {
    let post: CommunityPost
    let onLike: () -> Void

    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 10) {
                // 作者
                HStack(spacing: 8) {
                    NetworkImage(post.author?.avatar)
                        .frame(width: 34, height: 34)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 4) {
                            Text(post.author?.nickname ?? "匿名用户")
                                .font(Theme.bodyFont(13))
                                .foregroundStyle(Theme.textPrimary)
                            if post.author?.isCreator == true {
                                Text("创作者")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(Theme.gold)
                                    .padding(.horizontal, 4)
                                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Theme.gold, lineWidth: 0.8))
                            }
                        }
                        Text(post.createdAt ?? "")
                            .font(Theme.captionFont(10))
                            .foregroundStyle(Theme.textTertiary)
                    }
                    Spacer()
                    Button {} label: {
                        Text("关注")
                            .font(Theme.captionFont(11))
                            .foregroundStyle(.black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Theme.gold)
                            .clipShape(Capsule())
                    }
                }

                if let content = post.content {
                    Text(content)
                        .font(Theme.bodyFont(14))
                        .foregroundStyle(Theme.textPrimary)
                        .lineLimit(4)
                }

                if !post.images.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(post.images.prefix(3), id: \.self) { img in
                            NetworkImage(img)
                                .frame(width: 100, height: 130)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }

                if post.videoUrl != nil {
                    ZStack {
                        Rectangle().fill(Theme.bgCardHi).frame(height: 180)
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                if !post.tags.isEmpty {
                    FlowLayout(spacing: 6) {
                        ForEach(post.tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(Theme.captionFont(11))
                                .foregroundStyle(Theme.gold)
                        }
                    }
                }

                // 互动栏
                HStack(spacing: 24) {
                    Button(action: onLike) {
                        HStack(spacing: 4) {
                            Image(systemName: post.liked ? "hand.thumbsup.fill" : "hand.thumbsup")
                            Text("\(post.likeCount)")
                        }
                        .foregroundStyle(post.liked ? Theme.gold : Theme.textTertiary)
                    }
                    .font(Theme.captionFont(12))

                    HStack(spacing: 4) {
                        Image(systemName: "bubble.right")
                        Text("\(post.commentCount)")
                    }
                    .font(Theme.captionFont(12))
                    .foregroundStyle(Theme.textTertiary)

                    Spacer()
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(Theme.textTertiary)
                }
            }
        }
    }
}

// MARK: - 帖子详情（post_detail_page）

@MainActor
final class PostDetailViewModel: ObservableObject {
    @Published var post: CommunityPost?
    @Published var comments: [CommentModel] = []
    @Published var input = ""

    private let service = CommunityService()

    func load(postId: String) async {
        post = MockData.posts.first { $0.id == postId }
        do { let res = try await service.comments(mediaId: postId, page: 1); comments = res.list } catch { }
    }

    func send() async {
        guard !input.isEmpty else { return }
        let new = CommentModel(id: UUID().uuidString, content: input,
                               user: .init(id: "me", nickname: "我", avatar: nil),
                               likeCount: 0, liked: false, createdAt: "刚刚", replyCount: 0, replies: [])
        comments.insert(new, at: 0)
        input = ""
    }
}

struct PostDetailView: View {
    let postId: String
    @StateObject private var vm = PostDetailViewModel()

    var body: some View {
        ScrollView {
            if let post = vm.post {
                PostCell(post: post, onLike: {})
                    .padding(Theme.hPad)
            }
            VStack(alignment: .leading, spacing: 14) {
                Text("评论 \(vm.comments.count)")
                    .font(Theme.titleFont(14))
                    .foregroundStyle(Theme.textPrimary)
                ForEach(vm.comments) { comment in
                    CommentCell(comment: comment)
                }
            }
            .padding(Theme.hPad)
        }
        .background(Theme.bg.ignoresSafeArea())
        .navigationTitle("动态详情")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 10) {
                TextField("说点什么…", text: $vm.input)
                    .font(Theme.bodyFont(13))
                    .padding(10)
                    .background(Theme.bgCard)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundStyle(Theme.textPrimary)
                Button { Task { await vm.send() } } label: {
                    Text("发送")
                        .font(Theme.bodyFont(13))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Theme.gold)
                        .clipShape(Capsule())
                }
                .disabled(vm.input.isEmpty)
            }
            .padding(Theme.hPad)
            .background(Theme.bg)
        }
        .task { await vm.load(postId: postId) }
    }
}

struct CommentCell: View {
    let comment: CommentModel

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(Theme.bgCardHi)
                .frame(width: 32, height: 32)
                .overlay(Text(String((comment.user?.nickname ?? "匿").prefix(1)))
                    .font(Theme.captionFont(12))
                    .foregroundStyle(Theme.textSecondary))
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(comment.user?.nickname ?? "匿名")
                        .font(Theme.captionFont(12))
                        .foregroundStyle(Theme.textTertiary)
                    Spacer()
                    Text(comment.createdAt ?? "")
                        .font(Theme.captionFont(10))
                        .foregroundStyle(Theme.textTertiary)
                }
                Text(comment.content ?? "")
                    .font(Theme.bodyFont(13))
                    .foregroundStyle(Theme.textPrimary)
                if comment.replyCount > 0 {
                    Text("查看 \(comment.replyCount) 条回复")
                        .font(Theme.captionFont(11))
                        .foregroundStyle(Theme.textTertiary)
                }
                ForEach(comment.replies) { reply in
                    HStack(alignment: .top, spacing: 6) {
                        Text("\(reply.user?.nickname ?? "")：")
                            .font(Theme.captionFont(11))
                            .foregroundStyle(Theme.textTertiary)
                        Text(reply.content ?? "")
                            .font(Theme.captionFont(11))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }
        }
    }
}

// MARK: - 发布（publish_page）

struct PublishView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var content = ""
    @State private var selectedTag: String? = nil
    let tags = ["追剧日常", "求剧", "混剪", "二创"]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                TextEditor(text: $content)
                    .frame(height: 140)
                    .padding(8)
                    .background(Theme.bgCard)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
                    .foregroundStyle(Theme.textPrimary)
                    .scrollContentBackground(.hidden)

                Text("选择话题")
                    .font(Theme.titleFont(14))
                    .foregroundStyle(Theme.textPrimary)
                FlowLayout(spacing: 8) {
                    ForEach(tags, id: \.self) { tag in
                        Button {
                            selectedTag = (selectedTag == tag) ? nil : tag
                        } label: {
                            Text("#\(tag)")
                                .font(Theme.captionFont(12))
                                .foregroundStyle(selectedTag == tag ? .black : Theme.textSecondary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(selectedTag == tag ? Theme.gold : Theme.bgCard)
                                .clipShape(Capsule())
                        }
                    }
                }

                HStack(spacing: 20) {
                    toolButton(icon: "photo", title: "图片")
                    toolButton(icon: "video", title: "视频")
                    toolButton(icon: "at", title: "话题")
                }
                Spacer()
            }
            .padding(Theme.hPad)
            .background(Theme.bg.ignoresSafeArea())
            .navigationTitle("发布动态")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { dismiss() }.foregroundStyle(Theme.textSecondary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("发布") { dismiss() }
                        .foregroundStyle(Theme.gold)
                        .disabled(content.isEmpty)
                }
            }
        }
    }

    private func toolButton(icon: String, title: String) -> some View {
        Button {} label: {
            VStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 20))
                Text(title).font(Theme.captionFont(11))
            }
            .foregroundStyle(Theme.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
        }
    }
}
