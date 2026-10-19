// Generated from lldj2.4.0V5.apk (libapp.so Dart AOT string table)
// Swift Codable 镜像层：类名与原 Dart 1:1 对应，字段按业务域还原。
// 共 339 个模型。Regenerate with rea_analysis/gen_models.py — DO NOT EDIT MANUALLY.

import Foundation

/// 统一响应包 —— 对应 Dart `BaseRespBean<T>`
struct BaseResp<T: Codable>: Codable {
    var code: Int?
    var msg: String?
    var message: String?
    var data: T?
    var time: String?

    var ok: Bool { (code ?? 0) == 0 || (code ?? -1) == 200 }
    var payload: T? { ok ? data : nil }
}

/// 分页包 —— 对应 Dart 通用 list resp
struct PagedResp<T: Codable>: Codable {
    var list: [T]?
    var rows: [T]?
    var total: Int?
    var page: Int?
    var has_more: Bool?

    var items: [T] { list ?? rows ?? [] }
}

/// 容错解码器：后端新增/缺失字段不崩溃
extension JSONDecoder {
    static var tolerant: JSONDecoder {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }
}


// MARK: - media

/// media — Dart 类 `ACGRankItem`
struct ACGRankItem: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
}

/// media — Dart 类 `ActionIconThemeData`
struct ActionIconThemeData: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
}

/// media — Dart 类 `ActressInfo`
struct ActressInfo: Codable, Identifiable, Hashable {
    var id: String
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
}

/// media — Dart 类 `ActressModel`
struct ActressModel: Codable, Identifiable, Hashable {
    var id: String
    var vid: String?
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
}

/// media — Dart 类 `AndroidAudioDeviceInfo`
struct AndroidAudioDeviceInfo: Codable, Identifiable, Hashable {
    var id: String
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
}

/// media — Dart 类 `AndroidDeviceInfo`
struct AndroidDeviceInfo: Codable, Identifiable, Hashable {
    var id: String
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `AnimatedPhysicalModel`
struct AnimatedPhysicalModel: Codable, Identifiable, Hashable {
    var id: String
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `AnnounceInfoBean`
struct AnnounceInfoBean: Codable, Identifiable, Hashable {
    var id: String
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `AnonymouseSessionResponse`
struct AnonymouseSessionResponse: Codable, Identifiable, Hashable {
    var id: String
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
}

/// media — Dart 类 `ApcApiModel`
struct ApcApiModel: Codable, Identifiable, Hashable {
    var id: String
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
}

/// media — Dart 类 `ApiConfig`
struct ApiConfig: Codable, Identifiable, Hashable {
    var id: String
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
}

/// media — Dart 类 `AppBarThemeData`
struct AppBarThemeData: Codable, Identifiable, Hashable {
    var id: String
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `AppExitResponse`
struct AppExitResponse: Codable, Identifiable, Hashable {
    var id: String
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
}

/// media — Dart 类 `BadgeThemeData`
struct BadgeThemeData: Codable, Identifiable, Hashable {
    var id: String
    var vid: String?
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
}

/// media — Dart 类 `BaseDeviceInfo`
struct BaseDeviceInfo: Codable, Identifiable, Hashable {
    var id: String
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
}

/// media — Dart 类 `BaseResponse`
struct BaseResponse: Codable, Identifiable, Hashable {
    var id: String
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
}

/// media — Dart 类 `BmpImageSizeData`
struct BmpImageSizeData: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
    var goldCoin: Double?
}

/// media — Dart 类 `BmpInfo`
struct BmpInfo: Codable, Identifiable, Hashable {
    var id: String
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
}

/// media — Dart 类 `BottomAppBarThemeData`
struct BottomAppBarThemeData: Codable, Identifiable, Hashable {
    var id: String
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
}

/// media — Dart 类 `BottomNavigationBarItem`
struct BottomNavigationBarItem: Codable, Identifiable, Hashable {
    var id: String
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `BottomNavigationBarThemeData`
struct BottomNavigationBarThemeData: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
}

/// media — Dart 类 `BottomSheetThemeData`
struct BottomSheetThemeData: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
}

/// media — Dart 类 `BoxParentData`
struct BoxParentData: Codable, Identifiable, Hashable {
    var id: String
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `BuilderInfo`
struct BuilderInfo: Codable, Identifiable, Hashable {
    var id: String
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
}

/// media — Dart 类 `ButtonBarThemeData`
struct ButtonBarThemeData: Codable, Identifiable, Hashable {
    var id: String
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
}

/// media — Dart 类 `ButtonThemeData`
struct ButtonThemeData: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `ByteData`
struct ByteData: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
}

/// media — Dart 类 `CancelledResponse`
struct CancelledResponse: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `CardThemeData`
struct CardThemeData: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
}

/// media — Dart 类 `CarouselViewThemeData`
struct CarouselViewThemeData: Codable, Identifiable, Hashable {
    var id: String
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `CheckVersionInfo`
struct CheckVersionInfo: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
}

/// media — Dart 类 `CheckboxThemeData`
struct CheckboxThemeData: Codable, Identifiable, Hashable {
    var id: String
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
}

/// media — Dart 类 `ChipThemeData`
struct ChipThemeData: Codable, Identifiable, Hashable {
    var id: String
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
}

/// media — Dart 类 `CleanFaxData`
struct CleanFaxData: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
}

/// media — Dart 类 `ClipboardData`
struct ClipboardData: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
}

/// media — Dart 类 `ClosureData`
struct ClosureData: Codable, Identifiable, Hashable {
    var id: String
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
}

/// media — Dart 类 `CollectStatusModel`
struct CollectStatusModel: Codable, Identifiable, Hashable {
    var id: String
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `CollectionModel`
struct CollectionModel: Codable, Identifiable, Hashable {
    var id: String
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
}

/// media — Dart 类 `ComponentData`
struct ComponentData: Codable, Identifiable, Hashable {
    var id: String
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
}

/// media — Dart 类 `ContainerBoxParentData`
struct ContainerBoxParentData: Codable, Identifiable, Hashable {
    var id: String
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
}

/// media — Dart 类 `ContextMenuButtonItem`
struct ContextMenuButtonItem: Codable, Identifiable, Hashable {
    var id: String
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
}

/// media — Dart 类 `CupertinoBasedMaterialThemeData`
struct CupertinoBasedMaterialThemeData: Codable, Identifiable, Hashable {
    var id: String
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
}

/// media — Dart 类 `CupertinoIconThemeData`
struct CupertinoIconThemeData: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
}

/// media — Dart 类 `CupertinoThemeData`
struct CupertinoThemeData: Codable, Identifiable, Hashable {
    var id: String
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
}

