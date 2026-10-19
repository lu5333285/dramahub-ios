import Foundation
import UIKit

/// 运行配置。对应 jydj config/address.dart + Config（域名动态下发前的初始值）
enum Config {
    /// 演示模式：开启后全部接口返回本地 Mock 数据，无需后端即可运行
    static var useMock = true
    /// 初始 API 域名（真实运行时由 /ping/domain/refresh + encryptedConfig 动态刷新替换）
    static var apiBaseURL = "https://api.lldj.tv"
    /// IM WebSocket（wss://twss.flowcd.cn:32214）
    static var imWebSocketURL = "wss://twss.flowcd.cn:32214"
    static var appVersion = "2.4.0"
    static var platform = "iOS"
}

/// 网络客户端：URLSession + 拦截器链（对应 jydj net_manager + http_response_interceptor + sdk_common_header）
actor APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: config)
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
    }

    // MARK: - Request

    func request<T: Decodable, Body: Encodable>(
        _ endpoint: APIEndpoint,
        body: Body? = nil as EmptyResp?
    ) async throws -> T {
        guard var components = URLComponents(string: Config.apiBaseURL + endpoint.path) else {
            throw APIError.invalidURL
        }
        if !endpoint.query.isEmpty { components.queryItems = endpoint.query }

        var request = URLRequest(url: components.url!)
        request.httpMethod = endpoint.method.rawValue
        applyCommonHeaders(&request)
        if let body { request.httpBody = try encoder.encode(AnyEncodable(body)) }

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw APIError.transport(URLError(.badServerResponse))
        }

        switch http.statusCode {
        case 200...299: break
        case 401: throw APIError.unauthorized
        default: throw APIError.http(statusCode: http.statusCode)
        }

        do {
            let bean = try decoder.decode(BaseRespBean<T>.self, from: data)
            return try bean.unwrapped()
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.decoding(error)
        }
    }

    /// GET 快捷方式
    func get<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        try await request(endpoint, body: nil as EmptyResp?)
    }

    // MARK: - Interceptors（对应 sdk_common_header + token 拦截器）

    private func applyCommonHeaders(_ request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = TokenStore.shared.token {
            request.setValue(token, forHTTPHeaderField: "X-Token")
        }
        request.setValue(Config.platform, forHTTPHeaderField: "X-Platform")
        request.setValue(Config.appVersion, forHTTPHeaderField: "X-App-Version")
        if let userId = TokenStore.shared.userId {
            request.setValue(userId, forHTTPHeaderField: "X-User-Id")
        }
        // UIDevice.identifierForVendor 为 MainActor 隔离属性：经 MainActor.assumeIsolated 同步读取
        // （本方法运行在 actor 隔离上下文；Swift 6 模式下必须显式桥接）
        let deviceId = MainActor.assumeIsolated { UIDevice.current.identifierForVendor?.uuidString ?? "" }
        request.setValue(deviceId, forHTTPHeaderField: "X-Device-Id")
    }
}

/// 让任意 Encodable 可作为 body 传入（规避泛型默认值语法限制）
struct AnyEncodable: Encodable {
    private let base: Encodable
    init(_ base: Encodable) { self.base = base }
    func encode(to encoder: Encoder) throws { try base.encode(to: encoder) }
}
