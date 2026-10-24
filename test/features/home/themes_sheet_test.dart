import 'package:crumbo/features/crumbo/domain/owl_skin.dart';
import 'package:crumbo/features/home/domain/home_theme.dart';
import 'package:crumbo/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    OwlSkinCatalog.debugReset();
    HomeThemeCatalog.debugReset();
  });

  // Catalogs stay cached between tests: rootBundle futures from an earlier
  // test's fake-async zone never complete in the next one.
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('Themes button opens 30-theme grid and applies background', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(home: HomePage(character: SizedBox())),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home_bg_morning_glow')), findsOneWidget);

    await tester.tap(find.byKey(const Key('action_themes')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('themes_sheet')), findsOneWidget);
    expect(find.text('30 Background Themes'), findsOneWidget);
    expect(find.text('1. Morning Glow'), findsWidgets);

    await tester.tap(find.byKey(const Key('theme_sleepy_night')));
    await tester.pumpAndSettle();
    expect(find.text('3. Sleepy Night'), findsWidgets);
    expect(find.text('Use this'), findsOneWidget);

    await tester.tap(find.byKey(const Key('themes_apply_button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('themes_sheet')), findsNothing);
    expect(find.byKey(const Key('home_bg_sleepy_night')), findsOneWidget);
    expect(find.byKey(const Key('home_bg_morning_glow')), findsNothing);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('home_theme_id'), 'sleepy_night');
  });

  testWidgets('closing the sheet without apply restores the old theme', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(home: HomePage(character: SizedBox())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('action_themes')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('theme_sleepy_night')));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(200, 20));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('themes_sheet')), findsNothing);
    expect(find.byKey(const Key('home_bg_morning_glow')), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('home_theme_id'), isNull);
  });
}