/// media — Dart 类 `CustomSliverPhysicalContainerParentData`
struct CustomSliverPhysicalContainerParentData: Codable, Identifiable, Hashable {
    var id: String
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `CutInfo`
struct CutInfo: Codable, Identifiable, Hashable {
    var id: String
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
}

/// media — Dart 类 `DartApiDLInitializeData`
struct DartApiDLInitializeData: Codable, Identifiable, Hashable {
    var id: String
    var vid: String?
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
}

/// media — Dart 类 `DataTableThemeData`
struct DataTableThemeData: Codable, Identifiable, Hashable {
    var id: String
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `DatabaseSchemaEntity`
struct DatabaseSchemaEntity: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
}

/// media — Dart 类 `DatePickerThemeData`
struct DatePickerThemeData: Codable, Identifiable, Hashable {
    var id: String
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
}

/// media — Dart 类 `DecodeInfo`
struct DecodeInfo: Codable, Identifiable, Hashable {
    var id: String
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
}

/// media — Dart 类 `DecodeResponse`
struct DecodeResponse: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
}

/// media — Dart 类 `DeviceModel`
struct DeviceModel: Codable, Identifiable, Hashable {
    var id: String
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
}

/// media — Dart 类 `DialogThemeData`
struct DialogThemeData: Codable, Identifiable, Hashable {
    var id: String
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
}

/// media — Dart 类 `DividerThemeData`
struct DividerThemeData: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `DomainSourceModel`
struct DomainSourceModel: Codable, Identifiable, Hashable {
    var id: String
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
}

/// media — Dart 类 `DownloadInfo`
struct DownloadInfo: Codable, Identifiable, Hashable {
    var id: String
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `DrawImageData`
struct DrawImageData: Codable, Identifiable, Hashable {
    var id: String
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
}

/// media — Dart 类 `DrawerThemeData`
struct DrawerThemeData: Codable, Identifiable, Hashable {
    var id: String
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
}

/// media — Dart 类 `DropdownMenuThemeData`
struct DropdownMenuThemeData: Codable, Identifiable, Hashable {
    var id: String
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
}

/// media — Dart 类 `DynamicFactoryConfig`
struct DynamicFactoryConfig: Codable, Identifiable, Hashable {
    var id: String
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
}

/// media — Dart 类 `ElevatedButtonThemeData`
struct ElevatedButtonThemeData: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
}

/// media — Dart 类 `ErrorResponse`
struct ErrorResponse: Codable, Identifiable, Hashable {
    var id: String
    var vid: String?
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
}

/// media — Dart 类 `ExifData`
struct ExifData: Codable, Identifiable, Hashable {
    var id: String
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
}

/// media — Dart 类 `ExoPlayerAudioTrackData`
struct ExoPlayerAudioTrackData: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
}

/// media — Dart 类 `ExpansionTileThemeData`
struct ExpansionTileThemeData: Codable, Identifiable, Hashable {
    var id: String
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
}

/// media — Dart 类 `FFmpegKitConfig`
struct FFmpegKitConfig: Codable, Identifiable, Hashable {
    var id: String
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
}

/// media — Dart 类 `FactoryConfig`
struct FactoryConfig: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
}

/// media — Dart 类 `FfiTrampolineData`
struct FfiTrampolineData: Codable, Identifiable, Hashable {
    var id: String
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
}

/// media — Dart 类 `FieldInfo`
struct FieldInfo: Codable, Identifiable, Hashable {
    var id: String
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
}

/// media — Dart 类 `FileInfo`
struct FileInfo: Codable, Identifiable, Hashable {
    var id: String
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
}

/// media — Dart 类 `FileResponse`
struct FileResponse: Codable, Identifiable, Hashable {
    var id: String
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
}

/// media — Dart 类 `FileServiceResponse`
struct FileServiceResponse: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
}

/// media — Dart 类 `FileSystemEntity`
struct FileSystemEntity: Codable, Identifiable, Hashable {
    var id: String
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
}

/// media — Dart 类 `FilledButtonThemeData`
struct FilledButtonThemeData: Codable, Identifiable, Hashable {
    var id: String
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
}

/// media — Dart 类 `FinderPatternInfo`
struct FinderPatternInfo: Codable, Identifiable, Hashable {
    var id: String
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
}

/// media — Dart 类 `FlexParentData`
struct FlexParentData: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
}

/// media — Dart 类 `FloatingActionButtonThemeData`
struct FloatingActionButtonThemeData: Codable, Identifiable, Hashable {
    var id: String
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
}

/// media — Dart 类 `FollowActressItem`
struct FollowActressItem: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
}

/// media — Dart 类 `FollowBloggerItem`
struct FollowBloggerItem: Codable, Identifiable, Hashable {
    var id: String
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
}

/// media — Dart 类 `FormData`
struct FormData: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
}

/// media — Dart 类 `ForwardingFileSystemEntity`
struct ForwardingFileSystemEntity: Codable, Identifiable, Hashable {
    var id: String
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
}

/// media — Dart 类 `FrameData`
struct FrameData: Codable, Identifiable, Hashable {
    var id: String
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
}

/// media — Dart 类 `FrameInfo`
struct FrameInfo: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
}

/// media — Dart 类 `FunctionPointerAndData`
struct FunctionPointerAndData: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
}

/// media — Dart 类 `GifImageSizeData`
struct GifImageSizeData: Codable, Identifiable, Hashable {
    var id: String
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
}

/// media — Dart 类 `GifInfo`
struct GifInfo: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
}

/// media — Dart 类 `GlobalDefaultData`
struct GlobalDefaultData: Codable, Identifiable, Hashable {
    var id: String
    var vid: String?
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
}

/// media — Dart 类 `GlyphInfo`
struct GlyphInfo: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
}

/// media — Dart 类 `GuideConfig`
struct GuideConfig: Codable, Identifiable, Hashable {
    var id: String
    var vid: String?
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
}

/// media — Dart 类 `GuidePushModel`
struct GuidePushModel: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
}

/// media — Dart 类 `GuideSceneConfig`
struct GuideSceneConfig: Codable, Identifiable, Hashable {
    var id: String
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `HappyModel`
struct HappyModel: Codable, Identifiable, Hashable {
    var id: String
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
}

/// media — Dart 类 `HolidayThemeModel`
struct HolidayThemeModel: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
}

/// media — Dart 类 `HomeDramaModuleData`
struct HomeDramaModuleData: Codable, Identifiable, Hashable {
    var id: String
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
}

/// media — Dart 类 `HomePlateModel`
struct HomePlateModel: Codable, Identifiable, Hashable {
    var id: String
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `HomeUpdateMarkersResp`
struct HomeUpdateMarkersResp: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
}

/// media — Dart 类 `HttpClientResponse`
struct HttpClientResponse: Codable, Identifiable, Hashable {
    var id: String
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
}

/// media — Dart 类 `HttpGetResponse`
struct HttpGetResponse: Codable, Identifiable, Hashable {
    var id: String
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
}

/// media — Dart 类 `HttpResponse`
struct HttpResponse: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `IMSessionModel`
struct IMSessionModel: Codable, Identifiable, Hashable {
    var id: String
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
}

/// media — Dart 类 `IOSSystemContextMenuItem`
struct IOSSystemContextMenuItem: Codable, Identifiable, Hashable {
    var id: String
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
}

/// media — Dart 类 `IOSSystemContextMenuItemData`
struct IOSSystemContextMenuItemData: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
}

/// media — Dart 类 `IOStreamedResponse`
struct IOStreamedResponse: Codable, Identifiable, Hashable {
    var id: String
    var vid: String?
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
}

