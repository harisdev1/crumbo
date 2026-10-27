import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/di/injection.dart';
import '../../../economy/presentation/cubit/economy_cubit.dart';
import '../../data/cards_collection_repository.dart';
import '../../data/task_progress_store.dart';
import '../../domain/card_catalog.dart';
import '../../domain/card_definition.dart';
import '../../domain/card_unlock_ad.dart';

class CollectResult {
  const CollectResult({
    required this.card,
    required this.isNew,
    required this.duplicateCoins,
    required this.count,
  });

  final CardDefinition card;
  final bool isNew;
  final int duplicateCoins;
  final int count;
}

class CardsUiState {
  const CardsUiState({
    required this.cards,
    required this.counts,
    this.ready = false,
  });

  final List<CardDefinition> cards;
  final Map<String, int> counts;
  final bool ready;

  static const empty = CardsUiState(cards: [], counts: {});

  int get ownedDistinct =>
      counts.values.where((c) => c > 0).length;

  int countOf(String id) => counts[id] ?? 0;

  bool isOwned(String id) => countOf(id) >= 1;

  CardsUiState copyWith({
    List<CardDefinition>? cards,
    Map<String, int>? counts,
    bool? ready,
  }) {
    return CardsUiState(
      cards: cards ?? this.cards,
      counts: counts ?? this.counts,
      ready: ready ?? this.ready,
    );
  }
}

class CardsCubit extends Cubit<CardsUiState> {
  CardsCubit({
    required EconomyCubit economy,
    CardsCollectionRepository? collection,
    TaskProgressStore? tasks,
    CardUnlockAd? ad,
    Future<CardCatalog> Function()? catalogLoader,
  })  : _economy = economy,
        _collection = collection ?? _defaultCollection(),
        _tasks = tasks ?? _defaultTasks(),
        _ad = ad ?? const UnavailableCardUnlockAd(),
        _catalogLoader = catalogLoader ?? CardCatalog.load,
        super(CardsUiState.empty);

  static CardsCollectionRepository _defaultCollection() {
    if (GetIt.instance.isRegistered<CardsCollectionRepository>()) {
      return getIt<CardsCollectionRepository>();
    }
    return MemoryCardsCollectionRepository();
  }

  static TaskProgressStore _defaultTasks() {
    if (GetIt.instance.isRegistered<TaskProgressStore>()) {
      return getIt<TaskProgressStore>();
    }
    return MemoryTaskProgressStore();
  }

  final EconomyCubit _economy;
  final CardsCollectionRepository _collection;
  final TaskProgressStore _tasks;
  final CardUnlockAd _ad;
  final Future<CardCatalog> Function() _catalogLoader;

  CardUnlockAd get ad => _ad;
  TaskProgressStore get tasks => _tasks;

  Future<void> hydrate() async {
    final catalog = await _catalogLoader();
    final counts = await _collection.loadCounts();
    if (!isClosed) {
      emit(
        CardsUiState(
          cards: catalog.cards,
          counts: counts,
          ready: true,
        ),
      );
    }
  }

  Future<CollectResult?> collect(String cardId) async {
    CardDefinition? card;
    for (final c in state.cards) {
      if (c.id == cardId) {
        card = c;
        break;
      }
    }
    if (card == null) return null;

    final previous = state.countOf(cardId);
    final nextCount = await _collection.addCopy(cardId);
    final isNew = previous == 0;
    var bonus = 0;
    if (!isNew) {
      bonus = DuplicateCoinTable.forRarity(card.rarity);
      if (bonus > 0) await _economy.addCoins(bonus);
    }
    final counts = await _collection.loadCounts();
    if (!isClosed) emit(state.copyWith(counts: counts));
    return CollectResult(
      card: card,
      isNew: isNew,
      duplicateCoins: bonus,
      count: nextCount,
    );
  }

  /// Coin unlock path. Returns collect result or null on failure.
  Future<CollectResult?> unlockWithCoins(String cardId) async {
    CardDefinition? card;
    for (final c in state.cards) {
      if (c.id == cardId) {
        card = c;
        break;
      }
    }
    if (card == null) return null;
    CardUnlock? coinsUnlock;
    for (final u in card.unlock) {
      if (u.method == UnlockMethod.coins) {
        coinsUnlock = u;
        break;
      }
    }
    if (coinsUnlock?.price == null) return null;
    final paid = await _economy.spendCoins(coinsUnlock!.price!);
    if (!paid) return null;
    return collect(cardId);
  }

  Future<CollectResult?> unlockWithTask(String cardId) async {
    CardDefinition? card;
    for (final c in state.cards) {
      if (c.id == cardId) {
        card = c;
        break;
      }
    }
    if (card == null) return null;
    CardUnlock? taskUnlock;
    for (final u in card.unlock) {
      if (u.method == UnlockMethod.task && u.need != null) {
        taskUnlock = u;
        break;
      }
    }
    if (taskUnlock?.need == null) return null;
    if (!await _tasks.meets(taskUnlock!.need!)) return null;
    return collect(cardId);
  }
}
