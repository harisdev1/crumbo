import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../../core/ui/glossy_button.dart';
import '../../play/domain/play_content.dart';
import '../../play/presentation/play_content_view.dart';
import 'parental_gate.dart';

enum _Shelf { none, coins, gems }

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  var _shelf = _Shelf.none;

  Future<void> _open(bool coins) async {
    final ok = await showParentalGate(context);
    if (!ok || !mounted) return;
    setState(() => _shelf = coins ? _Shelf.coins : _Shelf.gems);
  }

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('store_page'),
      title: 'Get Coins',
      body: PlayContentView(
        builder: (context, content) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              GlossyButton(
                key: const Key('get_coins'),
                label: 'Get Coins',
                expand: true,
                color: GameColors.coin,
                onPressed: () {
                  _open(true);
                },
              ),
              const SizedBox(height: 10),
              GlossyButton(
                key: const Key('get_gems'),
                label: 'Get Gems',
                expand: true,
                onPressed: () {
                  _open(false);
                },
              ),
              const SizedBox(height: 16),
              if (_shelf == _Shelf.coins)
                _packs(content.coinPacks, const Key('coin_prices')),
              if (_shelf == _Shelf.gems)
                _packs(content.gemPacks, const Key('gem_prices')),
            ],
          );
        },
      ),
    );
  }

  Widget _packs(List<PricePack> packs, Key key) {
    return Column(
      key: key,
      children: [
        for (final pack in packs)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text('${pack.amount}  ${pack.price}'),
                ),
                GlossyButton(
                  key: Key('buy_${pack.id}'),
                  label: 'Coming soon',
                  onPressed: null,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
