// ipc_message.dart
// IVI App <-> AI App間のIPCメッセージ構造

import 'dart:convert';
import 'dart:typed_data';

// ヘッダーのサイズを定義 (msgSize: 4バイト, msgId: 4バイト)
const int IPC_HEADER_SIZE = 8;

class IpcMessage {
  final int msgSize; // 全体のメッセージサイズ (バイト単位)
  final int msgId;   // メッセージID (コマンドID)
  final Uint8List payload; // ペイロードデータ

  IpcMessage({
    required this.msgSize,
    required this.msgId,
    required this.payload,
  });

  // IpcMessageをバイトデータに変換
  Uint8List toBytes() {
    final ByteData headerData = ByteData(IPC_HEADER_SIZE);
    headerData.setUint32(0, msgSize, Endian.little); // メッセージサイズをリトルエンディアンで設定
    headerData.setUint32(4, msgId, Endian.little);   // メッセージIDをリトルエンディアンで設定

    final Uint8List fullMessage = Uint8List(msgSize);
    fullMessage.setAll(0, headerData.buffer.asUint8List()); // ヘッダーを先頭に配置
    fullMessage.setAll(IPC_HEADER_SIZE, payload); // ペイロードをヘッダーの後に配置
    return fullMessage;
  }

  // バイトデータからIpcMessageを再構築
  factory IpcMessage.fromBytes(Uint8List bytes) {
    // 受信データがヘッダーサイズより短い場合はエラー
    if (bytes.length < IPC_HEADER_SIZE) {
      throw FormatException('Received data is too short to contain a valid IPC header.');
    }

    final ByteData headerData = bytes.buffer.asByteData(0, IPC_HEADER_SIZE);
    final int msgSize = headerData.getUint32(0, Endian.little); // メッセージサイズをリトルエンディアンで取得
    final int msgId = headerData.getUint32(4, Endian.little);   // メッセージIDをリトルエンディアンで取得

    // 受信データの長さがヘッダーで示されたメッセージサイズより短い場合はエラー
    if (bytes.length < msgSize) {
      throw FormatException('Received data length (${bytes.length}) is less than indicated msgSize ($msgSize).');
    }

    // ペイロード部分を抽出
    final Uint8List payload = bytes.sublist(IPC_HEADER_SIZE, msgSize);

    return IpcMessage(
      msgSize: msgSize,
      msgId: msgId,
      payload: payload,
    );
  }

  // コマンドと文字列ペイロードからIpcMessageを作成するヘルパー
  factory IpcMessage.fromCommandAndStringPayload(int msgId, String? stringPayload) {
    final Uint8List payloadBytes = stringPayload != null ? Uint8List.fromList(utf8.encode(stringPayload)) : Uint8List(0);
    final int msgSize = IPC_HEADER_SIZE + payloadBytes.length;
    return IpcMessage(msgSize: msgSize, msgId: msgId, payload: payloadBytes);
  }

  // ペイロードを文字列として取得するヘルパー
  String? get stringPayload {
    if (payload.isEmpty) return null;
    return utf8.decode(payload);
  }
}
