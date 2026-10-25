import 'package:flutter/material.dart';

IconData contentIcon(String name) {
  return switch (name) {
    'jump' => Icons.keyboard_double_arrow_up_rounded,
    'bubbles' => Icons.bubble_chart_rounded,
    'memory' => Icons.grid_view_rounded,
    'run' => Icons.directions_run_rounded,
    'whack' => Icons.front_hand_rounded,
    'match' => Icons.extension_rounded,
    'fruit' => Icons.apple_rounded,
    'cake' => Icons.cake_rounded,
    'fish' => Icons.set_meal_rounded,
    'pizza' => Icons.local_pizza_rounded,
    'nuts' => Icons.eco_rounded,
    'burger' => Icons.lunch_dining_rounded,
    'hat' => Icons.dry_cleaning_rounded,
    'glasses' => Icons.visibility_rounded,
    'neck' => Icons.diamond_rounded,
    _ => Icons.pets_rounded,
  };
}