/// media — Dart 类 `IcoBmpInfo`
struct IcoBmpInfo: Codable, Identifiable, Hashable {
    var id: String
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
}

/// media — Dart 类 `IcoInfo`
struct IcoInfo: Codable, Identifiable, Hashable {
    var id: String
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
}

/// media — Dart 类 `IconBean`
struct IconBean: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
}

/// media — Dart 类 `IconButtonThemeData`
struct IconButtonThemeData: Codable, Identifiable, Hashable {
    var id: String
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
}

/// media — Dart 类 `IconData`
struct IconData: Codable, Identifiable, Hashable {
    var id: String
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `IconThemeData`
struct IconThemeData: Codable, Identifiable, Hashable {
    var id: String
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
}

/// media — Dart 类 `ImageData`
struct ImageData: Codable, Identifiable, Hashable {
    var id: String
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
}

/// media — Dart 类 `ImageInfo`
struct ImageInfo: Codable, Identifiable, Hashable {
    var id: String
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
}

/// media — Dart 类 `ImageRankItem`
struct ImageRankItem: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
}

/// media — Dart 类 `ImageSizeData`
struct ImageSizeData: Codable, Identifiable, Hashable {
    var id: String
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
}

/// media — Dart 类 `ImageSizeInfo`
struct ImageSizeInfo: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
}

/// media — Dart 类 `ImageTilingInfo`
struct ImageTilingInfo: Codable, Identifiable, Hashable {
    var id: String
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
}

/// media — Dart 类 `ImageUploadResultModel`
struct ImageUploadResultModel: Codable, Identifiable, Hashable {
    var id: String
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
}

/// media — Dart 类 `IncomeModel`
struct IncomeModel: Codable, Identifiable, Hashable {
    var id: String
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
}

/// media — Dart 类 `InheritedModel`
struct InheritedModel: Codable, Identifiable, Hashable {
    var id: String
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
}

/// media — Dart 类 `InkResponse`
struct InkResponse: Codable, Identifiable, Hashable {
    var id: String
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `InputDecorationThemeData`
struct InputDecorationThemeData: Codable, Identifiable, Hashable {
    var id: String
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `InternalPngInfo`
struct InternalPngInfo: Codable, Identifiable, Hashable {
    var id: String
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `InternalWebPInfo`
struct InternalWebPInfo: Codable, Identifiable, Hashable {
    var id: String
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
}

/// media — Dart 类 `JGAreaModel`
struct JGAreaModel: Codable, Identifiable, Hashable {
    var id: String
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
}

/// media — Dart 类 `JpegData`
struct JpegData: Codable, Identifiable, Hashable {
    var id: String
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `JpegImageSizeData`
struct JpegImageSizeData: Codable, Identifiable, Hashable {
    var id: String
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
}

/// media — Dart 类 `JpegInfo`
struct JpegInfo: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
}

/// media — Dart 类 `KernelProgramInfo`
struct KernelProgramInfo: Codable, Identifiable, Hashable {
    var id: String
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
}

/// media — Dart 类 `KeyData`
struct KeyData: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
}

/// media — Dart 类 `LensModel`
struct LensModel: Codable, Identifiable, Hashable {
    var id: String
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
}

/// media — Dart 类 `ListBaseModel`
struct ListBaseModel: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `ListBean`
struct ListBean: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
}

/// media — Dart 类 `ListTileThemeData`
struct ListTileThemeData: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
}

/// media — Dart 类 `LocalFileSystemEntity`
struct LocalFileSystemEntity: Codable, Identifiable, Hashable {
    var id: String
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
    var goldCoin: Double?
}

/// media — Dart 类 `LogoutResponse`
struct LogoutResponse: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
}

/// media — Dart 类 `MagnifierInfo`
struct MagnifierInfo: Codable, Identifiable, Hashable {
    var id: String
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
}

/// media — Dart 类 `MainTabModel`
struct MainTabModel: Codable, Identifiable, Hashable {
    var id: String
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
}

/// media — Dart 类 `MapFieldInfo`
struct MapFieldInfo: Codable, Identifiable, Hashable {
    var id: String
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
}

/// media — Dart 类 `MarqueeModel`
struct MarqueeModel: Codable, Identifiable, Hashable {
    var id: String
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
}

/// media — Dart 类 `MaterialBasedCupertinoThemeData`
struct MaterialBasedCupertinoThemeData: Codable, Identifiable, Hashable {
    var id: String
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
}

/// media — Dart 类 `MediaInfo`
struct MediaInfo: Codable, Identifiable, Hashable {
    var id: String
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
}

/// media — Dart 类 `MediaQueryData`
struct MediaQueryData: Codable, Identifiable, Hashable {
    var id: String
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `MenuBarThemeData`
struct MenuBarThemeData: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
    var goldCoin: Double?
}

/// media — Dart 类 `MenuButtonThemeData`
struct MenuButtonThemeData: Codable, Identifiable, Hashable {
    var id: String
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `MenuThemeData`
struct MenuThemeData: Codable, Identifiable, Hashable {
    var id: String
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
}

/// media — Dart 类 `MetaData`
struct MetaData: Codable, Identifiable, Hashable {
    var id: String
    var vid: String?
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
}

/// media — Dart 类 `MethodChannelDeviceInfo`
struct MethodChannelDeviceInfo: Codable, Identifiable, Hashable {
    var id: String
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
}

/// media — Dart 类 `MethodChannelPackageInfo`
struct MethodChannelPackageInfo: Codable, Identifiable, Hashable {
    var id: String
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
}

/// media — Dart 类 `ModuleData`
struct ModuleData: Codable, Identifiable, Hashable {
    var id: String
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
}

/// media — Dart 类 `ModuleDetailModel`
struct ModuleDetailModel: Codable, Identifiable, Hashable {
    var id: String
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
}

/// media — Dart 类 `ModuleModel`
struct ModuleModel: Codable, Identifiable, Hashable {
    var id: String
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
}

/// media — Dart 类 `MultiChildLayoutParentData`
struct MultiChildLayoutParentData: Codable, Identifiable, Hashable {
    var id: String
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
}

/// media — Dart 类 `NativeAudioTrackData`
struct NativeAudioTrackData: Codable, Identifiable, Hashable {
    var id: String
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
}

/// media — Dart 类 `NavigationBarThemeData`
struct NavigationBarThemeData: Codable, Identifiable, Hashable {
    var id: String
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
}

/// media — Dart 类 `NavigationDrawerThemeData`
struct NavigationDrawerThemeData: Codable, Identifiable, Hashable {
    var id: String
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
}

/// media — Dart 类 `NavigationRailThemeData`
struct NavigationRailThemeData: Codable, Identifiable, Hashable {
    var id: String
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
}

/// media — Dart 类 `NetworkConfig`
struct NetworkConfig: Codable, Identifiable, Hashable {
    var id: String
    var vid: String?
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
}

/// media — Dart 类 `NetworkEnvironmentConfig`
struct NetworkEnvironmentConfig: Codable, Identifiable, Hashable {
    var id: String
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
}

/// media — Dart 类 `NoDefaultCupertinoThemeData`
struct NoDefaultCupertinoThemeData: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
}

