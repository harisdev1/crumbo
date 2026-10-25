import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../../core/ui/rounded_progress_bar.dart';
import '../../play/presentation/play_content_view.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('achievements_page'),
      title: 'Achievements',
      body: PlayContentView(
        builder: (context, content) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final item in content.achievements)
                Padding(
                  key: Key('achievement_${item.id}'),
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontFamily: AppTheme.displayFamily,
                              color: GameColors.ink,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RoundedProgressBar(value: item.fraction),
                          Text('${item.progress}/${item.goal}'),
                        ],
                      ),
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
