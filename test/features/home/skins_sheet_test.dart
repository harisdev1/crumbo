import 'package:crumbo/features/crumbo/domain/owl_skin.dart';
import 'package:crumbo/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    OwlSkinCatalog.debugReset();
  });

  testWidgets('Skins button on home opens 20-theme grid and applies', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(home: HomePage(character: SizedBox())),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('action_skins')), findsOneWidget);
    await tester.tap(find.byKey(const Key('action_skins')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('skins_sheet')), findsOneWidget);
    expect(find.text('20 Owl Color Themes'), findsOneWidget);
    expect(find.text('1. Classic Brown'), findsWidgets);
    expect(find.byKey(const Key('skin_blue_sky')), findsOneWidget);

    await tester.tap(find.byKey(const Key('skin_blue_sky')));
    await tester.pumpAndSettle();
    expect(find.text('2. Blue Sky'), findsWidgets);
    expect(find.text('Use this'), findsOneWidget);

    await tester.tap(find.byKey(const Key('skins_apply_button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('skins_sheet')), findsNothing);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('owl_skin_id'), 'blue_sky');
  });
}
