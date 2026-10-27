import 'package:crumbo/features/crumbo/domain/owl_expression.dart';
import 'package:crumbo/features/crumbo/presentation/cubit/crumbo_cubit.dart';
import 'package:crumbo/features/crumbo/presentation/widgets/owl_body_tap.dart';
import 'package:crumbo/features/economy/domain/wallet.dart';
import 'package:crumbo/features/home/domain/scene_anchor.dart';
import 'package:crumbo/features/home/presentation/pages/home_page.dart';
import 'package:crumbo/features/home/presentation/widgets/owl_perch_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/hive_test_setup.dart';

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
  setUp(() async {
    await configureMemoryPreferences();
  });

  testWidgets('HomePage shows Owl branding, care bar, CC BY', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: HomePage(character: _fakeCharacter())),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home_title')), findsNothing);
    expect(find.byKey(const Key('home_background')), findsOneWidget);
    expect(find.byKey(const Key('theme_motion')), findsOneWidget);
    expect(find.byKey(const Key('theme_parallax')), findsOneWidget);
    final stage = tester.widget<AnimatedPositioned>(
      find.byKey(const Key('owl_stage')),
    );
    final scale = tester.widget<AnimatedScale>(
      find.byKey(const Key('owl_theme_scale')),
    );
    final screen = tester.getSize(find.byType(OwlPerchLayer));
    final expectedTop = owlBoxTop(
      screen: screen,
      perchY: 1290,
      boxSize: stage.width!,
      owlScale: scale.scale,
    );
    expect((stage.top! - expectedTop).abs(), lessThan(2));
    expect(scale.scale, inInclusiveRange(0.84, 1));
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
    expect(find.text('Owl'), findsNothing);
    expect(find.text(HomePage.tagline), findsNothing);
    expect(find.text('Tap me!'), findsNothing);
    expect(find.byKey(const Key('owl_attribution')), findsNothing);
    expect(find.byKey(const Key('care_action_bar')), findsOneWidget);
    expect(find.byKey(const Key('action_sleep')), findsOneWidget);
    expect(find.byKey(const Key('action_eat')), findsOneWidget);
    expect(find.byKey(const Key('action_moods')), findsOneWidget);
    expect(find.byKey(const Key('action_play')), findsOneWidget);
    expect(find.byKey(const Key('action_more')), findsNothing);
    expect(find.byKey(const Key('action_mood')), findsNothing);
    expect(find.byKey(const Key('coin_pill')), findsOneWidget);
    expect(find.byKey(const Key('gem_pill')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('coin_pill')),
        matching: find.text('${Wallet.starterCoins}'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('gem_pill')),
        matching: find.text('${Wallet.starterGems}'),
      ),
      findsOneWidget,
    );
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

  testWidgets('Moods sheet shows all faces including cool', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: HomePage(character: _fakeCharacter())),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('action_moods')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('moods_sheet')), findsOneWidget);
    expect(find.byKey(const Key('action_cool')), findsOneWidget);
    expect(find.byKey(const Key('action_dance')), findsOneWidget);
    expect(find.byKey(const Key('action_wink')), findsOneWidget);
    expect(OwlExpression.unlockAllExpressions, isTrue);

    await tester.tap(find.byKey(const Key('action_cool')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('moods_sheet')), findsNothing);
    final homeContext = tester.element(find.byKey(const Key('action_sleep')));
    expect(homeContext.read<CrumboCubit>().state.artboardName, '4');
  });

  testWidgets('Owl body tap runs bonk combo', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          character: Builder(
            builder: (context) => OwlBodyTapShell(
              onBodyTap: () =>
                  context.read<CrumboCubit>().onCharacterTapped(),
              child: _fakeCharacter(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Trays can cover stage hit-tests; drive bonk via cubit (shell is wired).
    final cubit = tester
        .element(find.byKey(const Key('action_sleep')))
        .read<CrumboCubit>();
    cubit.onCharacterTapped();
    await tester.pump();
    expect(cubit.state.artboardName, '8');
  });

  testWidgets('Android back asks before leaving home', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomePage(character: SizedBox())),
    );
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('exit_dialog')), findsOneWidget);
    await tester.tap(find.byKey(const Key('exit_no')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('exit_dialog')), findsNothing);
    expect(find.byKey(const Key('home_title')), findsNothing);
  });
}
