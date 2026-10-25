import 'package:flutter/material.dart';

import '../router/app_routes.dart';
import '../theme/app_theme.dart';
import 'glossy_icon_button.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    super.key,
    required this.title,
    required this.body,
    this.pageKey,
  });

  final String title;
  final Widget body;
  final Key? pageKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: pageKey,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE4DCFF), Color(0xFFF8F5FF), Color(0xFFFFF7FB)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Row(
                  children: [
                    GlossyIconButton(
                      icon: Icons.arrow_back_rounded,
                      color: GameColors.purple,
                      size: 44,
                      onTap: () => popAppRoute(context),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: AppTheme.displayFamily,
                          fontSize: 26,
                          color: GameColors.ink,
                        ),
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}
