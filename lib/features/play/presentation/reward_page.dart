import 'package:flutter/material.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../../core/ui/glossy_button.dart';

class RewardPage extends StatelessWidget {
  const RewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('reward_page'),
      title: 'Reward',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.inbox_rounded, size: 96, color: GameColors.coin),
            const SizedBox(height: 12),
            const Text(
              'You got',
              style: TextStyle(
                fontFamily: AppTheme.displayFamily,
                fontSize: 28,
                color: GameColors.ink,
              ),
            ),
            const Text(
              '+0',
              key: Key('reward_amount'),
              style: TextStyle(
                fontFamily: AppTheme.displayFamily,
                fontSize: 40,
                color: GameColors.purple,
              ),
            ),
            const Spacer(),
            GlossyButton(
              key: const Key('reward_claim'),
              label: 'Claim',
              expand: true,
              color: GameColors.green,
              onPressed: () => popAppRoute(context),
            ),
          ],
        ),
      ),
    );
  }
}
