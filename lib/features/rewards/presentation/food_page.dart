import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../crumbo/presentation/cubit/crumbo_cubit.dart';
import '../../play/presentation/content_icon.dart';
import '../../play/presentation/play_content_view.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('food_page'),
      title: 'Food',
      body: PlayContentView(
        builder: (context, content) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: content.foods.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final food = content.foods[index];
              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  key: Key('food_${food.id}'),
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => _feed(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(contentIcon(food.icon), color: GameColors.purple),
                      const SizedBox(height: 6),
                      Text(food.name, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _feed(BuildContext context) {
    try {
      context.read<CrumboCubit>().toggleEat();
    } catch (_) {
      // Food still works as a static menu when no owl cubit is above us.
    }
  }
}
