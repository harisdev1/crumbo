import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../../core/ui/glossy_button.dart';
import '../../economy/domain/wallet.dart';
import '../../economy/presentation/cubit/economy_cubit.dart';
import '../domain/shop_catalog_item.dart';
import 'cubit/shop_cubit.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EconomyCubit()..hydrate(),
      child: Builder(
        builder: (context) {
          return BlocProvider(
            create: (ctx) => ShopCubit(economy: ctx.read<EconomyCubit>())
              ..hydrate(),
            child: const _ShopView(),
          );
        },
      ),
    );
  }
}

class _ShopView extends StatelessWidget {
  const _ShopView();

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('shop_page'),
      title: 'Shop',
      body: BlocBuilder<ShopCubit, ShopState>(
        builder: (context, shop) {
          if (!shop.ready) {
            return const Center(child: CircularProgressIndicator());
          }
          final tabs = shop.categories;
          if (tabs.isEmpty) {
            return const Center(child: Text('No items yet'));
          }
          return DefaultTabController(
            length: tabs.length,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  labelColor: GameColors.purple,
                  tabs: [
                    for (final tab in tabs)
                      Tab(
                        key: Key('shop_tab_$tab'),
                        text: _titleCase(tab),
                      ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      for (final tab in tabs)
                        _CategoryList(category: tab),
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
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopCubit, ShopState>(
      builder: (context, shop) {
        final items = shop.byCategory(category);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ShopCard(item: item),
              ),
          ],
        );
      },
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({required this.item});

  final ShopCatalogItem item;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopCubit, ShopState>(
      builder: (context, shop) {
        return BlocBuilder<EconomyCubit, Wallet>(
          builder: (context, wallet) {
            final owned = shop.isOwned(item.id);
            final canAfford = item.currency == ShopCurrency.gems
                ? wallet.gems >= item.price
                : wallet.coins >= item.price;
            final currencyIcon = item.currency == ShopCurrency.gems
                ? Icons.diamond_rounded
                : Icons.monetization_on_rounded;
            final currencyColor = item.currency == ShopCurrency.gems
                ? GameColors.gem
                : GameColors.coin;

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
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(currencyIcon, size: 18, color: currencyColor),
                              const SizedBox(width: 4),
                              Text(
                                '${item.price}',
                                style: TextStyle(
                                  fontFamily: AppTheme.fontFamily,
                                  fontSize: 15,
                                  color: currencyColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (owned)
                      GlossyButton(
                        key: Key('shop_owned_${item.id}'),
                        label: 'Owned',
                        onPressed: null,
                      )
                    else
                      GlossyButton(
                        key: Key('shop_buy_${item.id}'),
                        label: 'Buy',
                        onPressed: canAfford
                            ? () => _onBuy(context, item.id)
                            : null,
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onBuy(BuildContext context, String id) async {
    final shop = context.read<ShopCubit>();
    final ok = await shop.buy(id);
    if (!context.mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough coins or gems')),
      );
    }
  }
}

String _titleCase(String raw) {
  if (raw.isEmpty) return raw;
  return '${raw[0].toUpperCase()}${raw.substring(1)}';
}
