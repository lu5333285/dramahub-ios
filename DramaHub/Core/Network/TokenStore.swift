import Foundation
import Security

/// Token 存储（Keychain）。对应 jydj MMKV 的 _key_net_token / user_* 系列键
final class TokenStore {
    static let shared = TokenStore()
    private init() {}

    private let tokenKey = "net_token"
    private let userIdKey = "user_id"

    var token: String? {
        get { read(tokenKey) }
        set { write(tokenKey, newValue) }
    }

    var userId: String? {
        get { UserDefaults.standard.string(forKey: userIdKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: userIdKey) }
    }

    func clear() {
        token = nil
        userId = nil
    }

    // MARK: - Keychain

    private func write(_ key: String, _ value: String?) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.dramahub.app",
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
        guard let value, let data = value.data(using: .utf8) else { return }
        var item = query
        item[kSecValueData as String] = data
        SecItemAdd(item as CFDictionary, nil)
    }

    private func read(_ key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.dramahub.app",
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