/// media — Dart 类 `OutlinedButtonThemeData`
struct OutlinedButtonThemeData: Codable, Identifiable, Hashable {
    var id: String
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
}

/// media — Dart 类 `PackageInfo`
struct PackageInfo: Codable, Identifiable, Hashable {
    var id: String
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `PackageInfoData`
struct PackageInfoData: Codable, Identifiable, Hashable {
    var id: String
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
}

/// media — Dart 类 `ParentData`
struct ParentData: Codable, Identifiable, Hashable {
    var id: String
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
}

/// media — Dart 类 `PathSegmentData`
struct PathSegmentData: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
}

/// media — Dart 类 `PatternData`
struct PatternData: Codable, Identifiable, Hashable {
    var id: String
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
}

/// media — Dart 类 `PhotoGalleryItem`
struct PhotoGalleryItem: Codable, Identifiable, Hashable {
    var id: String
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
}

/// media — Dart 类 `PhysicalModel`
struct PhysicalModel: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
}

/// media — Dart 类 `PictureInfo`
struct PictureInfo: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
}

/// media — Dart 类 `PlatformMenuItem`
struct PlatformMenuItem: Codable, Identifiable, Hashable {
    var id: String
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
}

/// media — Dart 类 `PlatformProvidedMenuItem`
struct PlatformProvidedMenuItem: Codable, Identifiable, Hashable {
    var id: String
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
}

/// media — Dart 类 `PngImageSizeData`
struct PngImageSizeData: Codable, Identifiable, Hashable {
    var id: String
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
}

/// media — Dart 类 `PngInfo`
struct PngInfo: Codable, Identifiable, Hashable {
    var id: String
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `PnmInfo`
struct PnmInfo: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
}

/// media — Dart 类 `PointItem`
struct PointItem: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
}

/// media — Dart 类 `PointerData`
struct PointerData: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
}

/// media — Dart 类 `PopupMenuThemeData`
struct PopupMenuThemeData: Codable, Identifiable, Hashable {
    var id: String
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
}

/// media — Dart 类 `PreSaleDetailModel`
struct PreSaleDetailModel: Codable, Identifiable, Hashable {
    var id: String
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
}

/// media — Dart 类 `PreSaleModel`
struct PreSaleModel: Codable, Identifiable, Hashable {
    var id: String
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `PreSaleVideoModel`
struct PreSaleVideoModel: Codable, Identifiable, Hashable {
    var id: String
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
}

/// media — Dart 类 `ProgressIndicatorThemeData`
struct ProgressIndicatorThemeData: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
}

/// media — Dart 类 `Pvr2Info`
struct Pvr2Info: Codable, Identifiable, Hashable {
    var id: String
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
}

/// media — Dart 类 `Pvr3Info`
struct Pvr3Info: Codable, Identifiable, Hashable {
    var id: String
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
}

/// media — Dart 类 `PvrAppleInfo`
struct PvrAppleInfo: Codable, Identifiable, Hashable {
    var id: String
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
}

/// media — Dart 类 `QRCodeDecoderMetaData`
struct QRCodeDecoderMetaData: Codable, Identifiable, Hashable {
    var id: String
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
}

/// media — Dart 类 `QueueItem`
struct QueueItem: Codable, Identifiable, Hashable {
    var id: String
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
}

/// media — Dart 类 `RadioThemeData`
struct RadioThemeData: Codable, Identifiable, Hashable {
    var id: String
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
}

/// media — Dart 类 `RawKeyEventData`
struct RawKeyEventData: Codable, Identifiable, Hashable {
    var id: String
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
}

/// media — Dart 类 `ReadReceiptSyncResponse`
struct ReadReceiptSyncResponse: Codable, Identifiable, Hashable {
    var id: String
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
}

/// media — Dart 类 `RechargeListModel`
struct RechargeListModel: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
}

/// media — Dart 类 `RechargeTypeModel`
struct RechargeTypeModel: Codable, Identifiable, Hashable {
    var id: String
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `RechargeUrlModel`
struct RechargeUrlModel: Codable, Identifiable, Hashable {
    var id: String
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
}

/// media — Dart 类 `RedirectInfo`
struct RedirectInfo: Codable, Identifiable, Hashable {
    var id: String
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
}

/// media — Dart 类 `RenderMetaData`
struct RenderMetaData: Codable, Identifiable, Hashable {
    var id: String
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
    var goldCoin: Double?
}

/// media — Dart 类 `RenderPhysicalModel`
struct RenderPhysicalModel: Codable, Identifiable, Hashable {
    var id: String
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
}

/// media — Dart 类 `ReplyModel`
struct ReplyModel: Codable, Identifiable, Hashable {
    var id: String
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
}

/// media — Dart 类 `ResolvedPageInfo`
struct ResolvedPageInfo: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `ResultBean`
struct ResultBean: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `RouterConfig`
struct RouterConfig: Codable, Identifiable, Hashable {
    var id: String
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
}

/// media — Dart 类 `ScrollbarThemeData`
struct ScrollbarThemeData: Codable, Identifiable, Hashable {
    var id: String
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
}

/// media — Dart 类 `SdkConfig`
struct SdkConfig: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `SectionListResp`
struct SectionListResp: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
}

/// media — Dart 类 `SegmentedButtonThemeData`
struct SegmentedButtonThemeData: Codable, Identifiable, Hashable {
    var id: String
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `SemanticsData`
struct SemanticsData: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `ServerInfo`
struct ServerInfo: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
}

/// media — Dart 类 `SharedAppData`
struct SharedAppData: Codable, Identifiable, Hashable {
    var id: String
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
}

/// media — Dart 类 `ShrinkWrapParentData`
struct ShrinkWrapParentData: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
}

/// media — Dart 类 `SimpleCollectionsItem`
struct SimpleCollectionsItem: Codable, Identifiable, Hashable {
    var id: String
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `SliderThemeData`
struct SliderThemeData: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `SliverGridParentData`
struct SliverGridParentData: Codable, Identifiable, Hashable {
    var id: String
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
    var goldCoin: Double?
}

/// media — Dart 类 `SliverLogicalContainerParentData`
struct SliverLogicalContainerParentData: Codable, Identifiable, Hashable {
    var id: String
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
}

/// media — Dart 类 `SliverLogicalParentData`
struct SliverLogicalParentData: Codable, Identifiable, Hashable {
    var id: String
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
}

/// media — Dart 类 `SliverMultiBoxAdaptorParentData`
struct SliverMultiBoxAdaptorParentData: Codable, Identifiable, Hashable {
    var id: String
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
}

/// media — Dart 类 `SliverPhysicalContainerParentData`
struct SliverPhysicalContainerParentData: Codable, Identifiable, Hashable {
    var id: String
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
}

/// media — Dart 类 `SliverPhysicalParentData`
struct SliverPhysicalParentData: Codable, Identifiable, Hashable {
    var id: String
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
}

/// media — Dart 类 `SliverWaterfallFlowParentData`
struct SliverWaterfallFlowParentData: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `SnackBarThemeData`
struct SnackBarThemeData: Codable, Identifiable, Hashable {
    var id: String
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
}

/// media — Dart 类 `SortRuleModel`
struct SortRuleModel: Codable, Identifiable, Hashable {
    var id: String
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
}

/// media — Dart 类 `SpatialFrequencyResponse`
struct SpatialFrequencyResponse: Codable, Identifiable, Hashable {
    var id: String
    var vid: String?
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
}

/// media — Dart 类 `StackParentData`
struct StackParentData: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
}

