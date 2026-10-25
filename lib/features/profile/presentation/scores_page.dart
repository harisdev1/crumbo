import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../play/presentation/play_content_view.dart';

class ScoresPage extends StatelessWidget {
  const ScoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('scores_page'),
      title: 'My Best Scores',
      body: PlayContentView(
        builder: (context, content) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final score in content.scores)
                ListTile(
                  key: Key('score_${score.game}'),
                  title: Text(score.game),
                  trailing: Text(
                    '${score.score}',
                    style: const TextStyle(
                      fontFamily: AppTheme.displayFamily,
                      fontSize: 22,
                      color: GameColors.purple,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
