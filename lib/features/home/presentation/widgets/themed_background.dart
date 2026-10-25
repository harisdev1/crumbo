import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/home_theme.dart';
import '../../domain/scene_anchor.dart';
import '../cubit/home_theme_cubit.dart';
import 'theme_motion_layer.dart';

/// Full-screen SVG background with animated crossfade + soft zoom on switch.
class ThemedBackground extends StatelessWidget {
  const ThemedBackground({super.key});

  static const _duration = Duration(milliseconds: 700);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeThemeCubit, HomeThemeState>(
      buildWhen: (p, n) => p.activeThemeId != n.activeThemeId,
      builder: (context, state) {
        final theme = context.read<HomeThemeCubit>().activeTheme;
        return AnimatedSwitcher(
          duration: _duration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final fade = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );
            final scale = Tween<double>(begin: 1.04, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return FadeTransition(
              opacity: fade,
              child: ScaleTransition(scale: scale, child: child),
            );
          },
          child: _ThemeScene(key: ValueKey<String>(theme.id), theme: theme),
        );
      },
    );
  }
}

class _ThemeScene extends StatefulWidget {
  const _ThemeScene({super.key, required this.theme});

  final HomeTheme theme;

  @override
  State<_ThemeScene> createState() => _ThemeSceneState();
}

class _ThemeSceneState extends State<_ThemeScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _parallax = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 22),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final testing = WidgetsBinding.instance.runtimeType.toString().contains(
      'Test',
    );
    if (!testing && !MediaQuery.disableAnimationsOf(context)) {
      _parallax.repeat();
    } else {
      _parallax.value = 0.25;
    }
  }

  @override
  void dispose() {
    _parallax.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundAsset = widget.theme.id == 'hot_air_balloons'
        ? 'assets/backgrounds/hot_air_balloons_sky.svg'
        : widget.theme.svg;
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _parallax,
            builder: (context, child) {
              final angle = _parallax.value * math.pi * 2;
              return Transform.translate(
                key: const Key('theme_parallax'),
                // Horizontal only, so the owl's feet stay on the perch.
                offset: Offset(math.sin(angle) * 5, 0),
                child: Transform.scale(scale: sceneZoom, child: child),
              );
            },
            child: SvgPicture.asset(
              backgroundAsset,
              key: Key('home_bg_${widget.theme.id}'),
              fit: BoxFit.cover,
              alignment: Alignment.center,
              placeholderBuilder: (_) =>
                  ColoredBox(color: widget.theme.stageColor),
            ),
          ),
        ),
        ThemeMotionLayer(themeId: widget.theme.id),
      ],
    );
  }
}
