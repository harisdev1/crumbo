import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'glossy_button.dart';

class GlossyIconButton extends StatefulWidget {
  const GlossyIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.label,
    this.selected = false,
    this.locked = false,
    this.size = 54,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? label;
  final bool selected;
  final bool locked;
  final double size;

  @override
  State<GlossyIconButton> createState() => _GlossyIconButtonState();
}

class _GlossyIconButtonState extends State<GlossyIconButton> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    final size = widget.size + (widget.selected ? 4 : 0);
    final face = GlossySurface(
      circle: true,
      color: widget.locked
          ? widget.color.withValues(alpha: 0.45)
          : widget.color,
      pressed: _pressed,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              widget.icon,
              color: Colors.white.withValues(alpha: widget.locked ? 0.6 : 1),
              size: size * 0.46,
            ),
            if (widget.locked)
              const Positioned(
                right: 2,
                bottom: 4,
                child: Icon(Icons.lock_rounded, size: 12, color: Colors.white),
              ),
          ],
        ),
      ),
    );

    final button = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: face,
    );

    final label = widget.label;
    if (label == null) return button;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        button,
        const SizedBox(height: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: AppTheme.displayFamily,
            color: GameColors.ink,
            fontSize: 11,
            fontWeight: widget.selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
