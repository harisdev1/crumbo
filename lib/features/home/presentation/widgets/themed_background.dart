import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/home_theme.dart';
import '../cubit/home_theme_cubit.dart';

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
          child: _SvgLayer(
            key: ValueKey<String>(theme.id),
            theme: theme,
          ),
        );
      },
    );
  }
}

class _SvgLayer extends StatelessWidget {
  const _SvgLayer({super.key, required this.theme});

  final HomeTheme theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SvgPicture.asset(
        theme.svg,
        key: Key('home_bg_${theme.id}'),
        fit: BoxFit.cover,
        alignment: Alignment.center,
        placeholderBuilder: (_) => ColoredBox(color: theme.stageColor),
      ),
    );
  }
}
