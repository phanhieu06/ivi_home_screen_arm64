// ipc_manager.dart
// IPC通信を管理するクラス

import 'dart:io';
import 'dart:typed_data';
import 'dart:async'; // Completerのためにインポート

import 'package:flutter/foundation.dart';

import 'ipc_commands.dart';
import 'ipc_message.dart';

class IpcManager with ChangeNotifier {
  static const String _aiAppHost = '127.0.0.1'; // AI Appのホスト
  static const int _aiAppPort = 8081; // AI Appのポート (IVI App -> AI App)
  static const int _iviAppPort = 8082; // IVI Appのポート (AI App -> IVI App)

  ServerSocket? _serverSocket; // IVI AppがAI Appからのデータを受信するためのサーバーソケット
  Socket? _clientSocket; // IVI AppがAI Appへデータを送信するためのクライアントソケット

  // AI Appから受信したデータを処理するためのコールバック
  Function(IpcMessage)? onMessageReceived;

  // 受信バッファと期待されるメッセージサイズ
  BytesBuilder _receiveBuffer = BytesBuilder();
  int _expectedMessageSize = 0;

  // 初期化処理
  Future<void> initialize() async {
    await _startServer();
    await _connectToAiApp();
  }

  // IVI Appサーバーを開始 (AI Appからメッセージを受信するため)
  Future<void> _startServer() async {
    try {
      _serverSocket = await ServerSocket.bind(_aiAppHost, _iviAppPort);
      _serverSocket!.listen(_handleClientConnection);
      debugPrint('IVI App Server started on $_aiAppHost:$_iviAppPort');
    } catch (e) {
      debugPrint('Failed to start IVI App Server: $e');
    }
  }

  // AI Appからの接続を処理
  void _handleClientConnection(Socket client) {
    debugPrint('AI App connected to IVI App Server: ${client.remoteAddress.address}:${client.remotePort}');
    client.listen(
      (Uint8List data) {
        _processReceivedData(data); // 受信データを処理
      },
      onDone: () {
        debugPrint('AI App disconnected from IVI App Server');
        client.destroy();
      },
      onError: (error) {
        debugPrint('Error on IVI App Server client: $error');
        client.destroy();
      },
    );
  }

  // AI Appに接続 (AI Appへメッセージを送信するため)
  Future<void> _connectToAiApp() async {
    // 既に接続済みの場合は再接続しない
    if (_clientSocket != null) {
      debugPrint('Already connected to AI App.');
      return;
    }

    try {
      _clientSocket = await Socket.connect(_aiAppHost, _aiAppPort);
      debugPrint('Connected to AI App on $_aiAppHost:$_aiAppPort');
      _clientSocket!.listen(
        (Uint8List data) {
          // AI Appからの応答を処理（必要であれば）
          debugPrint('Received response from AI App on client socket: ${String.fromCharCodes(data)}');
        },
        onDone: () {
          debugPrint('Disconnected from AI App (client socket)');
          _clientSocket!.destroy();
          _clientSocket = null;
        },
        onError: (error) {
          debugPrint('Error connecting to AI App (client socket): $error');
          _clientSocket!.destroy();
          _clientSocket = null;
        },
      );
    } catch (e) {
      debugPrint('Failed to connect to AI App: $e');
      // 接続失敗時は、一定時間後に再試行するロジックを追加することも可能
      // 例: Future.delayed(Duration(seconds: 5), _connectToAiApp);
    }
  }

  // 受信したバイトデータをIPCメッセージに変換して処理
  void _processReceivedData(Uint8List data) {
    _receiveBuffer.add(data);

    while (true) {
      final currentBytes = _receiveBuffer.toBytes(); // 現在のバッファの内容を取得

      // ヘッダーを読み込むのに十分なデータがあるか確認
      if (currentBytes.length < IPC_HEADER_SIZE) {
        break; // ヘッダーが不完全なので、さらにデータを受信するまで待機
      }

      // 期待されるメッセージサイズがまだ設定されていない場合、ヘッダーから読み込む
      if (_expectedMessageSize == 0) {
        final ByteData headerData = currentBytes.buffer.asByteData(0, IPC_HEADER_SIZE);
        _expectedMessageSize = headerData.getUint32(0, Endian.little); // メッセージサイズは最初の4バイト

        // 期待されるメッセージサイズがヘッダーサイズより小さい場合は不正なデータ
        if (_expectedMessageSize < IPC_HEADER_SIZE) {
          debugPrint('Error: Invalid message size in header: $_expectedMessageSize');
          _receiveBuffer.clear(); // バッファをクリアしてリセット
          _expectedMessageSize = 0;
          break;
        }
      }

      // 完全なメッセージを受信するのに十分なデータがあるか確認
      if (currentBytes.length >= _expectedMessageSize) {
        final Uint8List fullMessageBytes = currentBytes.sublist(0, _expectedMessageSize);
        final Uint8List remainingBytes = currentBytes.sublist(_expectedMessageSize);

        try {
          final message = IpcMessage.fromBytes(fullMessageBytes);
          debugPrint('Received IPC Message: MsgId=${message.msgId}, Payload=${message.stringPayload}');
          onMessageReceived?.call(message);
          notifyListeners(); // UI更新を通知
        } catch (e) {
          debugPrint('Failed to process received data: $e');
        }

        // 処理済みのメッセージ部分をバッファから削除し、残りのデータを新しいバッファに設定
        _receiveBuffer = BytesBuilder();
        _receiveBuffer.add(remainingBytes);
        _expectedMessageSize = 0; // 期待されるメッセージサイズをリセット

        // 残りのデータがなければループを終了
        if (remainingBytes.isEmpty) {
          break;
        }
      } else {
        break; // 完全なメッセージがまだ受信されていないので、さらにデータを受信するまで待機
      }
    }
  }

  // AI AppへIPCメッセージを送信
  void sendMessage(int msgId, [String? stringPayload]) {
    if (_clientSocket == null) {
      debugPrint('Not connected to AI App. Message not sent.');
      return;
    }
    final message = IpcMessage.fromCommandAndStringPayload(msgId, stringPayload);
    _clientSocket!.add(message.toBytes());
    debugPrint('Sent IPC Message: MsgId=${message.msgId}, Payload=${message.stringPayload}');
  }

  // リソース解放
  void dispose() {
    _serverSocket?.close();
    _clientSocket?.destroy();
    super.dispose();
  }
}