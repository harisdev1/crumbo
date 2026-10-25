import 'package:crumbo/features/home/domain/home_theme.dart';
import 'package:crumbo/features/home/domain/theme_motion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(HomeThemeCatalog.debugReset);

  test('every theme has a moving layer', () async {
    final catalog = await HomeThemeCatalog.load();
    expect(catalog.themes, hasLength(30));
    for (final theme in catalog.themes) {
      expect(motionsForTheme(theme.id), isNotEmpty, reason: theme.id);
    }
    expect(motionsForTheme('sleepy_night'), contains(MotionKind.stars));
    expect(motionsForTheme('snowy_hills'), contains(MotionKind.snow));
    expect(motionsForTheme('autumn_forest'), contains(MotionKind.birds));
    expect(motionsForTheme('hot_air_balloons'), [MotionKind.balloons]);
    expect(motionsForTheme('rainy_day'), contains(MotionKind.rain));
    expect(motionsForTheme('cozy_room'), contains(MotionKind.fireplace));
    expect(motionsForTheme('classic_calm'), isNot(contains(MotionKind.clouds)));
    expect(motionsForTheme('unknown_theme'), isEmpty);
  });

  test('snow falls and stars twinkle as time moves', () {
    final snowA = layoutThemeMotion(
      themeId: 'snowy_hills',
      t: 0,
      width: 200,
      height: 400,
    );
    final snowB = layoutThemeMotion(
      themeId: 'snowy_hills',
      t: 0.35,
      width: 200,
      height: 400,
    );
    expect(snowA, isNotEmpty);
    final moved = [
      for (var i = 0; i < snowA.length; i++) snowA[i].dy != snowB[i].dy,
    ].any((changed) => changed);
    expect(moved, isTrue);

    final starsA = layoutThemeMotion(
      themeId: 'sleepy_night',
      t: 0,
      width: 200,
      height: 400,
    );
    final starsB = layoutThemeMotion(
      themeId: 'sleepy_night',
      t: 0.12,
      width: 200,
      height: 400,
    );
    final twinkled = [
      for (var i = 0; i < starsA.length; i++)
        starsA[i].opacity != starsB[i].opacity,
    ].any((changed) => changed);
    expect(twinkled, isTrue);
  });

  test('a tap adds a short burst', () {
    const burst = MotionBurst(nx: 0.4, ny: 0.3, born: 0.2);
    final still = layoutThemeMotion(
      themeId: 'morning_glow',
      t: 0.2,
      width: 100,
      height: 200,
    );
    final tapped = layoutThemeMotion(
      themeId: 'morning_glow',
      t: 0.2,
      width: 100,
      height: 200,
      bursts: const [burst],
    );
    expect(tapped.length, greaterThan(still.length));

    final later = layoutThemeMotion(
      themeId: 'morning_glow',
      t: 0.5,
      width: 100,
      height: 200,
      bursts: const [burst],
    );
    expect(later.length, still.length);
  });
}
