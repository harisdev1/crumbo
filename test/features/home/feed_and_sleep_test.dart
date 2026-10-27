import 'package:crumbo/features/crumbo/data/needs_repository.dart';
import 'package:crumbo/features/crumbo/domain/need_kind.dart';
import 'package:crumbo/features/crumbo/domain/owl_expression.dart';
import 'package:crumbo/features/crumbo/domain/pet_needs.dart';
import 'package:crumbo/features/crumbo/presentation/cubit/crumbo_cubit.dart';
import 'package:crumbo/features/crumbo/presentation/cubit/needs_cubit.dart';
import 'package:crumbo/features/home/domain/food_item.dart';
import 'package:crumbo/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/hive_test_setup.dart';

void main() {
  setUp(() async {
    await configureMemoryPreferences();
  });

  testWidgets('home shows food tray snacks', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomePage(character: SizedBox())),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('food_tray')), findsOneWidget);
    expect(find.byKey(const Key('food_butter')), findsOneWidget);
    expect(find.byKey(const Key('food_jam')), findsOneWidget);
    expect(find.byKey(const Key('owl_feed_target')), findsOneWidget);
  });

  testWidgets('sleep shows dim overlay', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomePage(character: SizedBox())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('action_sleep')));
    await tester.pumpAndSettle();

    final opacity = tester.widget<AnimatedOpacity>(
      find.ancestor(
        of: find.byKey(const Key('sleep_dim')),
        matching: find.byType(AnimatedOpacity),
      ),
    );
    expect(opacity.opacity, 1);
  });

  test('dropping food logic boosts hunger and sets eat', () async {
    final t0 = DateTime.utc(2026, 10, 26);
    final repo = MemoryNeedsRepository();
    await repo.save(PetNeeds.fresh(at: t0).copyWith(hunger: 40));
    final needs = NeedsCubit(repository: repo, clock: () => t0);
    await needs.hydrate();
    final crumbo = CrumboCubit();

    crumbo.setExpression(OwlExpression.eat);
    await needs.boost(NeedKind.hunger, FoodItem.hungerBoost);

    expect(crumbo.state.expression, OwlExpression.eat);
    expect(needs.state.needs.hunger, 60);
    await crumbo.close();
    await needs.close();
  });

  test('pet sets happy expression', () {
    final cubit = CrumboCubit();
    cubit.pet();
    expect(cubit.state.expression, OwlExpression.happy);
    cubit.close();
  });

  test('pet love boost amount is positive', () async {
    final t0 = DateTime.utc(2026, 10, 26);
    final repo = MemoryNeedsRepository();
    await repo.save(PetNeeds.fresh(at: t0).copyWith(love: 50));
    final needs = NeedsCubit(repository: repo, clock: () => t0);
    await needs.hydrate();
    await needs.boost(NeedKind.love, CrumboCubit.loveBoost);
    expect(needs.state.needs.love, 60);
    await needs.close();
  });
}
