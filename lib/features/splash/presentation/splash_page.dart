import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/app_title.dart';
import '../../../core/ui/rounded_progress_bar.dart';
import '../../../core/ui/test_env.dart';
import '../domain/splash_icons.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, this.onFinished, this.loadDuration});

  final VoidCallback? onFinished;

  /// Override for tests. Device launches use about 2 seconds.
  final Duration? loadDuration;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _bob;
  late final AnimationController _swap;
  late final AnimationController _entrance;
  late final AnimationController _progress;
  late final int _seed = DateTime.now().microsecondsSinceEpoch;
  var _left = false;

  Duration get _loadDuration {
    if (widget.loadDuration != null) return widget.loadDuration!;
    return isFlutterTest
        ? const Duration(milliseconds: 500)
        : const Duration(seconds: 2);
  }

  @override
  void initState() {
    super.initState();
    _bob = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _swap = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (isFlutterTest) {
      _bob.value = 0.4;
      _swap.value = 0.35;
      _entrance.value = 1;
    } else {
      _bob.repeat(reverse: true);
      _swap.repeat(reverse: true);
      _entrance.forward();
    }
    _progress = AnimationController(vsync: this, duration: _loadDuration);
    _progress.addStatusListener((status) {
      if (status == AnimationStatus.completed) _finish();
    });
    _progress.forward();
  }

  void _finish() {
    if (!mounted || _left) return;
    _left = true;
    final done = widget.onFinished;
    if (done != null) {
      done();
      return;
    }
    GoRouter.maybeOf(context)?.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _bob.dispose();
    _swap.dispose();
    _entrance.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('splash_page'),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB388FF), Color(0xFF7C4DFF), Color(0xFF5B2FD6)],
          ),
        ),
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _bob,
            _swap,
            _entrance,
            _progress,
          ]),
          builder: (context, _) {
            return Stack(
              children: [
                _Bubbles(t: _bob.value),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
                    child: Column(
                      children: [
                        Transform.translate(
                          offset: Offset(0, -8 * _bob.value),
                          child: const AppTitle(),
                        ),
                        const Spacer(),
                        SplashHeroArt(
                          swapT: _swap.value,
                          bobT: _bob.value,
                          entranceT: Curves.elasticOut.transform(_entrance.value),
                          launchSeed: _seed,
                        ),
                        const Spacer(),
                        Text(
                          '${(_progress.value * 100).round()}%',
                          key: const Key('splash_percent'),
                          style: const TextStyle(
                            fontFamily: AppTheme.displayFamily,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RoundedProgressBar(
                          key: const Key('splash_progress'),
                          value: _progress.value,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Loading fun...',
                          style: TextStyle(
                            fontFamily: AppTheme.displayFamily,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Cross-fades between the two splash PNGs with a gentle bounce.
class SplashHeroArt extends StatelessWidget {
  const SplashHeroArt({
    super.key,
    required this.swapT,
    required this.bobT,
    required this.entranceT,
    required this.launchSeed,
  });

  final double swapT;
  final double bobT;
  final double entranceT;
  final int launchSeed;

  @override
  Widget build(BuildContext context) {
    final start = SplashIcons.launchFrameIndex(launchSeed);
    final other = (start + 1) % SplashIcons.paths.length;
    final bobScale = 1 + 0.045 * math.sin(bobT * math.pi);
    final scale = (0.82 + 0.18 * entranceT) * bobScale;
    final wobble = math.sin(bobT * math.pi) * 0.04;

    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle: wobble,
        child: SizedBox(
          key: const Key('splash_owl'),
          width: 240,
          height: 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _SplashPng(
                asset: SplashIcons.paths[start],
                opacity: 1 - swapT,
                imageKey: const Key('splash_icon_a'),
              ),
              _SplashPng(
                asset: SplashIcons.paths[other],
                opacity: swapT,
                imageKey: const Key('splash_icon_b'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashPng extends StatelessWidget {
  const _SplashPng({
    required this.asset,
    required this.opacity,
    required this.imageKey,
  });

  final String asset;
  final double opacity;
  final Key imageKey;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0, 1),
      child: Image.asset(
        asset,
        key: imageKey,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

class _Bubbles extends StatelessWidget {
  const _Bubbles({required this.t});

  final double t;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BubblePainter(t),
      child: const SizedBox.expand(),
    );
  }
}

class _BubblePainter extends CustomPainter {
  _BubblePainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.18);
    for (var i = 0; i < 8; i++) {
      final x = size.width * ((i * 0.17 + 0.08) % 1);
      final y = size.height * ((0.15 + i * 0.11 + t * 0.04) % 1);
      canvas.drawCircle(Offset(x, y), 10 + (i % 4) * 6, paint);
    }
  }

  @override
  bool shouldRepaint(_BubblePainter oldDelegate) => oldDelegate.t != t;
}
