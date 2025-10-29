
import 'package:flutter/material.dart';

// 右側パネルWidget
// 地図情報を表示します
class RightPanel extends StatelessWidget {
  const RightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5, // 画面の幅の5割を占める
      child: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 66.0, right: 24.0),
            child: FractionallySizedBox(
              heightFactor: 0.8, // 高さを80%に制限
              child: Image.asset('assets/images/Map.png', fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}
