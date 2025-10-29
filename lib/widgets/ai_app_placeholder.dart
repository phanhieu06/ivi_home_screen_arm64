import 'package:flutter/material.dart';

// AI AppのプレースホルダーWidget
class AiAppPlaceholder extends StatelessWidget {
  const AiAppPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox( // Use FractionallySizedBox for responsive width
      widthFactor: 0.9, // 90% of the available width
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 2),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(0.6),
        ),
        child: const Center(
          child: Text(
            'AI App Placeholder',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
