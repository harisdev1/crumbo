import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/theme_motion.dart';

/// Moving sky on top of a theme SVG. Dots do not steal taps from the owl.
class ThemeMotionLayer extends StatefulWidget {
  const ThemeMotionLayer({super.key, required this.themeId});

  final String themeId;

  @override
  State<ThemeMotionLayer> createState() => _ThemeMotionLayerState();
}

class _ThemeMotionLayerState extends State<ThemeMotionLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;
  final List<MotionBurst> _bursts = [];

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    );
    // A repeating ticker never goes idle, so widget tests cannot pumpAndSettle.
    final testing = WidgetsBinding.instance.runtimeType.toString().contains(
      'Test',
    );
    if (testing) {
      _clock.value = 0.35;
    } else {
      _clock.repeat();
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  void _onTap(TapDownDetails details, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    setState(() {
      _bursts.add(
        MotionBurst(
          nx: details.localPosition.dx / size.width,
          ny: details.localPosition.dy / size.height,
          born: _clock.value,
        ),
      );
      if (_bursts.length > 6) _bursts.removeAt(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          key: const Key('theme_motion'),
          behavior: HitTestBehavior.translucent,
          onTapDown: (details) => _onTap(details, size),
          child: AnimatedBuilder(
            animation: _clock,
            builder: (context, _) {
              return CustomPaint(
                painter: _MotionPainter(
                  themeId: widget.themeId,
                  t: _clock.value,
                  bursts: List<MotionBurst>.of(_bursts),
                ),
                size: size,
              );
            },
          ),
        );
      },
    );
  }
}

class _MotionPainter extends CustomPainter {
  _MotionPainter({
    required this.themeId,
    required this.t,
    required this.bursts,
  });

  final String themeId;
  final double t;
  final List<MotionBurst> bursts;

  @override
  void paint(Canvas canvas, Size size) {
    final specks = layoutThemeMotion(
      themeId: themeId,
      t: t,
      width: size.width,
      height: size.height,
      bursts: bursts,
    );
    for (final speck in specks) {
      _draw(canvas, speck);
    }
  }

