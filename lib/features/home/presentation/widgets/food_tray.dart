import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/glossy_button.dart';
import '../../domain/food_item.dart';

/// Horizontal snacks to drag onto the owl.
class FoodTray extends StatelessWidget {
  const FoodTray({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('food_tray'),
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F4FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Drag food to owl',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: GameColors.ink.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final food in FoodItem.tray) _FoodChip(food: food),
            ],
          ),
        ],
      ),
    );
  }
}

class _FoodChip extends StatelessWidget {
  const _FoodChip({required this.food});

  final FoodItem food;

  @override
  Widget build(BuildContext context) {
    final chip = GlossySurface(
      circle: true,
      color: food.color,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Icon(food.icon, color: Colors.white, size: 22),
      ),
    );

    return LongPressDraggable<String>(
      key: Key('food_${food.id}'),
      data: food.id,
      delay: const Duration(milliseconds: 120),
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(scale: 1.15, child: chip),
      ),
      childWhenDragging: Opacity(opacity: 0.35, child: chip),
      child: chip,
    );
  }
}
