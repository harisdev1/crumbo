import 'package:flutter/material.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../../core/ui/glossy_button.dart';
import '../domain/play_content.dart';
import 'content_icon.dart';
import 'play_content_view.dart';

const _cardColors = <Color>[
  GameColors.purple,
  Color(0xFF42A5F5),
  GameColors.pink,
  GameColors.green,
  Color(0xFFFF8A65),
  GameColors.coin,
];

class GamesHubPage extends StatelessWidget {
  const GamesHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('games_hub'),
      title: 'Play & Earn',
      body: PlayContentView(
        builder: (context, content) {
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: content.games.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.15,
                  ),
                  itemBuilder: (context, index) {
                    final game = content.games[index];
                    return _GameCard(
                      game: game,
                      color: _cardColors[index % _cardColors.length],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: GlossyButton(
                        key: const Key('preview_game_over'),
                        label: 'Game Over',
                        expand: true,
                        onPressed: () =>
                            pushAppRoute(context, AppRoutes.gameOver),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GlossyButton(
                        key: const Key('preview_reward'),
                        label: 'Reward',
                        expand: true,
                        color: GameColors.coin,
                        onPressed: () =>
                            pushAppRoute(context, AppRoutes.reward),
                      ),
                    ),
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

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game, required this.color});

  final NamedIcon game;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('game_${game.id}'),
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Coming soon'),
              duration: Duration(milliseconds: 800),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(contentIcon(game.icon), color: Colors.white, size: 40),
              const SizedBox(height: 8),
              Text(
                game.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppTheme.displayFamily,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
