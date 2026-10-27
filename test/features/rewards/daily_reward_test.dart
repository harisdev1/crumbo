import 'package:crumbo/features/economy/data/economy_repository.dart';
import 'package:crumbo/features/economy/domain/wallet.dart';
import 'package:crumbo/features/economy/presentation/cubit/economy_cubit.dart';
import 'package:crumbo/features/rewards/data/daily_reward_repository.dart';
import 'package:crumbo/features/rewards/domain/daily_claim_logic.dart';
import 'package:crumbo/features/rewards/domain/daily_rewards_catalog.dart';
import 'package:crumbo/features/rewards/domain/daily_streak_state.dart';
import 'package:crumbo/features/rewards/presentation/cubit/daily_reward_cubit.dart';
import 'package:crumbo/features/rewards/presentation/daily_rewards_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/hive_test_setup.dart';

const _catalogJson = '''
{
  "days": [
    {"day": 1, "coins": 50},
    {"day": 2, "coins": 50},
    {"day": 3, "coins": 75},
    {"day": 4, "coins": 75},
    {"day": 5, "coins": 100},
    {"day": 6, "coins": 100},
    {"day": 7, "coins": 250}
  ]
}
''';

void main() {
  setUp(() {
    DailyRewardsCatalog.debugReset();
  });

  test('catalog parse day 7 big gift', () {
    final catalog = DailyRewardsCatalog.parse(_catalogJson);
    expect(catalog.days, hasLength(7));
    expect(catalog.coinsFor(7), 250);
    expect(catalog.coinsFor(1), 50);
  });

  test('claim evaluator already claimed / miss reset / day7 cycle', () {
    final t0 = DateTime(2026, 10, 27);
    var state = const DailyStreakState(streakDay: 0);
    var plan = DailyClaimLogic.evaluate(state: state, now: t0);
    expect(plan.availability, DailyClaimAvailability.canClaim);
    expect(plan.nextDay, 1);

    state = DailyClaimLogic.applyClaim(state: state, claimedDay: 1, now: t0);
    plan = DailyClaimLogic.evaluate(state: state, now: t0);
    expect(plan.availability, DailyClaimAvailability.alreadyClaimedToday);

    final nextDay = t0.add(const Duration(days: 1));
    plan = DailyClaimLogic.evaluate(state: state, now: nextDay);
    expect(plan.nextDay, 2);
    expect(plan.streakBroken, isFalse);

    final missed = t0.add(const Duration(days: 3));
    plan = DailyClaimLogic.evaluate(state: state, now: missed);
    expect(plan.streakBroken, isTrue);
    expect(plan.nextDay, 1);

    state = const DailyStreakState(
      streakDay: 7,
      lastClaimDate: '2026-10-26',
    );
    plan = DailyClaimLogic.evaluate(
      state: state,
      now: DateTime(2026, 10, 27),
    );
    expect(plan.nextDay, 1);
    expect(plan.streakBroken, isFalse);
  });

  test('cubit grants coins once per day', () async {
    final economy = EconomyCubit(repository: MemoryEconomyRepository());
    await economy.hydrate();
    final repo = MemoryDailyRewardRepository();
    var now = DateTime(2026, 10, 27);
    final cubit = DailyRewardCubit(
      economy: economy,
      repository: repo,
      catalogLoader: () async => DailyRewardsCatalog.parse(_catalogJson),
      clock: () => now,
    );
    await cubit.hydrate();

    expect(await cubit.claim(), isTrue);
    expect(economy.state.coins, Wallet.starterCoins + 50);
    expect(await cubit.claim(), isFalse);
    expect(economy.state.coins, Wallet.starterCoins + 50);

    now = DateTime(2026, 10, 28);
    await cubit.hydrate();
    expect(await cubit.claim(), isTrue);
    expect(economy.state.coins, Wallet.starterCoins + 100);

    await cubit.close();
    await economy.close();
  });

  testWidgets('daily page claim marks day and boosts coins', (tester) async {
    await configureMemoryPreferences();
    DailyRewardsCatalog.debugReset();
    await tester.pumpWidget(const MaterialApp(home: DailyRewardsPage()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('daily_rewards_page')), findsOneWidget);
    expect(find.byKey(const Key('daily_claim_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('daily_claim_button')));
    await tester.pumpAndSettle();

    expect(find.text('Come back tomorrow'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('daily_coin_pill')),
        matching: find.text('${Wallet.starterCoins + 50}'),
      ),
      findsOneWidget,
    );
  });
}
