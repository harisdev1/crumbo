import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'test_env.dart';

class RoundedProgressBar extends StatefulWidget {
  const RoundedProgressBar({super.key, required this.value});

  /// 0 to 1.
  final double value;

  @override
  State<RoundedProgressBar> createState() => _RoundedProgressBarState();
}

class _RoundedProgressBarState extends State<RoundedProgressBar>
    with SingleTickerProviderStateMixin {
  AnimationController? _shine;

  @override
  void initState() {
    super.initState();
    if (!isFlutterTest) {
      _shine = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1400),
      )..repeat();
    }
  }

  @override
  void dispose() {
    _shine?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shine = _shine;
    if (shine == null) {
      return SizedBox(height: 18, child: _track(widget.value, 0.35));
    }
    return SizedBox(
      height: 18,
      child: AnimatedBuilder(
        animation: shine,
        builder: (context, _) => _track(widget.value, shine.value),
      ),
    );
  }

  Widget _track(double rawValue, double shineT) {
    final value = rawValue.clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        final fill = constraints.maxWidth.isFinite
            ? constraints.maxWidth * value
            : 0.0;
        final trackWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 0.0;
        return SizedBox(
          width: trackWidth,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Align(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: fill,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFB388FF), GameColors.purple],
                    ),
                  ),
                  child: Stack(
                    children: [
                      const SizedBox.expand(),
                      Positioned(
                        left: (shineT * 2 - 0.5) * fill,
                        top: 0,
                        bottom: 0,
                        width: 28,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0x00FFFFFF),
                                Color(0xAAFFFFFF),
                                Color(0x00FFFFFF),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ),
        );
      },
    );
  }
}