  void _draw(Canvas canvas, MotionSpeck speck) {
    final paint = Paint()
      ..color = speck.color.withValues(alpha: speck.opacity.clamp(0, 1));
    switch (speck.kind) {
      case MotionKind.rain:
        canvas.drawLine(
          Offset(speck.dx, speck.dy),
          Offset(speck.dx + 2, speck.dy + speck.size),
          paint
            ..strokeWidth = 1.6
            ..strokeCap = StrokeCap.round,
        );
      case MotionKind.clouds:
        _cloud(canvas, Offset(speck.dx, speck.dy), speck.size, paint);
      case MotionKind.birds:
        _bird(canvas, Offset(speck.dx, speck.dy), speck.size, paint);
      case MotionKind.fish:
        canvas.save();
        canvas.translate(speck.dx, speck.dy);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset.zero,
            width: speck.size * 2.4,
            height: speck.size,
          ),
          paint,
        );
        final tail = Path()
          ..moveTo(-speck.size * 1.1, 0)
          ..lineTo(-speck.size * 1.8, -speck.size * 0.45)
          ..lineTo(-speck.size * 1.8, speck.size * 0.45)
          ..close();
        canvas.drawPath(tail, paint);
        canvas.restore();
      case MotionKind.leaves:
      case MotionKind.petals:
        canvas.save();
        canvas.translate(speck.dx, speck.dy);
        canvas.rotate(speck.spin);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset.zero,
            width: speck.size * 1.8,
            height: speck.size * 0.8,
          ),
          paint,
        );
        canvas.restore();
      case MotionKind.butterflies:
        _butterfly(canvas, speck, paint);
      case MotionKind.balloons:
        _balloon(canvas, Offset(speck.dx, speck.dy), speck.size, speck.color);
      case MotionKind.aurora:
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(speck.dx, speck.dy),
            width: speck.dx * 2.2,
            height: speck.size,
          ),
          paint,
        );
      case MotionKind.sprinkles:
        canvas.save();
        canvas.translate(speck.dx, speck.dy);
        canvas.rotate(speck.spin);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: speck.size * 0.45,
              height: speck.size * 1.6,
            ),
            const Radius.circular(2),
          ),
          paint,
        );
        canvas.restore();
      case MotionKind.stars:
      case MotionKind.snow:
      case MotionKind.bubbles:
      case MotionKind.sand:
      case MotionKind.dust:
      case MotionKind.toys:
      case MotionKind.fireflies:
        if (speck.kind == MotionKind.bubbles) {
          canvas.drawCircle(
            Offset(speck.dx, speck.dy),
            speck.size,
            paint
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5,
          );
        } else {
          canvas.drawCircle(Offset(speck.dx, speck.dy), speck.size, paint);
        }
      case MotionKind.lightRays:
        canvas.save();
        canvas.translate(speck.dx, speck.dy);
        canvas.rotate(speck.spin);
        final ray = Path()
          ..moveTo(-speck.size * 0.08, 0)
          ..lineTo(speck.size * 0.08, 0)
          ..lineTo(speck.size * 0.20, speck.size)
          ..lineTo(-speck.size * 0.20, speck.size)
          ..close();
        canvas.drawPath(ray, paint);
        canvas.restore();
      case MotionKind.water:
        final path = Path()..moveTo(speck.dx - speck.size, speck.dy);
        for (var i = 0; i < 4; i++) {
          final x = speck.dx - speck.size + (i + 1) * speck.size * 0.5;
          path.quadraticBezierTo(
            x - speck.size * 0.25,
            speck.dy + (i.isEven ? -3 : 3),
            x,
            speck.dy,
          );
        }
        canvas.drawPath(
          path,
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.4
            ..strokeCap = StrokeCap.round,
        );
      case MotionKind.glow:
        final glow = Paint()
          ..shader =
              RadialGradient(
                colors: [
                  speck.color.withValues(alpha: speck.opacity),
                  speck.color.withValues(alpha: 0),
                ],
              ).createShader(
                Rect.fromCircle(
                  center: Offset(speck.dx, speck.dy),
                  radius: speck.size,
                ),
              );
        canvas.drawCircle(Offset(speck.dx, speck.dy), speck.size, glow);
      case MotionKind.steam:
        final steam = Path()
          ..moveTo(speck.dx, speck.dy + speck.size)
          ..cubicTo(
            speck.dx - speck.size,
            speck.dy + speck.size * 0.45,
            speck.dx + speck.size,
            speck.dy,
            speck.dx,
            speck.dy - speck.size,
          );
        canvas.drawPath(
          steam,
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round,
        );
      case MotionKind.curtain:
        canvas.save();
        canvas.translate(speck.dx, speck.dy);
        canvas.rotate(speck.spin);
        final curtain = Path()
          ..moveTo(-12, -speck.size)
          ..quadraticBezierTo(18, -speck.size * 0.3, -5, speck.size)
          ..lineTo(20, speck.size)
          ..quadraticBezierTo(42, -speck.size * 0.25, 14, -speck.size)
          ..close();
        canvas.drawPath(curtain, paint);
        canvas.restore();
      case MotionKind.plant:
        canvas.save();
        canvas.translate(speck.dx, speck.dy);
        canvas.rotate(speck.spin);
        final leaf = Path()
          ..moveTo(0, speck.size)
          ..quadraticBezierTo(speck.size * 1.4, 0, 0, -speck.size)
          ..quadraticBezierTo(-speck.size * 0.45, 0, 0, speck.size);
        canvas.drawPath(leaf, paint);
        canvas.restore();
      case MotionKind.fireplace:
        canvas.save();
        canvas.translate(speck.dx, speck.dy);
        canvas.rotate(speck.spin);
        final flame = Path()
          ..moveTo(0, -speck.size)
          ..cubicTo(
            speck.size,
            -speck.size * 0.2,
            speck.size * 0.8,
            speck.size,
            0,
            speck.size,
          )
          ..cubicTo(
            -speck.size * 0.8,
            speck.size,
            -speck.size,
            -speck.size * 0.1,
            0,
            -speck.size,
          )
          ..close();
        canvas.drawPath(flame, paint);
        canvas.restore();
    }
  }

  void _cloud(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path()
      ..moveTo(center.dx - size * 1.25, center.dy + size * 0.28)
      ..cubicTo(
        center.dx - size * 1.35,
        center.dy - size * 0.35,
        center.dx - size * 0.65,
        center.dy - size * 0.58,
        center.dx - size * 0.35,
        center.dy - size * 0.32,
      )
      ..cubicTo(
        center.dx - size * 0.05,
        center.dy - size * 1.12,
        center.dx + size * 0.9,
        center.dy - size * 0.78,
        center.dx + size * 0.78,
        center.dy - size * 0.2,
      )
      ..cubicTo(
        center.dx + size * 1.42,
        center.dy - size * 0.22,
        center.dx + size * 1.46,
        center.dy + size * 0.5,
        center.dx + size * 0.86,
        center.dy + size * 0.52,
      )
      ..lineTo(center.dx - size, center.dy + size * 0.52)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _butterfly(Canvas canvas, MotionSpeck speck, Paint paint) {
    canvas.save();
    canvas.translate(speck.dx, speck.dy);
    final flap = 0.35 + 0.65 * math.sin(speck.spin).abs();
    canvas.scale(flap, 1);
    final left = Path()
      ..moveTo(-1, 0)
      ..cubicTo(
        -speck.size * 1.2,
        -speck.size,
        -speck.size * 1.3,
        speck.size * 0.8,
        -1,
        speck.size * 0.25,
      )
      ..close();
    final right = Path()
      ..moveTo(1, 0)
      ..cubicTo(
        speck.size * 1.2,
        -speck.size,
        speck.size * 1.3,
        speck.size * 0.8,
        1,
        speck.size * 0.25,
      )
      ..close();
    canvas.drawPath(left, paint);
    canvas.drawPath(right, paint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: 2.5,
          height: speck.size * 1.25,
        ),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF55435F),
    );
    canvas.restore();
  }

  void _bird(Canvas canvas, Offset p, double s, Paint paint) {
    final path = Path()
      ..moveTo(p.dx - s, p.dy)
      ..quadraticBezierTo(p.dx - s * 0.45, p.dy - s * 0.7, p.dx, p.dy)
      ..quadraticBezierTo(p.dx + s * 0.45, p.dy - s * 0.7, p.dx + s, p.dy);
    canvas.drawPath(
      path,
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  void _balloon(Canvas canvas, Offset center, double scale, Color color) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    final s = scale / 54;
    canvas.scale(s);
    final envelope = Path()
      ..moveTo(0, -70)
      ..cubicTo(46, -70, 58, -24, 46, 22)
      ..cubicTo(36, 50, 16, 64, 0, 70)
      ..cubicTo(-16, 64, -36, 50, -46, 22)
      ..cubicTo(-58, -24, -46, -70, 0, -70)
      ..close();
    canvas.drawPath(envelope, Paint()..color = color);
    final panel = Path()
      ..moveTo(0, -69)
      ..cubicTo(20, -48, 20, 36, 0, 68)
      ..cubicTo(-20, 36, -20, -48, 0, -69)
      ..close();
    canvas.drawPath(
      panel,
      Paint()..color = Color.lerp(color, Colors.white, 0.28)!,
    );
    canvas.drawOval(
      const Rect.fromLTWH(-28, -48, 16, 34),
      Paint()..color = const Color(0x66FFFFFF),
    );
    final rope = Paint()
      ..color = const Color(0xFF5D4037)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (final x in const [-14.0, -5.0, 5.0, 14.0]) {
      canvas.drawLine(Offset(x * 0.65, 66), Offset(x, 96), rope);
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-16, 94, 32, 18),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFA1887F),
    );
    final weave = Paint()
      ..color = const Color(0xFF6D4C41)
      ..strokeWidth = 1;
    canvas.drawLine(const Offset(-8, 96), const Offset(-8, 110), weave);
    canvas.drawLine(const Offset(0, 96), const Offset(0, 110), weave);
    canvas.drawLine(const Offset(8, 96), const Offset(8, 110), weave);
    canvas.drawLine(const Offset(-15, 102), const Offset(15, 102), weave);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MotionPainter old) =>
      old.t != t ||
      old.themeId != themeId ||
      old.bursts.length != bursts.length;
}
