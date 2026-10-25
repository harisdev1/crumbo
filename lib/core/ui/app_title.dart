import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key, this.fontSize = 42});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _OutlineWord(text: 'TALKING', fontSize: fontSize),
        _OutlineWord(text: 'OWL', fontSize: fontSize * 1.12),
      ],
    );
  }
}

class _OutlineWord extends StatelessWidget {
  const _OutlineWord({required this.text, required this.fontSize});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final fill = TextStyle(
      fontFamily: AppTheme.displayFamily,
      fontSize: fontSize,
      height: 0.95,
      color: GameColors.purple,
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          text,
          style: fill.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = fontSize * 0.1
              ..color = Colors.white,
          ),
        ),
        Text(text, style: fill),
      ],
    );
  }
}
