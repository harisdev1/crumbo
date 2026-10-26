import 'package:crumbo/features/crumbo/data/needs_repository.dart';
import 'package:crumbo/features/crumbo/domain/pet_mood.dart';
import 'package:crumbo/features/crumbo/domain/pet_needs.dart';
import 'package:crumbo/features/crumbo/presentation/cubit/needs_cubit.dart';
import 'package:crumbo/features/home/presentation/pages/home_page.dart';
import 'package:crumbo/features/home/presentation/widgets/needs_meter_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/hive_test_setup.dart';

void main() {
  setUp(() async {
    await configureMemoryPreferences();
  });

  testWidgets('NeedsMeterRow shows five meters and Happy chip', (tester) async {
    final repo = MemoryNeedsRepository();
    final t0 = DateTime.utc(2026, 10, 25);
    await repo.save(PetNeeds.fresh(at: t0));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => NeedsCubit(
            repository: repo,
            clock: () => t0,
          )..hydrate(),
          child: const Scaffold(body: NeedsMeterRow()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('needs_meter_row')), findsOneWidget);
    expect(find.byKey(const Key('need_hunger')), findsOneWidget);
    expect(find.byKey(const Key('need_sleep')), findsOneWidget);
    expect(find.byKey(const Key('need_fun')), findsOneWidget);
    expect(find.byKey(const Key('need_clean')), findsOneWidget);
    expect(find.byKey(const Key('need_love')), findsOneWidget);
    expect(find.byKey(const Key('pet_mood_chip')), findsOneWidget);
    expect(find.text('Mood: ${PetMood.happy.label}'), findsOneWidget);
  });

  testWidgets('HomePage includes needs meter row', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomePage(character: SizedBox())),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('needs_meter_row')), findsOneWidget);
    expect(find.byKey(const Key('pet_mood_chip')), findsOneWidget);
  });
}
