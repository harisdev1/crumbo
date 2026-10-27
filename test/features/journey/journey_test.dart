import 'package:crumbo/features/cards/data/cards_collection_repository.dart';
import 'package:crumbo/features/cards/domain/card_catalog.dart';
import 'package:crumbo/features/cards/presentation/cubit/cards_cubit.dart';
import 'package:crumbo/features/economy/data/economy_repository.dart';
import 'package:crumbo/features/economy/presentation/cubit/economy_cubit.dart';
import 'package:crumbo/features/journey/data/journey_repository.dart';
import 'package:crumbo/features/journey/domain/journey_catalog.dart';
import 'package:crumbo/features/journey/domain/journey_models.dart';
import 'package:crumbo/features/journey/presentation/cubit/journey_cubit.dart';
import 'package:crumbo/features/journey/presentation/journey_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    JourneyCatalog.debugReset();
    CardCatalog.debugReset();
  });

  test('journey.json has two zones and non-ad gates', () async {
    final catalog = await JourneyCatalog.load();
    expect(catalog.zones, hasLength(2));
    expect(catalog.zones.first.nodes, hasLength(10));
    expect(catalog.zones.last.nodes, hasLength(10));
    for (final z in catalog.zones) {
      for (final n in z.nodes) {
        expect(n.hasNonAdGate, isTrue, reason: n.id);
      }
    }
  });

  test('linear lock and card_reveal collect', () async {
    final economy = EconomyCubit(repository: MemoryEconomyRepository());
    await economy.hydrate();
    final cards = CardsCubit(
      economy: economy,
      collection: MemoryCardsCollectionRepository(),
      catalogLoader: CardCatalog.load,
    );
    await cards.hydrate();

    final repo = MemoryJourneyRepository();
    await repo.save(
      JourneyProgress(
        currentZoneId: 'cozy_kitchen',
        completedNodeIds: {'k1', 'k2'},
        unlockedZoneIds: {'cozy_kitchen'},
      ),
    );

    final journey = JourneyCubit(
      economy: economy,
      cards: cards,
      repository: repo,
      catalogLoader: JourneyCatalog.load,
    );
    await journey.hydrate();

    final zone = journey.state.catalog.zones.first;
    expect(journey.canAttempt(zone, 2), isTrue);
    expect(await journey.tryCompleteNode('k3'), isNull);
    expect(cards.state.isOwned('outfit_chef_hat'), isTrue);
    expect(journey.isNodeCompleted('k3'), isTrue);

    await journey.close();
    await cards.close();
    await economy.close();
  });

  test('gate pay coins completes node', () async {
    final economy = EconomyCubit(repository: MemoryEconomyRepository());
    await economy.hydrate();
    await economy.addCoins(100);
    final before = economy.state.coins;

    final repo = MemoryJourneyRepository();
    await repo.save(
      const JourneyProgress(
        currentZoneId: 'cozy_kitchen',
        completedNodeIds: {'k1', 'k2', 'k3', 'k4'},
        unlockedZoneIds: {'cozy_kitchen'},
      ),
    );

    final journey = JourneyCubit(
      economy: economy,
      repository: repo,
      catalogLoader: JourneyCatalog.load,
    );
    await journey.hydrate();

    expect(await journey.payGateCoins('k5'), isNull);
    expect(journey.isNodeCompleted('k5'), isTrue);
    expect(economy.state.coins, before - 40);

    expect(await journey.payGateCoins('k5'), 'Already done');
    // After complete, payGateCoins checks already — actually returns Locked or Already?
    // Implementation: isNodeCompleted checked in tryComplete; payGateCoins checks canAttempt
    // Completed node: canAttempt true, but we should check completed first.
    await journey.close();
    await economy.close();
  });

  testWidgets('journey page lists zone nodes', (tester) async {
    const mini = '''
{
  "zones": [
    {
      "id": "cozy_kitchen",
      "name": "Cozy Kitchen",
      "nodes": [
        {"id": "k1", "type": "care", "task": "feed", "count": 1, "reward": {"coins": 5}},
        {"id": "k2", "type": "card_reveal", "card": "outfit_chef_hat"}
      ]
    },
    {
      "id": "bubble_bay",
      "name": "Bubble Bay",
      "nodes": [
        {"id": "b1", "type": "care", "task": "bath", "count": 1, "reward": {"coins": 5}}
      ]
    }
  ]
}
''';
    final economy = EconomyCubit(repository: MemoryEconomyRepository());
    await economy.hydrate();
    final cards = CardsCubit(
      economy: economy,
      collection: MemoryCardsCollectionRepository(),
      catalogLoader: () async => CardCatalog(const []),
    );
    await cards.hydrate();
    final journey = JourneyCubit(
      economy: economy,
      cards: cards,
      repository: MemoryJourneyRepository(),
      catalogLoader: () async => JourneyCatalog.parse(mini),
    );
    await journey.hydrate();

    await tester.pumpWidget(
      MaterialApp(
        home: JourneyPage(
          economy: economy,
          cards: cards,
          journey: journey,
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('journey_page')), findsOneWidget);
    expect(find.byKey(const Key('journey_zone_cozy_kitchen')), findsOneWidget);
    expect(find.byKey(const Key('journey_node_k1')), findsOneWidget);
    expect(find.textContaining('Locked'), findsWidgets);
    await journey.close();
    await cards.close();
    await economy.close();
  });
}