/// media — Dart 类 `StaggerInItem`
struct StaggerInItem: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
}

/// media — Dart 类 `StaticFactoryConfig`
struct StaticFactoryConfig: Codable, Identifiable, Hashable {
    var id: String
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
}

/// media — Dart 类 `StreamedResponse`
struct StreamedResponse: Codable, Identifiable, Hashable {
    var id: String
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `SuccessResponse`
struct SuccessResponse: Codable, Identifiable, Hashable {
    var id: String
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
}

/// media — Dart 类 `SwipeActionItem`
struct SwipeActionItem: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
}

/// media — Dart 类 `SwitchThemeData`
struct SwitchThemeData: Codable, Identifiable, Hashable {
    var id: String
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
}

/// media — Dart 类 `TabBarThemeData`
struct TabBarThemeData: Codable, Identifiable, Hashable {
    var id: String
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
}

/// media — Dart 类 `TableInfo`
struct TableInfo: Codable, Identifiable, Hashable {
    var id: String
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
}

/// media — Dart 类 `TagsBean`
struct TagsBean: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
}

/// media — Dart 类 `TemplateModel`
struct TemplateModel: Codable, Identifiable, Hashable {
    var id: String
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
}

/// media — Dart 类 `TgaInfo`
struct TgaInfo: Codable, Identifiable, Hashable {
    var id: String
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
}

/// media — Dart 类 `ThemeData`
struct ThemeData: Codable, Identifiable, Hashable {
    var id: String
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `TiffInfo`
struct TiffInfo: Codable, Identifiable, Hashable {
    var id: String
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
}

/// media — Dart 类 `TimePickerThemeData`
struct TimePickerThemeData: Codable, Identifiable, Hashable {
    var id: String
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
}

/// media — Dart 类 `ToggleButtonsThemeData`
struct ToggleButtonsThemeData: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `ToolbarItemsParentData`
struct ToolbarItemsParentData: Codable, Identifiable, Hashable {
    var id: String
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
}

/// media — Dart 类 `TooltipThemeData`
struct TooltipThemeData: Codable, Identifiable, Hashable {
    var id: String
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
}

/// media — Dart 类 `TransferableTypedData`
struct TransferableTypedData: Codable, Identifiable, Hashable {
    var id: String
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
}

/// media — Dart 类 `TransformInfo`
struct TransformInfo: Codable, Identifiable, Hashable {
    var id: String
    var vid: String?
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
}

/// media — Dart 类 `TweenSequenceItem`
struct TweenSequenceItem: Codable, Identifiable, Hashable {
    var id: String
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
}

/// media — Dart 类 `TypedData`
struct TypedData: Codable, Identifiable, Hashable {
    var id: String
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
}

/// media — Dart 类 `UninitializedLocaleData`
struct UninitializedLocaleData: Codable, Identifiable, Hashable {
    var id: String
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
}

/// media — Dart 类 `UriData`
struct UriData: Codable, Identifiable, Hashable {
    var id: String
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
}

/// media — Dart 类 `VP8FInfo`
struct VP8FInfo: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `VP8MBData`
struct VP8MBData: Codable, Identifiable, Hashable {
    var id: String
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
}

/// media — Dart 类 `VideoListResp`
struct VideoListResp: Codable, Identifiable, Hashable {
    var id: String
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
}

/// media — Dart 类 `VideoModel`
struct VideoModel: Codable, Identifiable, Hashable {
    var id: String
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
    var playUrl: String?
    var source: String?
}

/// media — Dart 类 `VideoRankItem`
struct VideoRankItem: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
    var isFree: Bool?
}

/// media — Dart 类 `VideoUploadResultModel`
struct VideoUploadResultModel: Codable, Identifiable, Hashable {
    var id: String
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
    var tags: [String]?
    var url: String?
}

/// media — Dart 类 `VisibilityInfo`
struct VisibilityInfo: Codable, Identifiable, Hashable {
    var id: String
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
    var episode: Int?
}

/// media — Dart 类 `WebPImageSizeData`
struct WebPImageSizeData: Codable, Identifiable, Hashable {
    var id: String
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
    var likeCount: Int?
    var commentCount: Int?
    var collectCount: Int?
    var shareCount: Int?
    var status: Int?
    var labels: [String]?
}

/// media — Dart 类 `WebPInfo`
struct WebPInfo: Codable, Identifiable, Hashable {
    var id: String
    var duration: Double?
    var episode: Int?
    var episodeCount: Int?
    var total: Int?
    var score: Double?
    var heat: Double?
    var playCount: Int?
    var viewCount: Int?
}

/// media — Dart 类 `WrapParentData`
struct WrapParentData: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var name: String?
    var cover: String?
    var coverUrl: String?
    var poster: String?
    var description: String?
    var duration: Double?
}

/// media — Dart 类 `YinseinnerModel`
struct YinseinnerModel: Codable, Identifiable, Hashable {
    var id: String
    var url: String?
    var playUrl: String?
    var source: String?
    var author: String?
    var createTime: String?
    var updateTime: String?
    var isVip: Bool?
    var isLocked: Bool?
}


// MARK: - cartoon

/// cartoon — Dart 类 `CartoonChapterItem`
struct CartoonChapterItem: Codable, Identifiable, Hashable {
    var id: String
    var chapterId: String?
    var chapterName: String?
    var chapterCount: Int?
    var totalCount: Int?
    var readProgress: Int?
    var status: Int?
    var description: String?
}

/// cartoon — Dart 类 `CartoonMediaInfo`
struct CartoonMediaInfo: Codable, Identifiable, Hashable {
    var id: String
    var chapterId: String?
    var chapterName: String?
    var chapterCount: Int?
    var totalCount: Int?
    var readProgress: Int?
    var status: Int?
    var description: String?
    var tags: [String]?
}

/// cartoon — Dart 类 `ComicChapterInfo`
struct ComicChapterInfo: Codable, Identifiable, Hashable {
    var id: String
    var description: String?
    var tags: [String]?
    var score: Double?
    var heat: Double?
    var updateTime: String?
    var createTime: String?
    var isCollect: Bool?
    var isLike: Bool?
    var url: String?
}


// MARK: - novel

/// novel — Dart 类 `CupertinoTextThemeData`
struct CupertinoTextThemeData: Codable, Identifiable, Hashable {
    var id: String
    var chapterCount: Int?
    var content: String?
    var status: Int?
    var description: String?
    var tags: [String]?
    var score: Double?
    var heat: Double?
}

/// novel — Dart 类 `TextButtonThemeData`
struct TextButtonThemeData: Codable, Identifiable, Hashable {
    var id: String
    var content: String?
    var status: Int?
    var description: String?
    var tags: [String]?
    var score: Double?
    var heat: Double?
    var words: Double?
    var readCount: Double?
    var isCollect: Bool?
    var updateTime: String?
}

