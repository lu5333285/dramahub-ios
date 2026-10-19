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
}
