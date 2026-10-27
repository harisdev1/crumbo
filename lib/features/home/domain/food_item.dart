import 'package:flutter/material.dart';

/// Draggable snack for home feed (A9). No inventory yet.
class FoodItem {
  const FoodItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String id;
  final String label;
  final IconData icon;
  final Color color;

  static const hungerBoost = 20.0;

  static const tray = <FoodItem>[
    FoodItem(
      id: 'butter',
      label: 'Butter',
      icon: Icons.breakfast_dining_rounded,
      color: Color(0xFFFFC107),
    ),
    FoodItem(
      id: 'jam',
      label: 'Jam',
      icon: Icons.icecream_rounded,
      color: Color(0xFFFF6B6B),
    ),
    FoodItem(
      id: 'fruit',
      label: 'Fruit',
      icon: Icons.apple_rounded,
      color: Color(0xFF66BB6A),
    ),
    FoodItem(
      id: 'cookie',
      label: 'Cookie',
      icon: Icons.cookie_rounded,
      color: Color(0xFFD4A574),
    ),
  ];
}
