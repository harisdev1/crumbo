import 'package:crumbo/features/economy/data/economy_repository.dart';
import 'package:crumbo/features/economy/domain/wallet.dart';
import 'package:crumbo/features/economy/presentation/cubit/economy_cubit.dart';
import 'package:crumbo/features/shop/data/inventory_repository.dart';
import 'package:crumbo/features/shop/domain/shop_catalog.dart';
import 'package:crumbo/features/shop/domain/shop_catalog_item.dart';
import 'package:crumbo/features/shop/presentation/cubit/shop_cubit.dart';
import 'package:crumbo/features/shop/presentation/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/hive_test_setup.dart';

const _miniCatalogJson = '''
{
  "items": [
    {
      "id": "snack_cookie",
      "name": "Cookie Pack",
      "category": "food",
      "currency": "coins",
      "price": 20,
      "icon": "cookie"
    },
    {
      "id": "sparkle_pack",
      "name": "Sparkle Pack",
      "category": "items",
      "currency": "gems",
      "price": 2,
      "icon": "sparkle"
    },
    {
      "id": "pricey",
      "name": "Pricey Thing",
      "category": "items",
      "currency": "coins",
      "price": 9999,
      "icon": "star"
    }
  ]
}
''';

void main() {
  setUp(() {
    ShopCatalog.debugReset();
  });

  test('catalog parse categories and currency', () {
    final catalog = ShopCatalog.parse(_miniCatalogJson);
    expect(catalog.items, hasLength(3));
    expect(catalog.categories, ['food', 'items']);
    expect(catalog.findById('snack_cookie')?.currency, ShopCurrency.coins);
    expect(catalog.findById('sparkle_pack')?.currency, ShopCurrency.gems);
    expect(catalog.findById('snack_cookie')?.price, 20);
  });

  test('buy deducts coins and owns; insufficient no-op; double-buy safe',
      () async {
    final economyRepo = MemoryEconomyRepository();
    final inventory = MemoryInventoryRepository();
    final economy = EconomyCubit(repository: economyRepo);
    await economy.hydrate();
    expect(economy.state.coins, Wallet.starterCoins);

    final shop = ShopCubit(
      economy: economy,
      inventory: inventory,
      catalogLoader: () async => ShopCatalog.parse(_miniCatalogJson),
    );
    await shop.hydrate();

    expect(await shop.buy('pricey'), isFalse);
    expect(economy.state.coins, Wallet.starterCoins);
    expect(shop.state.isOwned('pricey'), isFalse);

    expect(await shop.buy('snack_cookie'), isTrue);
    expect(economy.state.coins, Wallet.starterCoins - 20);
    expect(shop.state.isOwned('snack_cookie'), isTrue);
    expect(await inventory.loadOwned(), contains('snack_cookie'));

    expect(await shop.buy('snack_cookie'), isTrue);
    expect(economy.state.coins, Wallet.starterCoins - 20);

    expect(await shop.buy('sparkle_pack'), isTrue);
    expect(economy.state.gems, Wallet.starterGems - 2);

    await shop.close();
    await economy.close();
  });

  testWidgets('shop lists JSON items and buy marks owned', (tester) async {
    await configureMemoryPreferences();
    ShopCatalog.debugReset();

    await tester.pumpWidget(const MaterialApp(home: ShopPage()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('shop_page')), findsOneWidget);
    expect(find.byKey(const Key('shop_tab_food')), findsOneWidget);
    expect(find.text('Cookie Pack'), findsOneWidget);
    expect(find.byKey(const Key('shop_buy_snack_cookie')), findsOneWidget);

    await tester.tap(find.byKey(const Key('shop_buy_snack_cookie')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('shop_owned_snack_cookie')), findsOneWidget);
    expect(find.byKey(const Key('shop_buy_snack_cookie')), findsNothing);
  });
}
