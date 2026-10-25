import 'package:crumbo/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/hive_test_setup.dart';

void main() {
  setUp(() async {
    await configureMemoryPreferences();
  });

  testWidgets('App home boots with care bar and character', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          character: const ColoredBox(
            key: Key('crumbo_rive'),
            color: Color(0xFFFFE4B5),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('home_title')), findsNothing);
    expect(find.text(HomePage.tagline), findsNothing);
    expect(find.byKey(const Key('care_action_bar')), findsOneWidget);
    expect(find.byKey(const Key('action_moods')), findsOneWidget);
    expect(find.byKey(const Key('crumbo_rive')), findsOneWidget);
  });
}
