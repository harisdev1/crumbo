import 'package:crumbo/features/crumbo/data/needs_repository.dart';
import 'package:crumbo/features/crumbo/domain/need_kind.dart';
import 'package:crumbo/features/crumbo/domain/owl_expression.dart';
import 'package:crumbo/features/crumbo/domain/pet_needs.dart';
import 'package:crumbo/features/crumbo/presentation/cubit/crumbo_cubit.dart';
import 'package:crumbo/features/crumbo/presentation/cubit/needs_cubit.dart';
import 'package:crumbo/features/home/domain/bath_item.dart';
import 'package:crumbo/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/hive_test_setup.dart';

void main() {
  setUp(() async {
    await configureMemoryPreferences();
  });

  test('bath tray boosts are positive', () {
    expect(BathItem.cleanBoost, greaterThan(0));
    expect(BathItem.funBoost, greaterThan(0));
    expect(BathItem.tray, isNotEmpty);
    expect(BathItem.isBathTool('sponge'), isTrue);
    expect(BathItem.isBathTool('butter'), isFalse);
  });

  test('bath boosts clean and fun meters', () async {
    final t0 = DateTime.utc(2026, 10, 26);
    final repo = MemoryNeedsRepository();
    await repo.save(PetNeeds.fresh(at: t0).copyWith(clean: 40, fun: 40));
    final needs = NeedsCubit(repository: repo, clock: () => t0);
    await needs.hydrate();
    final crumbo = CrumboCubit();

    crumbo.setExpression(OwlExpression.bath);
    await needs.boost(NeedKind.clean, BathItem.cleanBoost);
    await needs.boost(NeedKind.fun, BathItem.funBoost);

    expect(crumbo.state.expression, OwlExpression.bath);
    expect(crumbo.state.expression.assetPath, 'assets/rive/owl_bath.riv');
    expect(needs.state.needs.clean, 62);
    expect(needs.state.needs.fun, 48);
    await crumbo.close();
    await needs.close();
  });

  testWidgets('bathroom shows bath tray and bath/clean actions', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomePage(character: SizedBox())),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('bath_tray')), findsNothing);
    expect(find.byKey(const Key('action_bath')), findsOneWidget);

    await tester.tap(find.byKey(const Key('room_bathroom')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('bath_tray')), findsOneWidget);
    expect(find.byKey(const Key('bath_sponge')), findsOneWidget);
    expect(find.byKey(const Key('action_clean')), findsOneWidget);
  });

  testWidgets('bath care tap sets bath riv', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomePage(character: SizedBox())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('action_bath')));
    await tester.pumpAndSettle();

    final crumbo = tester
        .element(find.byKey(const Key('action_bath')))
        .read<CrumboCubit>();
    expect(crumbo.state.expression, OwlExpression.bath);
    expect(crumbo.state.expression.assetPath, 'assets/rive/owl_bath.riv');
  });

  testWidgets('clean tray tap sets clean riv', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomePage(character: SizedBox())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('room_bathroom')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('action_clean')));
    await tester.tap(find.byKey(const Key('action_clean')));
    await tester.pumpAndSettle();

    final crumbo = tester
        .element(find.byKey(const Key('action_clean')))
        .read<CrumboCubit>();
    expect(crumbo.state.expression, OwlExpression.clean);
    expect(crumbo.state.artboardName, 'clean');
  });
}
