import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'test_env.dart';

class RoundedProgressBar extends StatefulWidget {
  const RoundedProgressBar({
    super.key,
    required this.value,
    this.shine = true,
    this.fillColor,
    this.height = 18,
  });

  /// 0 to 1.
  final double value;

  /// Moving highlight (splash / big XP bars). Tiny meters should pass false.
  final bool shine;

  /// Solid fill; null = default purple gradient.
  final Color? fillColor;

  final double height;

  @override
  State<RoundedProgressBar> createState() => _RoundedProgressBarState();
}

class _RoundedProgressBarState extends State<RoundedProgressBar>
    with SingleTickerProviderStateMixin {
  AnimationController? _shine;

  @override
  void initState() {
    super.initState();
    if (widget.shine && !isFlutterTest) {
      _shine = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1400),
      )..repeat();
    }
  }

  @override
  void didUpdateWidget(covariant RoundedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shine != widget.shine) {
      _shine?.dispose();
      _shine = null;
      if (widget.shine && !isFlutterTest) {
        _shine = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1400),
        )..repeat();
      }
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
      return SizedBox(
        height: widget.height,
        child: _track(widget.value, 0.35),
      );
    }
    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: shine,
        builder: (context, _) => _track(widget.value, shine.value),
      ),
    );
  }

  Widget _track(double rawValue, double shineT) {
    final value = rawValue.clamp(0.0, 1.0);
    final fillColor = widget.fillColor;
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
              color: const Color(0xFFE8E0F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: fill,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: fillColor,
                      gradient: fillColor == null
                          ? const LinearGradient(
                              colors: [Color(0xFFB388FF), GameColors.purple],
                            )
                          : null,
                    ),
                    child: widget.shine
                        ? Stack(
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
                          )
                        : const SizedBox.expand(),
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
