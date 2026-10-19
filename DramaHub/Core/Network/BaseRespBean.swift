import Foundation

/// 统一响应包，对应 jydj tools_base/net/base_resp_bean.dart 的 BaseRespBean
/// 约定：{ code: Int, msg: String, data: T }
struct BaseRespBean<T: Decodable>: Decodable {
    let code: Int
    let msg: String?
    let data: T?

    var isSuccess: Bool { code == 0 || code == 200 }

    func unwrapped() throws -> T {
        guard isSuccess, let data else { throw APIError.business(code: code, msg: msg ?? "请求失败") }
        return data
    }
}

/// 空 data 响应
struct EmptyResp: Decodable {}
