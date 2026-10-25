import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Gradient face with a hard bottom lip, used by the game buttons.
class GlossySurface extends StatelessWidget {
  const GlossySurface({
    super.key,
    required this.color,
    required this.child,
    this.radius = 22,
    this.circle = false,
    this.pressed = false,
  });

  final Color color;
  final Widget child;
  final double radius;
  final bool circle;
  final bool pressed;

  @override
  Widget build(BuildContext context) {
    final light = Color.lerp(color, Colors.white, 0.42)!;
    final dark = Color.lerp(color, Colors.black, 0.22)!;
    final lip = Color.lerp(color, Colors.black, 0.38)!;
    final shape = circle ? BoxShape.circle : BoxShape.rectangle;
    final radius = circle ? null : BorderRadius.circular(this.radius);

    return Transform.translate(
      offset: Offset(0, pressed ? 4 : 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: shape,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: lip,
              offset: Offset(0, pressed ? 1 : 5),
            ),
          ],
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: shape,
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [light, color, dark],
              stops: const [0, 0.55, 1],
            ),
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Stack(
            children: [
              child,
              Positioned(
                top: circle ? 6 : 5,
                left: circle ? 12 : 16,
                right: circle ? 12 : 16,
                height: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlossyButton extends StatefulWidget {
  const GlossyButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color = GameColors.purple,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;
  final bool expand;

  @override
  State<GlossyButton> createState() => _GlossyButtonState();
}

class _GlossyButtonState extends State<GlossyButton> {
  var _pressed = false;

  bool get _enabled => widget.onPressed != null;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final label = Text(
      widget.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: AppTheme.displayFamily,
        color: Colors.white,
        fontSize: 16,
      ),
    );
    final button = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _enabled ? (_) => _setPressed(true) : null,
      onTapUp: _enabled ? (_) => _setPressed(false) : null,
      onTapCancel: _enabled ? () => _setPressed(false) : null,
      onTap: widget.onPressed,
      child: GlossySurface(
        color: widget.color,
        pressed: _pressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: Colors.white, size: 20),
                  const SizedBox(width: 6),
                ],
                if (widget.expand) Flexible(child: label) else label,
              ],
            ),
          ),
        ),
      ),
    );
    return Opacity(
      opacity: _enabled ? 1 : 0.55,
      child: widget.expand
          ? SizedBox(width: double.infinity, child: button)
          : button,
    );
  }
}
