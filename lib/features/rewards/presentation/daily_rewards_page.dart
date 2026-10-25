import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../play/presentation/play_content_view.dart';

class DailyRewardsPage extends StatelessWidget {
  const DailyRewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('daily_rewards_page'),
      title: 'Daily Rewards',
      body: PlayContentView(
        builder: (context, content) {
          return GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              for (final day in content.rewards)
                DecoratedBox(
                  key: Key('reward_day_${day.day}'),
                  decoration: BoxDecoration(
                    color: day.unlocked ? GameColors.purple : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: day.unlocked ? GameColors.coin : Colors.white,
                      width: 3,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Day ${day.day}',
                        style: TextStyle(
                          fontFamily: AppTheme.displayFamily,
                          color: day.unlocked ? Colors.white : GameColors.ink,
                        ),
                      ),
                      if (day.unlocked)
                        Text(
                          '+${day.coins}',
                          style: const TextStyle(color: Colors.white),
                        )
                      else
                        const Icon(Icons.lock_rounded, color: GameColors.ink),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
