import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../../core/ui/glossy_button.dart';
import '../../../core/router/app_routes.dart';

class GameOverPage extends StatelessWidget {
  const GameOverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('game_over_page'),
      title: 'Game Over',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              'Your score',
              style: TextStyle(
                fontFamily: AppTheme.displayFamily,
                fontSize: 22,
                color: GameColors.ink,
              ),
            ),
            const Text(
              '0',
              key: Key('game_over_score'),
              style: TextStyle(
                fontFamily: AppTheme.displayFamily,
                fontSize: 64,
                color: GameColors.purple,
              ),
            ),
            const Text(
              '+0',
              key: Key('game_over_bonus'),
              style: TextStyle(
                fontFamily: AppTheme.displayFamily,
                fontSize: 28,
                color: GameColors.coin,
              ),
            ),
            const Spacer(),
            GlossyButton(
              label: 'Home',
              expand: true,
              onPressed: () => popAppRoute(context),
            ),
          ],
        ),
      ),
    );
  }
}
