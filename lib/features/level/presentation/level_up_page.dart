import 'package:flutter/material.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../../core/ui/glossy_button.dart';
import '../../../core/ui/particle_burst.dart';

class LevelUpPage extends StatelessWidget {
  const LevelUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('level_up_page'),
      title: 'Level Up',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Positioned.fill(
                    child: ParticleBurst(key: Key('level_up_particles')),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFE082), GameColors.coin],
                      ),
                    ),
                    child: const Text(
                      '5',
                      key: Key('level_up_star'),
                      style: TextStyle(
                        fontFamily: AppTheme.displayFamily,
                        fontSize: 64,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'LEVEL UP!',
              style: TextStyle(
                fontFamily: AppTheme.displayFamily,
                fontSize: 32,
                color: GameColors.ink,
              ),
            ),
            const Text(
              '+50',
              key: Key('level_up_bonus'),
              style: TextStyle(
                fontFamily: AppTheme.displayFamily,
                fontSize: 28,
                color: GameColors.purple,
              ),
            ),
            const Spacer(),
            GlossyButton(
              key: const Key('level_up_play'),
              label: 'Play',
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
