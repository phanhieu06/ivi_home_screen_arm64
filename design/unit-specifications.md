# IVI負荷アプリ ユニット仕様書 (Unit Specification)

## 1. ユニット一覧 (Unit List)

| ユニット名 (Unit Name) | 所属層 (Layer) | 概要 (Description) |
|---|---|---|
| `StateManagement` | ロジック・状態層 | アプリケーション全体の状態（負荷率、UI状態等）を一元管理する。 |
| `IpcReceiver` | ロジック・状態層 | 外部システム（外部PC、AIアプリ）からのIPC通信を受信する。 |
| `CpuLoadGenerator` | ロジック・状態層 | 指定された負荷率に基づき、CPU負荷を生成する。 |
| `GpuLoadGenerator` | ロジック・状態層 | 指定された負荷率に基づき、GPU負荷を生成する。 |
| `AiData` | ロジック・状態層 | AI関連のデータを保持するデータモデル。（v3アーキテクチャでは単純化） |
| `CpuLoadController` | UI層 | CPU負荷を調整するためのUI（ボタン等）を描画し、ユーザー操作を処理する。 |
| `GpuLoadController` | UI層 | GPU負荷を調整するためのUI（ボタン等）を描画し、ユーザー操作を処理する。 |
| `AiAppView` | UI層 | AIアプリからの指示に基づき、関連するUIを描画する。 |

---

## 2. ユニット詳細 (Unit Details)

### `StateManagement`
- **所属層:** ロジック・状態層
- **概要:** アプリケーション全体のCPU/GPU負荷率、AI関連のUI表示状態などを一元管理する。外部からの指示やUI操作に応じて状態を更新し、関係各所に変更を通知する。
- **主要メソッド:**
  - `updateCpuLoad(load)`: CPU負荷率を更新する。
  - `updateGpuLoad(load)`: GPU負荷率を更新する。
  - `handleIpcMessage(message)`: 受信したIPCメッセージを解析し、適切な状態更新処理（負荷率変更、UI更新指示など）を呼び出す。
  - `getUiState()`: 現在のUI状態を返す。
- **主要プロパティ:**
  - `cpuLoad`: 現在のCPU負荷率。
  - `gpuLoad`: 現在のGPU負荷率。
  - `aiUiState`: AI関連のUI状態（アイコン表示有無など）。

### `IpcReceiver`
- **所属層:** ロジック・状態層
- **概要:** 外部システムからのIPC通信を受信し、内容を解析せずに`StateManagement`に転送する。
- **主要メソッド:**
  - `startListening()`: IPCソケットを開き、メッセージの待機を開始する。
  - `_onDataReceived(data)`: データ受信時に`StateManagement.handleIpcMessage`を呼び出す。

### `CpuLoadGenerator`
- **所属層:** ロジック・状態層
- **概要:** `StateManagement`からの指示に基づき、指定された負荷率のCPU負荷を生成する。通常、別Isolateで重い計算ループを実行することで実現する。
- **主要メソッド:**
  - `setLoad(percentage)`: 目標となるCPU負荷率を設定・更新する。
  - `stop()`: 負荷生成を停止する。

### `GpuLoadGenerator`
- **所属層:** ロジック・状態層
- **概要:** `StateManagement`からの指示に基づき、指定された負荷率のGPU負荷を生成する。通常、複雑なシェーダーを連続的に描画することで実現する。
- **主要メソッド:**
  - `setLoad(percentage)`: 目標となるGPU負荷率を設定・更新する。
  - `stop()`: 負荷生成を停止する。

### `AiData`
- **所属層:** ロジック・状態層
- **概要:** (v3アーキテクチャでは、具体的なデータ構造は`StateManagement`内の`aiUiState`に集約されるため、このクラスは単純化されるか、不要になる可能性がある).
- **主要プロパティ:**
  - (状態に応じて定義)

### `CpuLoadController`
- **所属層:** UI層
- **概要:** CPU負荷を調整・表示するためのUIウィジェット。
- **主要メソッド:**
  - `build(context)`: `StateManagement`から現在のCPU負荷率を取得し、UI（テキスト、ボタン）を描画する。ボタン押下時には`handleIncrease()` / `handleDecrease()`を呼び出す。
  - `handleIncrease()` / `handleDecrease()`: `StateManagement.updateCpuLoad`を呼び出し、状態の更新を要求する。

### `GpuLoadController`
- **所属層:** UI層
- **概要:** GPU負荷を調整・表示するためのUIウィジェット。
- **主要メソッド:**
  - `build(context)`: `StateManagement`から現在のGPU負荷率を取得し、UI（テキスト、ボタン）を描画する。ボタン押下時には`handleIncrease()` / `handleDecrease()`を呼び出す。
  - `handleIncrease()` / `handleDecrease()`: `StateManagement.updateGpuLoad`を呼び出し、状態の更新を要求する。

### `AiAppView`
- **所属層:** UI層
- **概要:** AI関連の情報を表示するためのUIウィジェット。
- **主要メソッド:**
  - `build(context)`: `StateManagement`から現在のAI関連UI状態 (`aiUiState`) を取得し、それに基づいてUIを描画する（例: アイコンの表示/非表示を切り替える）。
