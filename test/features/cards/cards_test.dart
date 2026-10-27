import 'package:crumbo/features/cards/data/cards_collection_repository.dart';
import 'package:crumbo/features/cards/domain/card_catalog.dart';
import 'package:crumbo/features/cards/domain/card_definition.dart';
import 'package:crumbo/features/cards/presentation/album_page.dart';
import 'package:crumbo/features/cards/presentation/card_reveal_page.dart';
import 'package:crumbo/features/cards/presentation/cubit/cards_cubit.dart';
import 'package:crumbo/features/economy/data/economy_repository.dart';
import 'package:crumbo/features/economy/domain/wallet.dart';
import 'package:crumbo/features/economy/presentation/cubit/economy_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    CardCatalog.debugReset();
  });

  test('cards.json parses and every card has non-ad unlock', () async {
    final catalog = await CardCatalog.load();
    expect(catalog.cards, isNotEmpty);
    expect(catalog.findById('outfit_chef_hat'), isNotNull);
    for (final card in catalog.cards) {
      expect(card.hasNonAdUnlock, isTrue, reason: card.id);
    }
  });

  test('reject ad-only card', () {
    expect(
      () => CardCatalog.parse('''
{
  "cards": [
    {
      "id": "bad",
      "name": "Bad",
      "type": "sticker",
      "rarity": "common",
      "set": "x",
      "unlock": [{"method": "ad", "placement": "p"}]
    }
  ]
}
'''),
      throwsFormatException,
    );
  });

  test('collect new then duplicate grants coins', () async {
    final economy = EconomyCubit(repository: MemoryEconomyRepository());
    await economy.hydrate();
    final collection = MemoryCardsCollectionRepository();
    final cubit = CardsCubit(
      economy: economy,
      collection: collection,
      catalogLoader: CardCatalog.load,
    );
    await cubit.hydrate();

    final first = await cubit.collect('food_cookie_card');
    expect(first?.isNew, isTrue);
    expect(first?.duplicateCoins, 0);
    expect(economy.state.coins, Wallet.starterCoins);

    final second = await cubit.collect('food_cookie_card');
    expect(second?.isNew, isFalse);
    expect(second?.duplicateCoins, DuplicateCoinTable.forRarity(CardRarity.common));
    expect(
      economy.state.coins,
      Wallet.starterCoins + DuplicateCoinTable.forRarity(CardRarity.common),
    );

    expect(await cubit.unlockWithCoins('surprise_golden_crumb'), isNull);
    expect(economy.state.coins, Wallet.starterCoins + 5);

    await economy.addCoins(400);
    final bought = await cubit.unlockWithCoins('food_jam_card');
    expect(bought?.isNew, isTrue);

    await cubit.close();
    await economy.close();
  });

  testWidgets('album shows locked cards and progress', (tester) async {
    const mini = '''
{
  "cards": [
    {
      "id": "outfit_chef_hat",
      "name": "Chef Hat",
      "type": "outfit",
      "rarity": "common",
      "set": "chef",
      "unlock": [{"method": "coins", "price": 10}]
    }
  ]
}
''';
    final economy = EconomyCubit(repository: MemoryEconomyRepository());
    await economy.hydrate();
    final cards = CardsCubit(
      economy: economy,
      collection: MemoryCardsCollectionRepository(),
      catalogLoader: () async => CardCatalog.parse(mini),
    );
    await cards.hydrate();

    await tester.pumpWidget(
      MaterialApp(home: AlbumPage(economy: economy, cards: cards)),
    );
    await tester.pump();

    expect(find.byKey(const Key('album_page')), findsOneWidget);
    expect(find.byKey(const Key('album_progress')), findsOneWidget);
    expect(find.text('0/1'), findsOneWidget);
    expect(
      find.byKey(const Key('album_locked_outfit_chef_hat')),
      findsOneWidget,
    );
    await economy.close();
    await cards.close();
  });

  testWidgets('flip reveal shows NEW', (tester) async {
    final card = CardDefinition(
      id: 't',
      name: 'Test',
      type: CardType.sticker,
      rarity: CardRarity.common,
      setId: 's',
      unlock: const [
        CardUnlock(method: UnlockMethod.coins, price: 1),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: CardRevealPage(card: card, isNew: true),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('card_reveal_new')), findsOneWidget);
    expect(find.byKey(const Key('card_flip_back')), findsOneWidget);
  });
}
