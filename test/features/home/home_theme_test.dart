import 'dart:convert';
import 'dart:io';

import 'package:crumbo/features/home/data/theme_preferences.dart';
import 'package:crumbo/features/home/domain/home_theme.dart';
import 'package:crumbo/features/home/presentation/cubit/home_theme_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(HomeThemeCatalog.debugReset);

  group('HomeThemeCatalog', () {
    test('has 30 unique themes with Morning Glow as default', () async {
      final catalog = await HomeThemeCatalog.load();
      expect(catalog.themes, hasLength(30));
      expect(catalog.themes.map((t) => t.id).toSet(), hasLength(30));
      expect(catalog.defaultId, HomeTheme.morningGlowId);
      expect(catalog.defaultTheme.name, 'Morning Glow');
      expect(catalog.numberOf(catalog.defaultTheme), 1);
    });

    test('unknown id falls back to default', () async {
      final catalog = await HomeThemeCatalog.load();
      expect(catalog.byId('nope').id, HomeTheme.morningGlowId);
    });

    test('every theme SVG exists and parses', () async {
      final json = jsonDecode(
        File('assets/data/home_themes.json').readAsStringSync(),
      ) as Map<String, dynamic>;
      for (final t in (json['themes'] as List).cast<Map<String, dynamic>>()) {
        final file = File(t['svg'] as String);
        expect(file.existsSync(), isTrue, reason: '${t['id']} svg missing');
        final info = await vg.loadPicture(
          SvgStringLoader(file.readAsStringSync()),
          null,
        );
        expect(info.size.width, greaterThan(0), reason: '${t['id']}');
        info.picture.dispose();
      }
    });
  });

  group('HomeThemeCubit', () {
    test('hydrate uses default when nothing saved', () async {
      final cubit = HomeThemeCubit(preferences: MemoryThemePreferences());
      await cubit.hydrate();
      expect(cubit.state.themeId, HomeTheme.morningGlowId);
      expect(cubit.activeTheme.id, HomeTheme.morningGlowId);
      await cubit.close();
    });

    test('hydrate restores saved theme', () async {
      final prefs = MemoryThemePreferences();
      await prefs.writeThemeId('sleepy_night');
      final cubit = HomeThemeCubit(preferences: prefs);
      await cubit.hydrate();
      expect(cubit.activeTheme.id, 'sleepy_night');
      expect(cubit.activeTheme.isDark, isTrue);
      await cubit.close();
    });

    test('preview changes active theme without saving', () async {
      final prefs = MemoryThemePreferences();
      final cubit = HomeThemeCubit(preferences: prefs);
      await cubit.hydrate();
      cubit.previewTheme('rainbow_meadow');
      expect(cubit.state.activeThemeId, 'rainbow_meadow');
      expect(await prefs.readThemeId(), isNull);
      cubit.clearThemePreview();
      expect(cubit.state.activeThemeId, HomeTheme.morningGlowId);
      await cubit.close();
    });

    test('apply saves theme and clears preview', () async {
      final prefs = MemoryThemePreferences();
      final cubit = HomeThemeCubit(preferences: prefs);
      await cubit.hydrate();
      cubit.previewTheme('sleepy_night');
      await cubit.applyTheme('sleepy_night');
      expect(cubit.state.themeId, 'sleepy_night');
      expect(cubit.state.previewThemeId, isNull);
      expect(await prefs.readThemeId(), 'sleepy_night');
      await cubit.close();
    });
  });
}
