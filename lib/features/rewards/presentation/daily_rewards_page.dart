import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/currency_pill.dart';
import '../../../core/ui/game_page.dart';
import '../../../core/ui/glossy_button.dart';
import '../../economy/domain/wallet.dart';
import '../../economy/presentation/cubit/economy_cubit.dart';
import '../domain/daily_claim_logic.dart';
import '../domain/daily_streak_state.dart';
import 'cubit/daily_reward_cubit.dart';

class DailyRewardsPage extends StatelessWidget {
  const DailyRewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EconomyCubit()..hydrate(),
      child: Builder(
        builder: (context) {
          return BlocProvider(
            create: (ctx) => DailyRewardCubit(
              economy: ctx.read<EconomyCubit>(),
            )..hydrate(),
            child: const _DailyRewardsView(),
          );
        },
      ),
    );
  }
}

class _DailyRewardsView extends StatelessWidget {
  const _DailyRewardsView();

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('daily_rewards_page'),
      title: 'Daily Rewards',
      body: BlocBuilder<DailyRewardCubit, DailyRewardUiState>(
        builder: (context, daily) {
          if (!daily.ready) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    BlocBuilder<EconomyCubit, Wallet>(
                      builder: (context, wallet) {
                        return CurrencyPill(
                          key: const Key('daily_coin_pill'),
                          kind: CurrencyKind.coin,
                          amount: wallet.coins,
                        );
                      },
                    ),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        _statusText(daily),
                        key: const Key('daily_status_text'),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          color: GameColors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(16),
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    for (final day in daily.catalog.days)
                      _DayTile(
                        day: day.day,
                        coins: day.coins,
                        claimed: DailyClaimLogic.isDayClaimedInCycle(
                          state: daily.streak,
                          day: day.day,
                          now: DateTime.now(),
                        ),
                        claimable: daily.canClaim &&
                            daily.plan.nextDay == day.day,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: GlossyButton(
                  key: const Key('daily_claim_button'),
                  label: daily.canClaim
                      ? 'Claim Day ${daily.plan.nextDay}'
                      : 'Come back tomorrow',
                  onPressed: daily.canClaim
                      ? () => context.read<DailyRewardCubit>().claim()
                      : null,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _statusText(DailyRewardUiState daily) {
    if (daily.plan.availability ==
        DailyClaimAvailability.alreadyClaimedToday) {
      return 'Claimed today — see you tomorrow!';
    }
    if (daily.plan.streakBroken) {
      return 'Streak reset — claim Day 1';
    }
    return 'Streak Day ${daily.streak.streakDay}/7';
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({
    required this.day,
    required this.coins,
    required this.claimed,
    required this.claimable,
  });

  final int day;
  final int coins;
  final bool claimed;
  final bool claimable;

  @override
  Widget build(BuildContext context) {
    final highlight = claimed || claimable;
    return DecoratedBox(
      key: Key('reward_day_$day'),
      decoration: BoxDecoration(
        color: highlight ? GameColors.purple : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: claimable
              ? GameColors.coin
              : claimed
                  ? GameColors.green
                  : Colors.white,
          width: 3,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Day $day',
            style: TextStyle(
              fontFamily: AppTheme.displayFamily,
              color: highlight ? Colors.white : GameColors.ink,
            ),
          ),
          if (claimed)
            const Icon(Icons.check_rounded, color: Colors.white)
          else if (claimable)
            Text(
              '+$coins',
              style: const TextStyle(color: Colors.white),
            )
          else
            const Icon(Icons.lock_rounded, color: GameColors.ink),
        ],
      ),
    );
  }
}
