import 'dart:math';

/// Classic Brown owl roles in the AnggaMotion pack, with the reference
/// lightness/saturation each role is measured against.
enum OwlRole {
  body(0.58, 0.39),
  accent(0.29, 0.60),
  belly(0.77, 0.50),
  bow(0.50, 0.66);

  const OwlRole(this.refL, this.refS);

  final double refL;
  final double refS;
}

class Hsl {
  const Hsl(this.h, this.s, this.l);

  final double h;
  final double s;
  final double l;

  factory Hsl.fromRgb(int rgb) {
    final r = ((rgb >> 16) & 0xff) / 255;
    final g = ((rgb >> 8) & 0xff) / 255;
    final b = (rgb & 0xff) / 255;
    final mx = max(r, max(g, b));
    final mn = min(r, min(g, b));
    final l = (mx + mn) / 2;
    if (mx == mn) return Hsl(0, 0, l);
    final d = mx - mn;
    final s = l > 0.5 ? d / (2 - mx - mn) : d / (mx + mn);
    double h;
    if (mx == r) {
      h = ((g - b) / d) % 6;
    } else if (mx == g) {
      h = (b - r) / d + 2;
    } else {
      h = (r - g) / d + 4;
    }
    h *= 60;
    if (h < 0) h += 360;
    return Hsl(h, s, l);
  }

  int toRgb() {
    final c = (1 - (2 * l - 1).abs()) * s;
    final hp = h / 60;
    final x = c * (1 - (hp % 2 - 1).abs());
    double r = 0, g = 0, b = 0;
    if (hp < 1) {
      r = c;
      g = x;
    } else if (hp < 2) {
      r = x;
      g = c;
    } else if (hp < 3) {
      g = c;
      b = x;
    } else if (hp < 4) {
      g = x;
      b = c;
    } else if (hp < 5) {
      r = x;
      b = c;
    } else {
      r = c;
      b = x;
    }
    final m = l - c / 2;
    int ch(double v) => ((v + m) * 255).round().clamp(0, 255);
    return (ch(r) << 16) | (ch(g) << 8) | ch(b);
  }
}

/// Which owl part a Classic Brown pack color belongs to (null = keep as is:
/// beak/feet orange, eyes, whites, props).
OwlRole? classify(int rgb) {
  final c = Hsl.fromRgb(rgb);
  final h = c.h, s = c.s, l = c.l;
  final warm = h >= 15 && h <= 46;
  if (warm && s >= 0.68 && l >= 0.45 && l <= 0.8) return null;
  if (h >= 15 && h <= 30 && s >= 0.28 && s < 0.5 && l >= 0.33 && l <= 0.65) {
    return OwlRole.body;
  }
  if (h >= 18 && h <= 32 && s >= 0.3 && l >= 0.12 && l < 0.44) {
    return OwlRole.accent;
  }
  if (h >= 18 && h <= 46 && s >= 0.3 && s <= 0.7 && l >= 0.64 && l <= 0.9) {
    return OwlRole.belly;
  }
  if (h >= 200 && h <= 215 && s >= 0.5 && l >= 0.35 && l <= 0.6) {
    return OwlRole.bow;
  }
  return null;
}

/// Theme targets per role (RGB ints).
class OwlTheme {
  const OwlTheme({
    required this.body,
    required this.accent,
    required this.belly,
    required this.bow,
  });

  final int body;
  final int accent;
  final int belly;
  final int bow;

  int targetFor(OwlRole role) => switch (role) {
        OwlRole.body => body,
        OwlRole.accent => accent,
        OwlRole.belly => belly,
        OwlRole.bow => bow,
      };
}

/// Moves a pack color onto the theme while keeping its shading offset.
int remapRgb(int rgb, OwlTheme theme) {
  final role = classify(rgb);
  if (role == null) return rgb;
  final src = Hsl.fromRgb(rgb);
  final target = Hsl.fromRgb(theme.targetFor(role));
  final l = (target.l + (src.l - role.refL)).clamp(0.04, 0.97);
  final s = (target.s * (src.s / role.refS)).clamp(0.0, 1.0);
  return Hsl(target.h, s, l).toRgb();
}

int remapArgb(int argb, OwlTheme theme) {
  final alpha = argb & 0xFF000000;
  return alpha | remapRgb(argb & 0xFFFFFF, theme);
}

int parseHex(String hex) => int.parse(hex.replaceFirst('#', ''), radix: 16);
