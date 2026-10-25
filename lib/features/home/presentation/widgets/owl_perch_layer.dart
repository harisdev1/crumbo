import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/scene_anchor.dart';
import '../cubit/home_theme_cubit.dart';

/// Full-screen layer that stands the owl on the theme's perch (branch, sofa…).
///
/// Uses the same screen size as the background so the SVG point and the
/// owl's feet line up on every phone shape.
class OwlPerchLayer extends StatelessWidget {
  const OwlPerchLayer({super.key, required this.child});

  final Widget child;

  static const _duration = Duration(milliseconds: 700);

  static double boxSizeFor(Size screen) =>
      (screen.width * 0.92).clamp(260.0, 520.0);

  @override
  Widget build(BuildContext context) {
    final placement = context
        .select<HomeThemeCubit, ({double perchY, double scale})>(
          (cubit) => (
            perchY: cubit.activeTheme.perchY,
            scale: cubit.activeTheme.owlScale,
          ),
        );
    return LayoutBuilder(
      builder: (context, constraints) {
        final screen = constraints.biggest;
        final box = boxSizeFor(screen);
        final top = owlBoxTop(
          screen: screen,
          perchY: placement.perchY,
          boxSize: box,
          owlScale: placement.scale,
        );
        return Stack(
          children: [
            AnimatedPositioned(
              key: const Key('owl_stage'),
              duration: _duration,
              curve: Curves.easeInOutCubic,
              left: (screen.width - box) / 2,
              top: top,
              width: box,
              height: box,
              child: AnimatedScale(
                key: const Key('owl_theme_scale'),
                duration: _duration,
                curve: Curves.easeInOutCubic,
                scale: placement.scale,
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}