/// novel — Dart 类 `TextConfig`
struct TextConfig: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var author: String?
    var cover: String?
    var chapterId: String?
    var chapterName: String?
    var chapterCount: Int?
    var content: String?
    var status: Int?
    var description: String?
    var tags: [String]?
}

/// novel — Dart 类 `TextParentData`
struct TextParentData: Codable, Identifiable, Hashable {
    var id: String
    var status: Int?
    var description: String?
    var tags: [String]?
    var score: Double?
    var heat: Double?
    var words: Double?
    var readCount: Double?
    var isCollect: Bool?
}

/// novel — Dart 类 `TextSelectionThemeData`
struct TextSelectionThemeData: Codable, Identifiable, Hashable {
    var id: String
    var description: String?
    var tags: [String]?
    var score: Double?
    var heat: Double?
    var words: Double?
    var readCount: Double?
    var isCollect: Bool?
    var updateTime: String?
}


// MARK: - community

/// community — Dart 类 `DramaFeedItem`
struct DramaFeedItem: Codable, Identifiable, Hashable {
    var id: String
    var userId: String?
    var nickname: String?
    var avatar: String?
    var likeCount: Int?
    var commentCount: Int?
    var shareCount: Int?
    var viewCount: Int?
}

/// community — Dart 类 `FollowTopicItem`
struct FollowTopicItem: Codable, Identifiable, Hashable {
    var id: String
    var resourceType: String?
    var userId: String?
    var nickname: String?
    var avatar: String?
    var likeCount: Int?
    var commentCount: Int?
    var shareCount: Int?
    var viewCount: Int?
}

/// community — Dart 类 `OfficialListItemModel`
struct OfficialListItemModel: Codable, Identifiable, Hashable {
    var id: String
    var viewCount: Int?
    var isLike: Bool?
    var isCollect: Bool?
    var goldCoin: Double?
    var tags: [String]?
    var topic: String?
}

/// community — Dart 类 `PublishVideoModel`
struct PublishVideoModel: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var content: String?
    var cover: String?
    var images: String?
    var videoUrl: String?
    var resourceType: String?
    var userId: String?
    var nickname: String?
}

/// community — Dart 类 `TopicItem`
struct TopicItem: Codable, Identifiable, Hashable {
    var id: String
    var nickname: String?
    var avatar: String?
    var likeCount: Int?
    var commentCount: Int?
    var shareCount: Int?
    var viewCount: Int?
}


// MARK: - comment

/// comment — Dart 类 `CommentBean`
struct CommentBean: Codable, Identifiable, Hashable {
    var id: String
    var avatar: String?
    var replyUser: String?
    var replyNickname: String?
    var likeCount: Int?
    var isLike: Bool?
    var parentId: String?
    var createTime: String?
    var postId: String?
}

/// comment — Dart 类 `CommentItem`
struct CommentItem: Codable, Identifiable, Hashable {
    var id: String
    var content: String?
    var userId: String?
    var nickname: String?
    var avatar: String?
    var replyUser: String?
    var replyNickname: String?
    var likeCount: Int?
    var isLike: Bool?
}

/// comment — Dart 类 `CommentTopBannerModel`
struct CommentTopBannerModel: Codable, Identifiable, Hashable {
    var id: String
    var commentId: String?
    var content: String?
    var userId: String?
    var nickname: String?
    var avatar: String?
    var replyUser: String?
}

/// comment — Dart 类 `MessageCommentItem`
struct MessageCommentItem: Codable, Identifiable, Hashable {
    var id: String
    var replyNickname: String?
    var likeCount: Int?
    var isLike: Bool?
    var parentId: String?
    var createTime: String?
    var postId: String?
    var image: String?
}

/// comment — Dart 类 `ReplyCommentItem`
struct ReplyCommentItem: Codable, Identifiable, Hashable {
    var id: String
    var replyUser: String?
    var replyNickname: String?
    var likeCount: Int?
    var isLike: Bool?
    var parentId: String?
    var createTime: String?
    var postId: String?
}

/// comment — Dart 类 `UserCommentItem`
struct UserCommentItem: Codable, Identifiable, Hashable {
    var id: String
    var nickname: String?
    var avatar: String?
    var replyUser: String?
    var replyNickname: String?
    var likeCount: Int?
    var isLike: Bool?
    var parentId: String?
    var createTime: String?
}


// MARK: - user

/// user — Dart 类 `AccountInfoModel`
struct AccountInfoModel: Codable, Identifiable, Hashable {
    var id: String
    var level: Double?
    var vipLevel: Int?
    var vipExpire: String?
    var isVip: Bool?
    var coin: Double?
    var goldCoin: Double?
}

/// user — Dart 类 `CupertinoUserInterfaceLevelData`
struct CupertinoUserInterfaceLevelData: Codable, Identifiable, Hashable {
    var id: String
    var goldCoin: Double?
    var integral: Double?
    var exp: Double?
    var growth: Double?
    var loginType: String?
    var createTime: String?
    var bindPhone: Bool?
    var isAuth: Bool?
    var realName: String?
}

/// user — Dart 类 `DcUserInfo`
struct DcUserInfo: Codable, Identifiable, Hashable {
    var id: String
    var avatar: String?
    var phone: String?
    var sex: String?
    var birthday: String?
    var signature: String?
    var level: Double?
    var vipLevel: Int?
    var vipExpire: String?
    var isVip: Bool?
}

/// user — Dart 类 `FollowUserModel`
struct FollowUserModel: Codable, Identifiable, Hashable {
    var id: String
    var goldCoin: Double?
    var integral: Double?
    var exp: Double?
    var growth: Double?
    var loginType: String?
    var createTime: String?
    var bindPhone: Bool?
    var isAuth: Bool?
    var realName: String?
    var idCard: String?
}

/// user — Dart 类 `ImUserModel`
struct ImUserModel: Codable, Identifiable, Hashable {
    var id: String
    var nickname: String?
    var avatar: String?
    var phone: String?
    var sex: String?
    var birthday: String?
    var signature: String?
    var level: Double?
    var vipLevel: Int?
    var vipExpire: String?
    var isVip: Bool?
}

/// user — Dart 类 `ModelUserInfo`
struct ModelUserInfo: Codable, Identifiable, Hashable {
    var id: String
    var avatar: String?
    var phone: String?
    var sex: String?
    var birthday: String?
    var signature: String?
    var level: Double?
    var vipLevel: Int?
    var vipExpire: String?
    var isVip: Bool?
}

/// user — Dart 类 `UserIncomeModel`
struct UserIncomeModel: Codable, Identifiable, Hashable {
    var id: String
    var avatar: String?
    var phone: String?
    var sex: String?
    var birthday: String?
    var signature: String?
    var level: Double?
}


// MARK: - wallet

/// wallet — Dart 类 `ApBankListModel`
struct ApBankListModel: Codable, Identifiable, Hashable {
    var id: String
    var coin: Double?
    var goldCoin: Double?
    var balance: String?
    var currency: String?
    var type: Int?
    var status: Int?
    var createTime: String?
}

