// app_state.dart
// アプリケーションの状態を管理するクラス

import 'dart:convert'; // JSONデコードのためにインポート
import 'package:flutter/foundation.dart';
import 'package:ivi_home_screen/ipc/ipc_message.dart';
import 'package:ivi_home_screen/ipc/ipc_commands.dart'; // IPCコマンドをインポート

class AppState with ChangeNotifier {
  // 現在のCPU負荷率
  int _cpuLoad = 0;
  int get cpuLoad => _cpuLoad;

  // 現在のGPU負荷率
  int _gpuLoad = 0;
  int get gpuLoad => _gpuLoad;

  // AI Appから受信した最新のメッセージ
  IpcMessage? _latestIpcMessage;
  IpcMessage? get latestIpcMessage => _latestIpcMessage;

  // 最新のジェスチャー情報
  String _latestGestureInfo = "なし"; // 例: "pointing: left", "brush: detected"
  String get latestGestureInfo => _latestGestureInfo;

  // 最新の感情情報
  String _latestEmotionInfo = "なし"; // 例: "happy", "sad"
  String get latestEmotionInfo => _latestEmotionInfo;

  // CPU負荷率を更新
  void setCpuLoad(int load) {
    if (_cpuLoad != load) {
      _cpuLoad = load;
      notifyListeners(); // 変更をリスナーに通知
    }
  }

  // GPU負荷率を更新
  void setGpuLoad(int load) {
    if (_gpuLoad != load) {
      _gpuLoad = load;
      notifyListeners(); // 変更をリスナーに通知
    }
  }

  // AI AppからのIPCメッセージを処理
  void handleIpcMessage(IpcMessage message) {
    _latestIpcMessage = message; // 最新のメッセージを保存

    // メッセージの種類に応じて状態を更新
    switch (message.msgId) {
      case CMD_UPDATE_UI_GESTURE_INFO:
        // ジェスチャー情報を受信
        if (message.stringPayload != null) {
          try {
            final Map<String, dynamic> gestureData = jsonDecode(message.stringPayload!); // JSON文字列をデコード
            _latestGestureInfo = "Pointing: ${gestureData['direction'] ?? 'N/A'}, ImageID: ${gestureData['image_id'] ?? 'N/A'}";
          } catch (e) {
            _latestGestureInfo = "Gesture Info Error: $e";
          }
        } else {
          _latestGestureInfo = "Pointing: No payload";
        }
        break;
      case CMD_UPDATE_UI_EMOTION_INFO:
        // 感情情報を受信
        if (message.stringPayload != null) {
          try {
            final Map<String, dynamic> emotionData = jsonDecode(message.stringPayload!); // JSON文字列をデコード
            _latestEmotionInfo = "Emotion: ${emotionData['emotion'] ?? 'N/A'}, Camera: ${emotionData['camera_type'] ?? 'N/A'}";
          } catch (e) {
            _latestEmotionInfo = "Emotion Info Error: $e";
          }
        } else {
          _latestEmotionInfo = "Emotion: No payload";
        }
        break;
      // 他のコマンドもここに追加
      default:
        debugPrint("Unknown IPC Command Received: ${message.msgId}");
        break;
    }

    notifyListeners(); // 変更をリスナーに通知
  }
}