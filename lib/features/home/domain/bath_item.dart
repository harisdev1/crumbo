import 'package:flutter/material.dart';

/// Draggable bath tool for home (B1). No inventory yet.
class BathItem {
  const BathItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String id;
  final String label;
  final IconData icon;
  final Color color;

  /// Clean meter boost when bathing / cleaning.
  static const cleanBoost = 22.0;

  /// Small fun bump during bath play.
  static const funBoost = 8.0;

  static const tray = <BathItem>[
    BathItem(
      id: 'sponge',
      label: 'Sponge',
      icon: Icons.cleaning_services_rounded,
      color: Color(0xFFFFB74D),
    ),
    BathItem(
      id: 'duck',
      label: 'Duck',
      icon: Icons.emoji_nature_rounded,
      color: Color(0xFFFFCA28),
    ),
    BathItem(
      id: 'soap',
      label: 'Soap',
      icon: Icons.water_drop_rounded,
      color: Color(0xFF81D4FA),
    ),
  ];

  static bool isBathTool(String id) => tray.any((b) => b.id == id);
}
