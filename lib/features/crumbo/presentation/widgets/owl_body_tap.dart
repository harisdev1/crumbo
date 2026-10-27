import 'package:flutter/material.dart';

/// Tap target that matches the owl body, not the whole square stage.
class OwlBodyTapShell extends StatelessWidget {
  const OwlBodyTapShell({
    super.key,
    required this.child,
    required this.onBodyTap,
    this.onBodyLongPress,
  });

  final Widget child;
  final VoidCallback onBodyTap;
  final VoidCallback? onBodyLongPress;

  static const _padL = 0.14;
  static const _padT = 0.08;
  static const _padR = 0.14;
  static const _padB = 0.20;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        return Stack(
          fit: StackFit.expand,
          children: [
            IgnorePointer(child: child),
            Positioned(
              left: w * _padL,
              top: h * _padT,
              right: w * _padR,
              bottom: h * _padB,
              child: GestureDetector(
                key: const Key('owl_body_tap'),
                behavior: HitTestBehavior.opaque,
                onTap: onBodyTap,
                onLongPress: onBodyLongPress,
                child: const SizedBox.expand(),
              ),
            ),
          ],
        );
      },
    );
  }
}
