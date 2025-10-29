// ipc_commands.dart
// IVI App <-> AI App間のIPCコマンド定義

// AI App -> IVI App (表示データ用コマンド)
const int CMD_UPDATE_UI_GESTURE_INFO = 0x0001; // ジェスチャー情報更新
const int CMD_UPDATE_UI_EMOTION_INFO = 0x0002; // 感情情報更新
const int CMD_UPDATE_UI_FACE_DIRECTION = 0x0003; // 顔向き情報更新
const int CMD_UPDATE_UI_IMAGE_RESPONSE = 0x0004; // カメラ画像応答

// IVI App -> AI App (負荷制御用コマンド)
const int CMD_SET_CPU_LOAD = 0x1001; // CPU負荷設定
const int CMD_SET_GPU_LOAD = 0x1002; // GPU負荷設定
const int CMD_REQUEST_IMAGE = 0x1003; // カメラ画像要求
const int CMD_CHANGE_GESTURE_TARGET = 0x1004; // ジェスチャー対象変更
const int CMD_CHANGE_IN_CAM = 0x1005; // 内部カメラ切り替え
