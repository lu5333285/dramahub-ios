import Foundation

/// 播放进度 / 历史记录本地存储（对应 tools_base/cache/history/* 与 drama_resume_store）
final class PlaybackStore {
    static let shared = PlaybackStore()
    private init() {}

    private let defaults = UserDefaults.standard
    private let resumeKey = "drama_resume"        // dramaId -> episodeId
    private let historyKey = "watch_history"
    private let searchKey = "search_history"

    // MARK: - 续播

    func saveResume(dramaId: String, episodeId: String) {
        var map = defaults.dictionary(forKey: resumeKey) as? [String: String] ?? [:]
        map[dramaId] = episodeId
        defaults.set(map, forKey: resumeKey)
    }

    func resumeEpisode(dramaId: String) -> String? {
        (defaults.dictionary(forKey: resumeKey) as? [String: String])?[dramaId]
    }

    // MARK: - 观看历史

    struct HistoryItem: Codable, Identifiable {
        let id: String
        var title: String?
        var cover: String?
        var watchedAt: Date
    }

    func addHistory(id: String, title: String?, cover: String?) {
        var list = history()
        list.removeAll { $0.id == id }
        list.insert(HistoryItem(id: id, title: title, cover: cover, watchedAt: Date()), at: 0)
        if list.count > 50 { list = Array(list.prefix(50)) }
        if let data = try? JSONEncoder().encode(list) {
            defaults.set(data, forKey: historyKey)
        }
    }

    func history() -> [HistoryItem] {
        guard let data = defaults.data(forKey: historyKey),
              let list = try? JSONDecoder().decode([HistoryItem].self, from: data) else { return [] }
        return list
    }

    // MARK: - 搜索历史（search_history_store）

    func addSearch(_ keyword: String) {
        guard !keyword.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        var list = searchHistory()
        list.removeAll { $0 == keyword }
        list.insert(keyword, at: 0)
        if list.count > 20 { list = Array(list.prefix(20)) }
        defaults.set(list, forKey: searchKey)
    }

    func searchHistory() -> [String] {
        defaults.stringArray(forKey: searchKey) ?? []
    }

    func clearSearchHistory() {
        defaults.removeObject(forKey: searchKey)
    }

    // MARK: - 缓存管理（对应 tools_base/cache/image_cache_manager.dart）

    /// 缓存根目录（对应 DioFileService / image_disk_cache 的 baseDir）
    static var cacheRoot: URL {
        let c = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return c.appendingPathComponent("lldj_cache", isDirectory: true)
    }

    /// 递归统计目录体积（字节）
    static func directorySize(_ url: URL) -> Int {
        guard let en = FileManager.default.enumerator(
            at: url, includingPropertiesForKeys: [.fileSizeKey]) else { return 0 }
        var total = 0
        for case let f as URL in en {
            let v = try? f.resourceValues(forKeys: [.fileSizeKey])
            total += v?.fileSize ?? 0
        }
        return total
    }

    static func readable(_ bytes: Int) -> String {
        let f = Double(bytes) / 1024.0
        if f < 1024 { return String(format: "%.1f KB", f) }
        if f < 1024 * 1024 { return String(format: "%.1f MB", f / 1024) }
        return String(format: "%.2f GB", f / 1024 / 1024)
    }

    /// 缓存概览文案
    var cacheSummary: String {
        let root = Self.cacheRoot
        let size = Self.directorySize(root)
        let exists = FileManager.default.fileExists(atPath: root.path)
        return """
        路径：\(root.path)
        状态：\(exists ? "已创建" : "尚未创建")
        占用：\(Self.readable(size))
        """
    }

    /// 清理缓存：清空缓存目录但保留根目录本身
    func clearCache() {
        let root = Self.cacheRoot
        let fm = FileManager.default
        if let items = try? fm.contentsOfDirectory(at: root, includingPropertiesForKeys: nil) {
            for i in items { try? fm.removeItem(at: i) }
        }
        // 同时清理系统 URL 缓存
        URLCache.shared.removeAllCachedResponses()
        defaults.removeObject(forKey: resumeKey)
    }
}
