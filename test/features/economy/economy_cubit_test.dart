import 'package:crumbo/features/economy/data/economy_repository.dart';
import 'package:crumbo/features/economy/domain/wallet.dart';
import 'package:crumbo/features/economy/presentation/cubit/economy_cubit.dart';
import 'package:crumbo/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/hive_test_setup.dart';

void main() {
  test('wallet add and spend', () {
    var wallet = const Wallet(coins: 40, gems: 3);
    wallet = wallet.addCoins(10);
    expect(wallet.coins, 50);
    expect(wallet.trySpendCoins(60), isNull);
    expect(wallet.trySpendCoins(20)?.coins, 30);
    expect(wallet.trySpendGems(5), isNull);
    expect(wallet.trySpendGems(2)?.gems, 1);
  });

  test('EconomyCubit hydrate starter and spend safe', () async {
    final repo = MemoryEconomyRepository();
    final cubit = EconomyCubit(repository: repo);
    await cubit.hydrate();
    expect(cubit.state.coins, Wallet.starterCoins);
    expect(cubit.state.gems, Wallet.starterGems);

    expect(await cubit.spendCoins(9999), isFalse);
    expect(cubit.state.coins, Wallet.starterCoins);

    expect(await cubit.spendCoins(10), isTrue);
    expect(cubit.state.coins, Wallet.starterCoins - 10);

    await cubit.addGems(2);
    expect(cubit.state.gems, Wallet.starterGems + 2);

    await cubit.close();
  });

  testWidgets('home currency pills show starter wallet', (tester) async {
    await configureMemoryPreferences();
    await tester.pumpWidget(
      const MaterialApp(home: HomePage(character: SizedBox())),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('coin_pill')), findsOneWidget);
    expect(find.text('${Wallet.starterCoins}'), findsWidgets);
    expect(find.text('${Wallet.starterGems}'), findsWidgets);
  });

  testWidgets('home currency pills update after boost', (tester) async {
    await configureMemoryPreferences();
    await tester.pumpWidget(
      const MaterialApp(home: HomePage(character: SizedBox())),
    );
    await tester.pumpAndSettle();

    final economy = tester
        .element(find.byKey(const Key('coin_pill')))
        .read<EconomyCubit>();
    await economy.addCoins(25);
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('coin_pill')),
        matching: find.text('${Wallet.starterCoins + 25}'),
      ),
      findsOneWidget,
    );
  });
}
