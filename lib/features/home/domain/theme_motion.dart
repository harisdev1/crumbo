import 'dart:math' as math;
import 'dart:ui';

/// One moving layer on a home background.
enum MotionKind {
  stars,
  clouds,
  birds,
  snow,
  rain,
  bubbles,
  fish,
  leaves,
  petals,
  butterflies,
  sprinkles,
  sand,
  dust,
  balloons,
  toys,
  aurora,
  fireflies,
  lightRays,
  water,
  glow,
  steam,
  curtain,
  plant,
  fireplace,
}

/// A tap on empty sky. [born] is the animation clock (0–1) when it happened.
class MotionBurst {
  const MotionBurst({required this.nx, required this.ny, required this.born});

  final double nx;
  final double ny;
  final double born;
}

/// One thing the painter draws for a frame.
class MotionSpeck {
  const MotionSpeck({
    required this.kind,
    required this.dx,
    required this.dy,
    required this.size,
    required this.spin,
    required this.opacity,
    required this.color,
  });

  final MotionKind kind;
  final double dx;
  final double dy;
  final double size;
  final double spin;
  final double opacity;
  final Color color;
}

/// Which motions belong to each background theme.
List<MotionKind> motionsForTheme(String themeId) {
  return switch (themeId) {
    'morning_glow' => const [MotionKind.lightRays, MotionKind.birds],
    'classic_calm' => const [MotionKind.curtain, MotionKind.dust],
    'sleepy_night' => const [MotionKind.stars, MotionKind.glow],
    'playful_bubbles' => const [MotionKind.bubbles, MotionKind.water],
    'cozy_room' => const [MotionKind.fireplace, MotionKind.dust],
    'sunset_beach' => const [MotionKind.water, MotionKind.birds],
    'under_the_sea' => const [MotionKind.bubbles, MotionKind.fish],
    'candy_land' => const [MotionKind.steam, MotionKind.sprinkles],
    'snowy_hills' => const [MotionKind.snow],
    'autumn_forest' => const [MotionKind.leaves, MotionKind.birds],
    'spring_garden' => const [MotionKind.petals, MotionKind.butterflies],
    'rainbow_meadow' => const [MotionKind.butterflies],
    'starry_space' => const [MotionKind.stars, MotionKind.glow],
    'desert_dunes' => const [MotionKind.sand],
    'jungle_leaves' => const [MotionKind.leaves, MotionKind.birds],
    'cherry_blossom' => const [MotionKind.petals],
    'sunny_picnic' => const [MotionKind.lightRays, MotionKind.birds],
    'ice_cream_dream' => const [MotionKind.steam, MotionKind.sprinkles],
    'mountain_lake' => const [MotionKind.water, MotionKind.birds],
    'northern_lights' => const [MotionKind.stars, MotionKind.aurora],
    'rainy_day' => const [MotionKind.rain, MotionKind.glow],
    'pumpkin_patch' => const [MotionKind.leaves, MotionKind.fireflies],
    'cloud_castle' => const [MotionKind.lightRays, MotionKind.glow],
    'tropical_island' => const [MotionKind.water, MotionKind.birds],
    'lavender_field' => const [MotionKind.petals, MotionKind.lightRays],
    'bamboo_grove' => const [MotionKind.leaves, MotionKind.plant],
    'cozy_library' => const [MotionKind.glow, MotionKind.dust],
    'camping_tent' => const [MotionKind.stars, MotionKind.fireplace],
    'hot_air_balloons' => const [MotionKind.balloons],
    'toy_box_playroom' => const [MotionKind.toys],
    _ => const [],
  };
}

double _fract(double v) => v - v.floorToDouble();

double _unit(int i, int salt) =>
    _fract(math.sin(i * 12.9898 + salt * 78.233) * 43758.5453);

double _wrap(double v) => _fract(v);

