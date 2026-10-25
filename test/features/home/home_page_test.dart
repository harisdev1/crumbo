import 'package:crumbo/features/crumbo/domain/owl_expression.dart';
import 'package:crumbo/features/crumbo/presentation/cubit/crumbo_cubit.dart';
import 'package:crumbo/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _fakeCharacter() {
  return GestureDetector(
    key: const Key('crumbo_rive'),
    onTap: () {},
    child: const ColoredBox(
      color: Color(0xFFFFE4B5),
      child: Center(child: Text('fake owl')),
    ),
  );
}

void main() {
  testWidgets('HomePage shows Owl branding, care bar, CC BY', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: HomePage(character: _fakeCharacter())),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home_title')), findsOneWidget);
    expect(find.byKey(const Key('home_background')), findsOneWidget);
    expect(find.byKey(const Key('theme_motion')), findsOneWidget);
    expect(find.byKey(const Key('theme_parallax')), findsOneWidget);
    expect(tester.widget(find.byKey(const Key('owl_stage'))), isA<SizedBox>());
    final drop = tester.widget<Transform>(
      find.byKey(const Key('owl_theme_offset')),
    );
    final scale = tester.widget<Transform>(
      find.byKey(const Key('owl_theme_scale')),
    );
    final screenHeight = MediaQuery.sizeOf(
      tester.element(find.byKey(const Key('owl_stage'))),
    ).height;
    expect(
      drop.transform.getTranslation().y / screenHeight,
      inInclusiveRange(0.02, 0.08),
    );
    expect(scale.transform.getMaxScaleOnAxis(), inInclusiveRange(0.84, 1.0));
    expect(
      find.ancestor(
        of: find.byKey(const Key('owl_stage')),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is DecoratedBox &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).shape == BoxShape.circle,
        ),
      ),
      findsNothing,
    );
    expect(find.text('Owl'), findsWidgets);
    expect(find.text(HomePage.tagline), findsNothing);
    expect(find.text('Tap me!'), findsNothing);
    expect(find.byKey(const Key('owl_attribution')), findsOneWidget);
    expect(find.byKey(const Key('care_action_bar')), findsOneWidget);
    expect(find.byKey(const Key('action_sleep')), findsOneWidget);
    expect(find.byKey(const Key('action_eat')), findsOneWidget);
    expect(find.byKey(const Key('action_more')), findsOneWidget);
    expect(find.byKey(const Key('action_rail_left')), findsNothing);
  });

  testWidgets('Sleep icon updates status; tap wakes', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: HomePage(character: _fakeCharacter())),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('action_sleep')));
    await tester.pump();

    expect(find.text('Tap me!'), findsNothing);
    expect(find.text('Zzz — tap to wake'), findsNothing);

    final context = tester.element(find.byKey(const Key('action_sleep')));
    final crumbo = context.read<CrumboCubit>();
    expect(crumbo.state.artboardName, 'sleep');
    expect(crumbo.state.expression.assetPath, 'assets/rive/owl_sleep.riv');

    crumbo.onCharacterTapped();
    await tester.pump();

    expect(crumbo.state.expression, isNot(OwlExpression.sleep));
    expect(crumbo.state.artboardName, '11');
  });

  testWidgets('More sheet allows cool when unlock-all flag is on', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: HomePage(character: _fakeCharacter())),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('action_more')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('more_moods_sheet')), findsOneWidget);
    expect(find.byKey(const Key('action_cool')), findsOneWidget);
    expect(OwlExpression.unlockAllExpressions, isTrue);

    await tester.tap(find.byKey(const Key('action_cool')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('more_moods_sheet')), findsNothing);
    expect(find.text('Locked — play more to unlock!'), findsNothing);
    final homeContext = tester.element(find.byKey(const Key('action_sleep')));
    expect(homeContext.read<CrumboCubit>().state.artboardName, '4');
  });
}
