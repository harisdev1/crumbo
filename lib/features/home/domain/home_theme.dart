import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// One of the 30 home background themes (JSON + SVG driven).
class HomeTheme {
  const HomeTheme({
    required this.id,
    required this.name,
    required this.svg,
    required this.stageColor,
    required this.isDark,
    this.perchY = 1300,
    this.owlScale = 1,
  });

  final String id;
  final String name;
  final String svg;
  final Color stageColor;
  final bool isDark;
  /// Y (in SVG units, 0–1920) of the surface the owl's feet stand on.
  final double perchY;
  final double owlScale;

  static const morningGlowId = 'morning_glow';

  Color get titleColor => isDark ? Colors.white : const Color(0xFF5D4037);
  Color get taglineColor => isDark
      ? Colors.white.withValues(alpha: 0.85)
      : const Color(0xFF5D4037).withValues(alpha: 0.85);

  factory HomeTheme.fromJson(Map<String, dynamic> json) {
    return HomeTheme(
      id: json['id'] as String,
      name: json['name'] as String,
      svg: json['svg'] as String,
      stageColor: _parseColor(json['stageColor'] as String),
      isDark: json['isDark'] as bool? ?? false,
      perchY: (json['perchY'] as num?)?.toDouble() ?? 1300,
      owlScale: (json['owlScale'] as num?)?.toDouble() ?? 1,
    );
  }

  static Color _parseColor(String hex) {
    var value = hex.replaceFirst('#', '');
    if (value.length == 6) value = 'FF$value';
    return Color(int.parse(value, radix: 16));
  }
}

class HomeThemeCatalog {
  HomeThemeCatalog(this.themes, this.defaultId);

  final List<HomeTheme> themes;
  final String defaultId;

  static HomeThemeCatalog? _cached;

  HomeTheme get defaultTheme {
    for (final t in themes) {
      if (t.id == defaultId) return t;
    }
    return themes.first;
  }

  HomeTheme byId(String id) {
    for (final t in themes) {
      if (t.id == id) return t;
    }
    return defaultTheme;
  }

  int numberOf(HomeTheme theme) => themes.indexOf(theme) + 1;

  static Future<HomeThemeCatalog> load({AssetBundle? bundle}) async {
    if (_cached != null) return _cached!;
    final raw = await (bundle ?? rootBundle).loadString(
      'assets/data/home_themes.json',
    );
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final list = (map['themes'] as List<dynamic>)
        .map((e) => HomeTheme.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    _cached = HomeThemeCatalog(
      list,
      map['defaultId'] as String? ?? HomeTheme.morningGlowId,
    );
    return _cached!;
  }

  @visibleForTesting
  static void debugReset() {
    _cached = null;
  }
}
