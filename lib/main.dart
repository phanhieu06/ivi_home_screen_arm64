import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Providerをインポート

import 'package:ivi_home_screen/widgets/cpu_load_controller.dart';
import 'package:ivi_home_screen/widgets/gpu_load_controller.dart';
import 'package:ivi_home_screen/widgets/left_panel.dart';
import 'package:ivi_home_screen/widgets/right_panel.dart';

import 'package:ivi_home_screen/app_state.dart'; // AppStateをインポート
import 'package:ivi_home_screen/ipc/ipc_manager.dart'; // IpcManagerをインポート

// アプリケーションのエントリーポイント
// アプリケーションを起動します
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => IpcManager()),
      ],
      child: const IviApp(),
    ),
  );
}

// アプリケーションのルートWidget
// マテリアルデザインの基本的な設定を行います
class IviApp extends StatefulWidget {
  const IviApp({super.key});

  @override
  State<IviApp> createState() => _IviAppState();
}

class _IviAppState extends State<IviApp> {
  @override
  void initState() {
    super.initState();
    // IpcManagerを初期化し、メッセージ受信時のコールバックを設定
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ipcManager = Provider.of<IpcManager>(context, listen: false);
      final appState = Provider.of<AppState>(context, listen: false);

      ipcManager.initialize();
      ipcManager.onMessageReceived = (message) {
        appState.handleIpcMessage(message);
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IVI Home Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark, // ダークテーマを強制
      ),
      debugShowCheckedModeBanner: false, // デバッグバナーを非表示
      home: const HomeScreen(),
    );
  }
}

// ホーム画面のWidget
// アプリケーションのメインUIを構築します
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // UIの骨格
    return Scaffold(
      backgroundColor: Colors.black, // 背景を黒に設定
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // 背景画像
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          // メインコンテンツのレイアウト
          const Column(
            children: <Widget>[
              // 1. 中央のパネル（左右分割）
              Expanded(
                child: Row(
                  children: <Widget>[
                    // 左側パネル
                    LeftPanel(),
                    // 右側パネル
                    RightPanel(),
                  ],
                ),
              ),
            ],
          ),

          // GPU負荷コントローラー (左下)
          const Positioned(
            bottom: 20.0, // 下からの距離
            left: 20.0,   // 左からの距離
            child: GpuLoadController(),
          ),

          // CPU負荷コントローラー (右下)
          const Positioned(
            bottom: 20.0, // 下からの距離
            right: 20.0,  // 右からの距離
            child: CpuLoadController(),
          ),

          // AI Appからの受信情報表示 (右上)
          Positioned(
            top: 20.0, // 上からの距離
            right: 20.0, // 右からの距離
            child: Consumer<AppState>(
              builder: (context, appState, child) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '最新ジェスチャー: ${appState.latestGestureInfo}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        '最新感情: ${appState.latestEmotionInfo}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      // デバッグ用に最新のIPCメッセージを表示
                      Text(
                        '最新IPCメッセージ: ${appState.latestIpcMessage?.msgId ?? 'なし'}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