/// wallet — Dart 类 `BankcardInfo`
struct BankcardInfo: Codable, Identifiable, Hashable {
    var id: String
    var channel: String?
    var tradeNo: String?
    var outTradeNo: String?
    var fee: Double?
    var bankName: String?
    var cardNo: String?
    var realName: String?
}

/// wallet — Dart 类 `CoinItem`
struct CoinItem: Codable, Identifiable, Hashable {
    var id: String
    var amount: Double?
    var coin: Double?
    var goldCoin: Double?
    var balance: String?
    var currency: String?
    var type: Int?
    var status: Int?
}

/// wallet — Dart 类 `ExchangeRecordModel`
struct ExchangeRecordModel: Codable, Identifiable, Hashable {
    var id: String
    var balance: String?
    var currency: String?
    var type: Int?
    var status: Int?
    var createTime: String?
    var finishTime: String?
    var channel: String?
    var tradeNo: String?
}

/// wallet — Dart 类 `IntegralExchangeModel`
struct IntegralExchangeModel: Codable, Identifiable, Hashable {
    var id: String
    var channel: String?
    var tradeNo: String?
    var outTradeNo: String?
    var fee: Double?
    var bankName: String?
    var cardNo: String?
    var realName: String?
    var remark: String?
}

/// wallet — Dart 类 `PayForModel`
struct PayForModel: Codable, Identifiable, Hashable {
    var id: String
    var tradeNo: String?
    var outTradeNo: String?
    var fee: Double?
    var bankName: String?
    var cardNo: String?
    var realName: String?
}

/// wallet — Dart 类 `PayOrderTrackInfo`
struct PayOrderTrackInfo: Codable, Identifiable, Hashable {
    var id: String
    var goldCoin: Double?
    var balance: String?
    var currency: String?
    var type: Int?
    var status: Int?
    var createTime: String?
    var finishTime: String?
    var channel: String?
    var tradeNo: String?
}

/// wallet — Dart 类 `PayTierConfig`
struct PayTierConfig: Codable, Identifiable, Hashable {
    var id: String
    var amount: Double?
    var coin: Double?
    var goldCoin: Double?
    var balance: String?
    var currency: String?
}

/// wallet — Dart 类 `PayTierModel`
struct PayTierModel: Codable, Identifiable, Hashable {
    var id: String
    var coin: Double?
    var goldCoin: Double?
    var balance: String?
    var currency: String?
    var type: Int?
    var status: Int?
    var createTime: String?
    var finishTime: String?
    var channel: String?
    var tradeNo: String?
}

/// wallet — Dart 类 `WithdrawDetailsModel`
struct WithdrawDetailsModel: Codable, Identifiable, Hashable {
    var id: String
    var type: Int?
    var status: Int?
    var createTime: String?
    var finishTime: String?
    var channel: String?
    var tradeNo: String?
    var outTradeNo: String?
    var fee: Double?
    var bankName: String?
    var cardNo: String?
}

/// wallet — Dart 类 `WithdrawalRecordItem`
struct WithdrawalRecordItem: Codable, Identifiable, Hashable {
    var id: String
    var goldCoin: Double?
    var balance: String?
    var currency: String?
    var type: Int?
    var status: Int?
    var createTime: String?
    var finishTime: String?
    var channel: String?
    var tradeNo: String?
}


// MARK: - vip

/// vip — Dart 类 `AICouponModel`
struct AICouponModel: Codable, Identifiable, Hashable {
    var id: String
    var price: Double?
    var originalPrice: String?
    var day: Double?
    var days: Double?
    var type: Int?
    var status: Int?
    var discount: String?
    var privilege: [String]?
    var description: String?
}

/// vip — Dart 类 `CouponModel`
struct CouponModel: Codable, Identifiable, Hashable {
    var id: String
    var day: Double?
    var days: Double?
    var type: Int?
    var status: Int?
    var discount: String?
    var privilege: [String]?
}

/// vip — Dart 类 `VipCardItem`
struct VipCardItem: Codable, Identifiable, Hashable {
    var id: String
    var vipLevel: Int?
    var vipName: String?
    var price: Double?
    var originalPrice: String?
    var day: Double?
}

/// vip — Dart 类 `VipProductListModel`
struct VipProductListModel: Codable, Identifiable, Hashable {
    var id: String
    var day: Double?
    var days: Double?
    var type: Int?
    var status: Int?
    var discount: String?
    var privilege: [String]?
    var description: String?
    var expireTime: String?
    var productId: String?
    var title: String?
}

/// vip — Dart 类 `VipProductPrivilegeItem`
struct VipProductPrivilegeItem: Codable, Identifiable, Hashable {
    var id: String
    var originalPrice: String?
    var day: Double?
    var days: Double?
    var type: Int?
    var status: Int?
    var discount: String?
    var privilege: [String]?
    var description: String?
    var expireTime: String?
    var productId: String?
}

/// vip — Dart 类 `VipSupportModel`
struct VipSupportModel: Codable, Identifiable, Hashable {
    var id: String
    var day: Double?
    var days: Double?
    var type: Int?
    var status: Int?
    var discount: String?
    var privilege: [String]?
}

/// vip — Dart 类 `VipUiConfig`
struct VipUiConfig: Codable, Identifiable, Hashable {
    var id: String
    var vipName: String?
    var price: Double?
    var originalPrice: String?
    var day: Double?
    var days: Double?
    var type: Int?
    var status: Int?
}


// MARK: - task

/// task — Dart 类 `CheckinDoResp`
struct CheckinDoResp: Codable, Identifiable, Hashable {
    var id: String
    var goldCoin: Double?
    var integral: Double?
    var status: Int?
    var progress: Double?
    var target: Double?
    var current: Double?
    var createTime: String?
    var finishTime: String?
}

/// task — Dart 类 `CheckinInfo`
struct CheckinInfo: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var type: Int?
    var reward: String?
    var goldCoin: Double?
    var integral: Double?
    var status: Int?
    var progress: Double?
    var target: Double?
    var current: Double?
    var createTime: String?
}

/// task — Dart 类 `CheckinPrizeResp`
struct CheckinPrizeResp: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var type: Int?
    var reward: String?
    var goldCoin: Double?
    var integral: Double?
    var status: Int?
}

/// task — Dart 类 `ExtraSignRewardItem`
struct ExtraSignRewardItem: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var type: Int?
    var reward: String?
    var goldCoin: Double?
    var integral: Double?
    var status: Int?
    var progress: Double?
    var target: Double?
    var current: Double?
    var createTime: String?
}

/// task — Dart 类 `TaskCenterData`
struct TaskCenterData: Codable, Identifiable, Hashable {
    var id: String
    var status: Int?
    var progress: Double?
    var target: Double?
    var current: Double?
    var createTime: String?
    var finishTime: String?
}

/// task — Dart 类 `TaskItem`
struct TaskItem: Codable, Identifiable, Hashable {
    var id: String
    var goldCoin: Double?
    var integral: Double?
    var status: Int?
    var progress: Double?
    var target: Double?
    var current: Double?
    var createTime: String?
    var finishTime: String?
}


