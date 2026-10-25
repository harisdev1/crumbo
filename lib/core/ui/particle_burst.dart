import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// One-shot confetti used on the level-up screen.
class ParticleBurst extends StatefulWidget {
  const ParticleBurst({super.key});

  @override
  State<ParticleBurst> createState() => _ParticleBurstState();
}

class _ParticleBurstState extends State<ParticleBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _ParticlePainter(_controller.value),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter(this.t);

  final double t;

  static const _colors = <Color>[
    GameColors.purple,
    GameColors.pink,
    GameColors.coin,
    GameColors.green,
    Color(0xFF42A5F5),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final reach = size.shortestSide * 0.46 * t;
    final fade = (1 - t).clamp(0.0, 1.0);
    for (var i = 0; i < 18; i++) {
      final angle = (i / 18) * math.pi * 2;
      final dist = reach * (0.55 + (i % 3) * 0.18);
      final pos = center + Offset(math.cos(angle), math.sin(angle)) * dist;
      final paint = Paint()
        ..color = _colors[i % _colors.length].withValues(alpha: fade);
      canvas.drawCircle(pos, 3.5 + (i % 4), paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => oldDelegate.t != t;
}
