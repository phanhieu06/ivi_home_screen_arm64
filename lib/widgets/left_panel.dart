
import 'package:flutter/material.dart';
import 'package:ivi_home_screen/widgets/ai_app_placeholder.dart';

// 左側パネルWidget
// 車の画像を表示します
class LeftPanel extends StatelessWidget {
  const LeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5, // 画面の幅の5割を占める
      child: Container(
        child: Center(
          child: Stack(
            alignment: Alignment.center, // Stack内の要素を中央揃えにする
            children: <Widget>[
              // 既存の車の画像
              Padding(
                padding: const EdgeInsets.only(top: 160.0), // パディングを増やしてさらに下に移動
                child: Transform.scale(
                  scale: 1.2, // 120%に拡大
                  child: Image.asset('assets/images/Car.png', fit: BoxFit.contain),
                ),
              ),
              // AI Appのプレースホルダーフレーム
              Positioned(
                top: 0.0, // 最上部に配置
                left: 0,    // 左端に揃える
                right: 0,   // 右端に揃える (これにより水平方向の中央に配置される)
                child: AiAppPlaceholder(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