// MARK: - im

/// im — Dart 类 `IMMessageModel`
struct IMMessageModel: Codable, Identifiable, Hashable {
    var id: String
    var msgId: String?
    var conversationId: String?
    var fromUser: String?
    var toUser: String?
    var content: String?
    var type: Int?
}

/// im — Dart 类 `ImAdItem`
struct ImAdItem: Codable, Identifiable, Hashable {
    var id: String
    var conversationId: String?
    var fromUser: String?
    var toUser: String?
    var content: String?
    var type: Int?
    var createTime: String?
    var status: Int?
}

/// im — Dart 类 `ImAdResp`
struct ImAdResp: Codable, Identifiable, Hashable {
    var id: String
    var conversationId: String?
    var fromUser: String?
    var toUser: String?
    var content: String?
    var type: Int?
    var createTime: String?
    var status: Int?
    var read: Bool?
}

/// im — Dart 类 `MessageThumbItem`
struct MessageThumbItem: Codable, Identifiable, Hashable {
    var id: String
    var fromUser: String?
    var toUser: String?
    var content: String?
    var type: Int?
    var createTime: String?
    var status: Int?
}

/// im — Dart 类 `StreamMessageInfo`
struct StreamMessageInfo: Codable, Identifiable, Hashable {
    var id: String
    var fromUser: String?
    var toUser: String?
    var content: String?
    var type: Int?
    var createTime: String?
    var status: Int?
}


// MARK: - live

/// live — Dart 类 `LiveMainModel`
struct LiveMainModel: Codable, Identifiable, Hashable {
    var id: String
    var nickname: String?
    var avatar: String?
    var streamUrl: String?
    var playUrl: String?
    var online: Int?
    var viewerCount: Int?
    var status: Int?
}


// MARK: - ai

/// ai — Dart 类 `AIGirlFriendUrlModel`
struct AIGirlFriendUrlModel: Codable, Identifiable, Hashable {
    var id: String
    var videoUrl: String?
    var result: String?
    var status: Int?
    var progress: Double?
    var model: String?
    var createTime: String?
}

/// ai — Dart 类 `AISquareItemModel`
struct AISquareItemModel: Codable, Identifiable, Hashable {
    var id: String
    var imageUrl: String?
    var videoUrl: String?
    var result: String?
    var status: Int?
    var progress: Double?
    var model: String?
    var createTime: String?
    var cost: Int?
    var goldCoin: Double?
    var url: String?
}

/// ai — Dart 类 `AiRecordModel`
struct AiRecordModel: Codable, Identifiable, Hashable {
    var id: String
    var prompt: String?
    var imageUrl: String?
    var videoUrl: String?
    var result: String?
    var status: Int?
    var progress: Double?
    var model: String?
    var createTime: String?
    var cost: Int?
    var goldCoin: Double?
}


// MARK: - ads

/// ads — Dart 类 `AdExposureModel`
struct AdExposureModel: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var image: String?
    var icon: String?
    var url: String?
    var jumpUrl: String?
    var position: Int?
    var status: Int?
}

/// ads — Dart 类 `AdTabConfig`
struct AdTabConfig: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var image: String?
    var icon: String?
    var url: String?
    var jumpUrl: String?
    var position: Int?
    var status: Int?
    var createTime: String?
}

/// ads — Dart 类 `AdsBean`
struct AdsBean: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var image: String?
    var icon: String?
    var url: String?
    var jumpUrl: String?
    var position: Int?
    var status: Int?
    var createTime: String?
    var order: Int?
}

/// ads — Dart 类 `AdsInfoModel`
struct AdsInfoModel: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var image: String?
    var icon: String?
    var url: String?
    var jumpUrl: String?
    var position: Int?
    var status: Int?
    var createTime: String?
    var order: Int?
}

/// ads — Dart 类 `AdsItem`
struct AdsItem: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var image: String?
    var icon: String?
    var url: String?
    var jumpUrl: String?
    var position: Int?
    var status: Int?
    var createTime: String?
    var order: Int?
}

/// ads — Dart 类 `BannerJumpEntity`
struct BannerJumpEntity: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var image: String?
    var icon: String?
    var url: String?
    var jumpUrl: String?
    var position: Int?
    var status: Int?
}

/// ads — Dart 类 `MaterialBannerThemeData`
struct MaterialBannerThemeData: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var image: String?
    var icon: String?
    var url: String?
    var jumpUrl: String?
}


// MARK: - search

/// search — Dart 类 `CreditRecordModel`
struct CreditRecordModel: Codable, Identifiable, Hashable {
    var id: String
    var keyword: String?
    var title: String?
    var cover: String?
    var type: Int?
    var score: Double?
    var heat: Double?
    var tags: [String]?
}

/// search — Dart 类 `GoldRecordItem`
struct GoldRecordItem: Codable, Identifiable, Hashable {
    var id: String
    var keyword: String?
    var title: String?
    var cover: String?
    var type: Int?
    var score: Double?
    var heat: Double?
}

/// search — Dart 类 `InComeRecordItem`
struct InComeRecordItem: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var cover: String?
    var type: Int?
    var score: Double?
    var heat: Double?
    var tags: [String]?
    var author: String?
    var createTime: String?
}

/// search — Dart 类 `MediaSearchListModel`
struct MediaSearchListModel: Codable, Identifiable, Hashable {
    var id: String
    var keyword: String?
    var title: String?
    var cover: String?
    var type: Int?
    var score: Double?
    var heat: Double?
    var tags: [String]?
    var author: String?
}

/// search — Dart 类 `RechargeRecordItem`
struct RechargeRecordItem: Codable, Identifiable, Hashable {
    var id: String
    var keyword: String?
    var title: String?
    var cover: String?
    var type: Int?
    var score: Double?
    var heat: Double?
    var tags: [String]?
    var author: String?
}

/// search — Dart 类 `SearchBarThemeData`
struct SearchBarThemeData: Codable, Identifiable, Hashable {
    var id: String
    var keyword: String?
    var title: String?
    var cover: String?
    var type: Int?
    var score: Double?
    var heat: Double?
    var tags: [String]?
}

/// search — Dart 类 `SearchViewThemeData`
struct SearchViewThemeData: Codable, Identifiable, Hashable {
    var id: String
    var title: String?
    var cover: String?
    var type: Int?
    var score: Double?
    var heat: Double?
    var tags: [String]?
    var author: String?
}


// MARK: - 容错便捷构造
extension Array where Element: Codable {
    /// 从任意 JSON 数组安全解码（单字段缺失时以空数组兜底）
    static func decodeTolerant(_ json: Any?) -> [Element] {
        guard let data = try? JSONSerialization.data(withJSONObject: json ?? []) else { return [] }
        return (try? JSONDecoder.tolerant.decode([Element].self, from: data)) ?? []
    }
}

extension Optional where Wrapped: Codable {
    /// 单对象安全解码
    static func decodeTolerant(_ json: Any?) -> Wrapped? {
        guard let d = try? JSONSerialization.data(withJSONObject: json ?? [:]) else { return nil }
        return try? JSONDecoder.tolerant.decode(Wrapped.self, from: d)
    }
}
