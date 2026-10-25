import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../play/domain/play_content.dart';
import '../../play/presentation/content_icon.dart';
import '../../play/presentation/play_content_view.dart';

const _tabs = ['Hats', 'Glasses', 'Neck', 'Others'];

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('market_page'),
      title: 'Market',
      body: PlayContentView(
        builder: (context, content) {
          return DefaultTabController(
            length: _tabs.length,
            child: Column(
              children: [
                const TabBar(
                  isScrollable: true,
                  labelColor: GameColors.purple,
                  tabs: [
                    Tab(text: 'Hats'),
                    Tab(text: 'Glasses'),
                    Tab(text: 'Neck'),
                    Tab(text: 'Others'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      for (final tab in _tabs) _grid(content, tab),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _grid(PlayContent content, String tab) {
    final items = content.market.where((item) => item.tab == tab).toList();
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return DecoratedBox(
          key: Key('market_${item.id}'),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(contentIcon(item.icon), color: GameColors.purple),
              const SizedBox(height: 6),
              Text(item.name, textAlign: TextAlign.center),
            ],
          ),
        );
      },
    );
  }
}
