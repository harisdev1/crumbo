import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../../core/ui/glossy_button.dart';
import '../../play/domain/play_content.dart';
import '../../play/presentation/play_content_view.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('shop_page'),
      title: 'Shop',
      body: PlayContentView(
        builder: (context, content) {
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  labelColor: GameColors.purple,
                  tabs: [
                    Tab(text: 'Items'),
                    Tab(text: 'Themes'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _cards(content, 'Items'),
                      _cards(content, 'Themes'),
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

  Widget _cards(PlayContent content, String tab) {
    final items = content.shopItems.where((item) => item.tab == tab).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _PriceCard(item: item),
          ),
      ],
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.item});

  final ShopItem item;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontFamily: AppTheme.displayFamily,
                      fontSize: 18,
                      color: GameColors.ink,
                    ),
                  ),
                  Text(item.price),
                ],
              ),
            ),
            GlossyButton(
              key: Key('shop_buy_${item.id}'),
              label: 'Coming soon',
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }
}