/// Specks for one frame. [t] loops from 0 to 1.
List<MotionSpeck> layoutThemeMotion({
  required String themeId,
  required double t,
  required double width,
  required double height,
  List<MotionBurst> bursts = const [],
}) {
  final specks = <MotionSpeck>[];
  for (final kind in motionsForTheme(themeId)) {
    specks.addAll(_kindSpecks(kind, t, width, height));
  }
  for (final burst in bursts) {
    var age = t - burst.born;
    if (age < 0) age += 1;
    if (age > 0.18) continue;
    final kinds = motionsForTheme(themeId);
    final kind = kinds.isEmpty ? MotionKind.stars : kinds.first;
    specks.addAll(_burstSpecks(kind, burst, age, width, height));
  }
  return specks;
}

List<MotionSpeck> _burstSpecks(
  MotionKind kind,
  MotionBurst burst,
  double age,
  double width,
  double height,
) {
  final fade = (1 - age / 0.18).clamp(0.0, 1.0);
  return List.generate(8, (i) {
    final ang = i / 8 * math.pi * 2;
    final dist = age * 1.6;
    return MotionSpeck(
      kind: kind == MotionKind.balloons ? MotionKind.stars : kind,
      dx: (burst.nx + math.cos(ang) * dist) * width,
      dy: (burst.ny + math.sin(ang) * dist) * height,
      size: 5 + i.toDouble(),
      spin: ang,
      opacity: fade,
      color: _burstColor(kind, i),
    );
  });
}

Color _burstColor(MotionKind kind, int i) {
  final colors = switch (kind) {
    MotionKind.snow || MotionKind.stars => const [Color(0xFFFFFFFF)],
    MotionKind.rain => const [Color(0xFF90CAF9)],
    MotionKind.leaves => const [Color(0xFFE65100), Color(0xFFF9A825)],
    MotionKind.petals ||
    MotionKind.butterflies => const [Color(0xFFF48FB1), Color(0xFFCE93D8)],
    MotionKind.sprinkles || MotionKind.toys => const [
      Color(0xFFEF5350),
      Color(0xFFFFCA28),
      Color(0xFF42A5F5),
      Color(0xFF66BB6A),
    ],
    _ => const [Color(0xFFFFFFFF)],
  };
  return colors[i % colors.length];
}

