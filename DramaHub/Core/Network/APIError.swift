import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case transport(Error)
    case http(statusCode: Int)
    case decoding(Error)
    case business(code: Int, msg: String)
    case unauthorized
    case mockNotAvailable

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "无效的请求地址"
        case .transport(let e): return "网络异常：\(e.localizedDescription)"
        case .http(let code): return "服务器错误（HTTP \(code)）"
        case .decoding: return "数据解析失败"
        case .business(_, let msg): return msg
        case .unauthorized: return "登录已过期，请重新登录"
        case .mockNotAvailable: return "当前接口未提供演示数据"
        }
    }
}
