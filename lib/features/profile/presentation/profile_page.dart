import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../../core/ui/rounded_progress_bar.dart';
import '../../play/presentation/play_content_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('profile_page'),
      title: 'Player',
      body: PlayContentView(
        builder: (context, content) {
          final profile = content.profile;
          final goal = profile.xpGoal <= 0 ? 1 : profile.xpGoal;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const CircleAvatar(
                radius: 42,
                backgroundColor: GameColors.purple,
                child: Icon(Icons.pets_rounded, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 12),
              Text(
                profile.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppTheme.displayFamily,
                  fontSize: 28,
                  color: GameColors.ink,
                ),
              ),
              Text(
                'Level ${profile.level}',
                textAlign: TextAlign.center,
                key: const Key('profile_level'),
                style: const TextStyle(
                  fontFamily: AppTheme.displayFamily,
                  fontSize: 20,
                  color: GameColors.purple,
                ),
              ),
              const SizedBox(height: 12),
              RoundedProgressBar(value: profile.xp / goal),
              const SizedBox(height: 16),
              Text('Games played: ${profile.gamesPlayed}'),
              const Text('Best score: 0'),
            ],
          );
        },
      ),
    );
  }
}
