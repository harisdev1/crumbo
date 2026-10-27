import 'package:flutter/material.dart';

import '../../../core/ui/game_page.dart';
import '../../../core/ui/glossy_button.dart';
import '../domain/card_definition.dart';
import 'widgets/card_flip_reveal.dart';

class CardRevealPage extends StatelessWidget {
  const CardRevealPage({
    super.key,
    required this.card,
    required this.isNew,
    this.duplicateCoins = 0,
  });

  final CardDefinition card;
  final bool isNew;
  final int duplicateCoins;

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    return GamePage(
      pageKey: const Key('card_reveal_page'),
      title: 'Card Reveal',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CardFlipReveal(
              key: const Key('card_flip'),
              card: card,
              isNew: isNew,
              duplicateCoins: duplicateCoins,
              reduceMotion: reduce,
            ),
            const SizedBox(height: 24),
            GlossyButton(
              key: const Key('card_reveal_close'),
              label: 'Nice!',
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
      ),
    );
  }
}
