import 'package:flutter/material.dart';

/// Palette from the approved Crumbo character sheet.
abstract final class CrumboColors {
  static const crust = Color(0xFFC98A4B);
  static const cream = Color(0xFFF9EAD3);
  static const scaffold = Color(0xFFFFF8F0);
  static const blush = Color(0xFFF4A792);
  static const detail = Color(0xFF6D5348);
  static const accentYellow = Color(0xFFFFD797);

  /// Aliases used across older call sites.
  static const goldenBrown = crust;
  static const softBrown = detail;
  static const crustDark = detail;
  static const butterYellow = accentYellow;
}

abstract final class AppTheme {
  static const fontFamily = 'Fredoka';

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: CrumboColors.crust,
      primary: CrumboColors.crust,
      secondary: CrumboColors.accentYellow,
      surface: CrumboColors.cream,
      onPrimary: Colors.white,
      onSecondary: CrumboColors.detail,
      onSurface: CrumboColors.detail,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: CrumboColors.scaffold,
      fontFamily: fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: CrumboColors.crust,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontFamily: fontFamily,
          color: CrumboColors.detail,
          fontWeight: FontWeight.w700,
          fontSize: 32,
        ),
        titleMedium: TextStyle(
          fontFamily: fontFamily,
          color: CrumboColors.detail,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontFamily,
          color: CrumboColors.detail,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: TextStyle(
          fontFamily: fontFamily,
          color: CrumboColors.detail,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