List<MotionSpeck> _kindSpecks(
  MotionKind kind,
  double t,
  double width,
  double height,
) {
  final count = switch (kind) {
    MotionKind.stars => 26,
    MotionKind.clouds => 4,
    MotionKind.birds => 3,
    MotionKind.snow => 36,
    MotionKind.rain => 42,
    MotionKind.bubbles => 14,
    MotionKind.fish => 5,
    MotionKind.leaves => 16,
    MotionKind.petals => 18,
    MotionKind.butterflies => 5,
    MotionKind.sprinkles => 22,
    MotionKind.sand => 28,
    MotionKind.dust => 16,
    MotionKind.balloons => 3,
    MotionKind.toys => 10,
    MotionKind.aurora => 3,
    MotionKind.fireflies => 14,
    MotionKind.lightRays => 3,
    MotionKind.water => 7,
    MotionKind.glow => 2,
    MotionKind.steam => 6,
    MotionKind.curtain => 3,
    MotionKind.plant => 6,
    MotionKind.fireplace => 6,
  };
  return List.generate(count, (i) {
    final u = _unit(i, kind.index + 1);
    final v = _unit(i, kind.index + 9);
    final phase = u * math.pi * 2;
    final speed = 0.25 + v * 0.7;
    late double nx;
    late double ny;
    var size = 4.0 + u * 8;
    var spin = phase + t * math.pi * 2;
    var opacity = 0.75;
    var color = const Color(0xFFFFFFFF);

    switch (kind) {
      case MotionKind.stars:
        nx = u;
        ny = v * 0.72;
        size = 1.5 + u * 2.8;
        opacity = 0.35 + 0.65 * (0.5 + 0.5 * math.sin(phase + t * math.pi * 6));
        color = i.isEven ? const Color(0xFFFFFFFF) : const Color(0xFFFFF59D);
      case MotionKind.clouds:
        nx = _wrap(u * 0.8 + t * 0.12 + i * 0.18);
        ny = 0.08 + v * 0.28;
        size = 28 + u * 26;
        opacity = 0.55;
      case MotionKind.birds:
        nx = _wrap(t * 0.35 + i * 0.33);
        ny = 0.12 + i * 0.1 + math.sin(phase + t * math.pi * 2) * 0.02;
        size = 7 + i.toDouble();
        color = const Color(0xFF455A64);
        opacity = 0.9;
      case MotionKind.snow:
        nx = _wrap(u + math.sin(phase + t * math.pi * 2) * 0.03);
        ny = _wrap(v + t * speed);
        size = 2 + u * 3.5;
      case MotionKind.rain:
        nx = u;
        ny = _wrap(v + t * (1.1 + u));
        size = 10 + u * 8;
        color = const Color(0xFF90CAF9);
        opacity = 0.55;
      case MotionKind.bubbles:
        nx = _wrap(u + math.sin(phase + t * math.pi * 2) * 0.02);
        ny = _wrap(1 - (v + t * (0.25 + u * 0.35)));
        size = 5 + u * 10;
        color = const Color(0xFFB3E5FC);
        opacity = 0.7;
      case MotionKind.fish:
        nx = _wrap(t * (0.2 + u * 0.25) + i * 0.2);
        ny = 0.55 + v * 0.3 + math.sin(phase + t * math.pi * 2) * 0.02;
        size = 8 + u * 6;
        color = i.isEven ? const Color(0xFFFFB74D) : const Color(0xFF4FC3F7);
      case MotionKind.leaves:
        nx = _wrap(u + math.sin(phase + t * math.pi * 2) * 0.06);
        ny = _wrap(v + t * (0.35 + u * 0.4));
        size = 6 + u * 5;
        color = i.isEven ? const Color(0xFFE65100) : const Color(0xFFF9A825);
      case MotionKind.petals:
        nx = _wrap(u + math.sin(phase + t * math.pi * 2) * 0.04);
        ny = _wrap(v + t * (0.28 + u * 0.3));
        size = 4 + u * 4;
        color = i.isEven ? const Color(0xFFF48FB1) : const Color(0xFFFFCDD2);
      case MotionKind.butterflies:
        nx = _wrap(0.1 + u * 0.8 + math.sin(phase + t * math.pi * 2) * 0.08);
        ny = 0.2 + v * 0.45 + math.cos(phase + t * math.pi * 4) * 0.03;
        size = 6 + u * 3;
        color = i.isEven ? const Color(0xFFCE93D8) : const Color(0xFFFFF176);
      case MotionKind.sprinkles:
        nx = u;
        ny = _wrap(v + t * (0.45 + u * 0.4));
        size = 4 + u * 3;
        color = const [
          Color(0xFFEF5350),
          Color(0xFFFFCA28),
          Color(0xFF42A5F5),
          Color(0xFF66BB6A),
          Color(0xFFAB47BC),
        ][i % 5];
      case MotionKind.sand:
        nx = _wrap(u + t * (0.35 + v * 0.4));
        ny = 0.35 + v * 0.55;
        size = 1.5 + u * 2;
        color = const Color(0xFFFFE0B2);
        opacity = 0.7;
      case MotionKind.dust:
        nx = _wrap(u + math.sin(phase + t * math.pi * 2) * 0.04);
        ny = _wrap(v + t * 0.08);
        size = 1.6 + u * 2.2;
        color = const Color(0xFFFFE0B2);
        opacity = 0.45 + 0.4 * (0.5 + 0.5 * math.sin(phase + t * math.pi * 4));
      case MotionKind.balloons:
        const spots = [
          (0.23, 0.24, 1.15, Color(0xFFEF5350)),
          (0.76, 0.20, 0.95, Color(0xFF42A5F5)),
          (0.49, 0.32, 0.7, Color(0xFFAB47BC)),
        ];
        final spot = spots[i];
        nx = spot.$1 + math.sin(phase + t * math.pi * 2) * 0.025;
        ny = spot.$2 + math.cos(phase + t * math.pi * 2) * 0.018;
        size = 54 * spot.$3;
        color = spot.$4;
        opacity = 1;
      case MotionKind.toys:
        nx = _wrap(u + math.sin(phase + t * math.pi * 2) * 0.05);
        ny = 0.15 + (0.5 + 0.5 * math.sin(phase + t * math.pi * 2)) * 0.55;
        size = 6 + u * 6;
        color = const [
          Color(0xFFEF5350),
          Color(0xFF42A5F5),
          Color(0xFFFFCA28),
          Color(0xFF66BB6A),
        ][i % 4];
      case MotionKind.aurora:
        nx = 0.5 + math.sin(phase + t * math.pi * 2) * 0.08;
        ny = 0.18 + i * 0.1;
        size = height * 0.16;
        opacity = 0.28;
        color = const [
          Color(0xFF69F0AE),
          Color(0xFF80D8FF),
          Color(0xFFB388FF),
        ][i];
      case MotionKind.fireflies:
        nx = _wrap(u + math.sin(phase + t * math.pi * 2) * 0.06);
        ny = 0.45 + v * 0.4 + math.cos(phase + t * math.pi * 2) * 0.03;
        size = 2.2 + u * 1.6;
        opacity = 0.25 + 0.75 * (0.5 + 0.5 * math.sin(phase + t * math.pi * 8));
        color = const Color(0xFFCCFF90);
      case MotionKind.lightRays:
        nx = 0.12 + i * 0.34 + math.sin(phase + t * math.pi * 2) * 0.02;
        ny = 0.18;
        size = height * (0.42 + i * 0.06);
        spin = -0.12 + i * 0.1;
        opacity = 0.06 + 0.05 * (0.5 + 0.5 * math.sin(phase + t * math.pi * 2));
        color = const Color(0xFFFFF4C2);
      case MotionKind.water:
        nx = 0.08 + i * 0.145;
        ny = 0.50 + i * 0.035 + math.sin(phase + t * math.pi * 2) * 0.008;
        size = width * (0.08 + u * 0.06);
        opacity = 0.22 + u * 0.18;
        color = const Color(0xFFE3FFFF);
      case MotionKind.glow:
        nx = i == 0 ? 0.82 : 0.18;
        ny = i == 0 ? 0.22 : 0.62;
        size = width * (0.16 + i * 0.05);
        opacity = 0.06 + 0.08 * (0.5 + 0.5 * math.sin(phase + t * math.pi * 2));
        color = const Color(0xFFFFE59A);
      case MotionKind.steam:
        nx = 0.24 + i * 0.105 + math.sin(phase + t * math.pi * 2) * 0.018;
        ny = _wrap(0.72 - (v + t * 0.16)) * 0.48 + 0.18;
        size = 8 + u * 8;
        opacity = 0.18 + u * 0.2;
        color = const Color(0xFFFFFFFF);
      case MotionKind.curtain:
        nx = i == 0 ? 0.10 : (i == 1 ? 0.32 : 0.88);
        ny = 0.36 + i * 0.09;
        size = height * 0.22;
        spin = math.sin(phase + t * math.pi * 2) * 0.03;
        opacity = 0.10;
        color = const Color(0xFFFFFFFF);
      case MotionKind.plant:
        nx = i.isEven ? 0.12 + i * 0.02 : 0.86 - i * 0.015;
        ny = 0.55 + v * 0.18;
        size = 10 + u * 8;
        spin = math.sin(phase + t * math.pi * 2) * 0.35;
        opacity = 0.32;
        color = const Color(0xFF9CCC65);
      case MotionKind.fireplace:
        nx = 0.78 + (u - 0.5) * 0.12;
        ny = 0.53 + v * 0.08;
        size = 8 + u * 12;
        spin = math.sin(phase + t * math.pi * 4) * 0.2;
        opacity = 0.35 + 0.35 * (0.5 + 0.5 * math.sin(phase + t * math.pi * 5));
        color = i.isEven ? const Color(0xFFFFC247) : const Color(0xFFF06B3D);
    }

    return MotionSpeck(
      kind: kind,
      dx: nx * width,
      dy: ny * height,
      size: size,
      spin: spin,
      opacity: opacity,
      color: color,
    );
  });
}
