# DramaHub for iOS

基于 `lldj2.4.0V5.apk`（应用名「破解短剧」，Flutter + GetX 架构）静态逆向分析成果复刻的 **iOS 端短剧平台 App**。SwiftUI + iOS 16+，零第三方依赖，开箱即可运行（内置演示数据）。

## 与源 App 的映射

| 本工程 | 源 App（jydj Dart 包） | 说明 |
|---|---|---|
| `App/RootView.swift` | `hj_page/main_page/main_tabbar` + `bottom_bar_provider` | 底部四 Tab：首页 / 短剧 / 社区 / 我的 |
| `Core/Network/APIClient.swift` | `tools_base/net/net_manager` + `http_response_interceptor` + `sdk_common_header` | URLSession + 公共头拦截器（X-Token/X-Platform/X-App-Version/X-Device-Id） |
| `Core/Network/APIEndpoint.swift` | `hj_utils/api_service/*` + `tools_base/net/*` | 130 个端点逐一对应（见分析报告 §4） |
| `Core/Network/BaseRespBean.swift` | `tools_base/net/base_resp_bean.dart` | 统一响应包 `{code, msg, data}` |
| `Core/Network/TokenStore.swift` | MMKV `_key_net_token` | Keychain 持久化 |
| `Core/Models/*` | `hj_model/*`（130 个 fromJson 模型） | 按域精简为核心模型 |
| `Core/Storage/PlaybackStore.swift` | `tools_base/cache/history/*` + `drama_resume_store` | 续播 / 观看历史 / 搜索历史 |
| `Features/Home` | `hj_page/home/*` | Banner + 动态模块 Tab + Feed |
| `Features/Drama` | `hj_page/drama/*` | 列表 / 详情 / 剧集面板 / 付费墙 / 播放器 |
| `Features/Player/VideoPlayerView.swift` | `hj_page/drama/view/drama_video_player` | AVPlayer（m3u8 原生支持，替代 ijkplayer） |
| `Features/Community` | `hj_page/community/*` + `hj_page/comment/*` | 信息流 / 详情 / 发布 |
| `Features/Mine` | `hj_page/mine/*` | 钱包 / VIP / 充值 / 提现 / 签到 / 任务 / 邀请 |
| `Features/Live` | `hj_page/live/*` | 直播列表（九宫格） |
| `Features/AI` | `hj_page/ai/*` | AI 模块入口 + 生成记录 |

## 运行

### 方式一：XcodeGen（推荐）

```bash
brew install xcodegen   # 或 https://github.com/yonaskolb/XcodeGen
xcodegen generate
open DramaHub.xcodeproj
```

### 方式二：手动

1. Xcode 15+ → Create App Project（iOS 16+，SwiftUI）。
2. 删除模板生成的 `ContentView.swift`，将 `DramaHub/` 目录整个拖入工程。
3. 运行（Cmd+R）。

## 演示模式与真实后端

`Core/Network/APIClient.swift` 中 `Config.useMock = true`：所有 Service 返回 `MockData`，无需后端。

接入真实后端：

1. `Config.useMock = false`；
2. `Config.apiBaseURL` 设为初始 API 域名（原版经 `/ping/domain/refresh` + AES-GCM `encryptedConfig` 动态刷新）；
3. IM 长连：`Config.imWebSocketURL`（`wss://twss.flowcd.cn:32214`），协议为 protobuf，需补 `Core/Services/IMService`。

## 云编译（GitHub Actions）

仓库：**https://github.com/lu5333285/dramahub-ios**

每次 push 到 `main` 自动触发（也可在 Actions 页 Manual Run）。CI 流程：macOS 15 runner → `brew install xcodegen` → `xcodegen generate` → 无签名 `xcodebuild`（Debug, generic/platform=iOS）→ 上传三个 artifact：

| Artifact | 内容 | 用途 |
|---|---|---|
| `DramaHub-unsigned-ipa` | 未签名 `.ipa`（Payload 结构） | 重签名后真机安装 |
| `DramaHub-app` | `DramaHub.app.zip` | 重签名 / 模拟器调试 |
| `build-log` | 完整 `build.log` | 编译失败排查 |

本地手动触发 / 下载：

```bash
gh run watch --repo lu5333285/dramahub-ios          # 看编译进度
gh run download <run-id> --repo lu5333285/dramahub-ios   # 下载产物
```

## 目录结构

```
DramaHub/
├── App/                     # 入口、主题、会话
├── Core/
│   ├── Network/             # APIClient / APIEndpoint / BaseRespBean / TokenStore
│   ├── Models/              # 用户、媒资、VIP、社区、签到、直播、AI、IM
│   ├── Services/            # 业务服务 + MockData
│   ├── Storage/             # 播放进度与历史
│   └── Utils/               # 图片加载
└── Features/
    ├── Home / Drama / Player / Community / Live / AI / Mine
```

## 边界说明

- 本工程仅实现**通用短剧平台架构**（内容分类数据驱动），不含源 App 中的成人内容模块与对抗性分发逻辑（详见分析报告 §8）。
- 支付：iOS 端请接 IAP；源 App 为人工转账通道，仅保留数据模型映射。
- 埋点、IM、AI 生成为结构级交付（模型 + 服务契约完整，可接后端）。

## 分析报告

完整逆向分析见 `../rea_analysis/ANALYSIS_REPORT.md`（REA + jadx + AOT 字符串还原：包结构、130 端点、130 模型、业务流程）。
