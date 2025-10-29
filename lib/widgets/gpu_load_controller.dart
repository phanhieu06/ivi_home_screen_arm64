import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Providerをインポート
import 'package:ivi_home_screen/app_state.dart'; // AppStateをインポート
import 'package:ivi_home_screen/ipc/ipc_manager.dart'; // IpcManagerをインポート
import 'package:ivi_home_screen/ipc/ipc_commands.dart'; // IPCコマンドをインポート

// GPU負荷を制御するためのUI Widget
class GpuLoadController extends StatefulWidget {
  const GpuLoadController({super.key});

  @override
  State<GpuLoadController> createState() => _GpuLoadControllerState();
}

class _GpuLoadControllerState extends State<GpuLoadController> {
  int _gpuLoad = 0; // GPU負荷の現在の値 (0-100%)

  // 負荷を増減させる汎用関数
  void _changeLoad(int amount) {
    setState(() {
      _gpuLoad = (_gpuLoad + amount).clamp(0, 100);
      // AI AppへGPU負荷設定コマンドを送信
      Provider.of<IpcManager>(context, listen: false)
          .sendMessage(CMD_SET_GPU_LOAD, _gpuLoad.toString());
      // AppStateのGPU負荷も更新（UI表示のため）
      Provider.of<AppState>(context, listen: false).setGpuLoad(_gpuLoad);
    });
  }

  @override
  Widget build(BuildContext context) {
    // AppStateから現在のGPU負荷を取得して表示
    final appState = Provider.of<AppState>(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // -10ボタン
          TextButton(
            onPressed: () => _changeLoad(-10),
            child: const Text('-10', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          // -1ボタン
          IconButton(
            icon: const Icon(Icons.remove, color: Colors.white),
            onPressed: () => _changeLoad(-1),
          ),
          // 現在の負荷を表示するテキスト（固定幅）
          Container(
            width: 160.0, // 固定幅を指定してレイアウトのズレを防ぐ
            alignment: Alignment.center,
            child: Text(
              'GPU: ${appState.gpuLoad}%',
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          // +1ボタン
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _changeLoad(1),
          ),
          // +10ボタン
          TextButton(
            onPressed: () => _changeLoad(10),
            child: const Text('+10', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ],
      ),
    );
  }
}