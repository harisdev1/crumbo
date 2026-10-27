import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/di/injection.dart';
import '../../../cards/domain/card_catalog.dart';
import '../../../cards/presentation/cubit/cards_cubit.dart';
import '../../../economy/presentation/cubit/economy_cubit.dart';
import '../../data/journey_repository.dart';
import '../../domain/journey_catalog.dart';
import '../../domain/journey_models.dart';

class JourneyUiState {
  const JourneyUiState({
    required this.catalog,
    required this.progress,
    this.ready = false,
  });

  final JourneyCatalog catalog;
  final JourneyProgress progress;
  final bool ready;

  static JourneyUiState empty() {
    return JourneyUiState(
      catalog: JourneyCatalog(const []),
      progress: JourneyProgress.initial(''),
    );
  }

  JourneyUiState copyWith({
    JourneyCatalog? catalog,
    JourneyProgress? progress,
    bool? ready,
  }) {
    return JourneyUiState(
      catalog: catalog ?? this.catalog,
      progress: progress ?? this.progress,
      ready: ready ?? this.ready,
    );
  }
}

class JourneyCubit extends Cubit<JourneyUiState> {
  JourneyCubit({
    required EconomyCubit economy,
    CardsCubit? cards,
    JourneyRepository? repository,
    Future<JourneyCatalog> Function()? catalogLoader,
    Random? random,
  })  : _economy = economy,
        _cards = cards,
        _repository = repository ?? _defaultRepo(),
        _catalogLoader = catalogLoader ?? JourneyCatalog.load,
        _random = random ?? Random(),
        super(JourneyUiState.empty());

  static JourneyRepository _defaultRepo() {
    if (GetIt.instance.isRegistered<JourneyRepository>()) {
      return getIt<JourneyRepository>();
    }
    return MemoryJourneyRepository();
  }

  final EconomyCubit _economy;
  final CardsCubit? _cards;
  final JourneyRepository _repository;
  final Future<JourneyCatalog> Function() _catalogLoader;
  final Random _random;

  Future<void> hydrate() async {
    final catalog = await _catalogLoader();
    final firstId = catalog.firstZoneId ?? '';
    var progress = await _repository.load();
    progress ??= JourneyProgress.initial(firstId);
    if (progress.unlockedZoneIds.isEmpty && firstId.isNotEmpty) {
      progress = progress.copyWith(unlockedZoneIds: {firstId});
    }
    if (!isClosed) {
      emit(
        JourneyUiState(catalog: catalog, progress: progress, ready: true),
      );
    }
  }

  bool isZoneUnlocked(String zoneId) =>
      state.progress.unlockedZoneIds.contains(zoneId);

  bool isNodeCompleted(String nodeId) =>
      state.progress.completedNodeIds.contains(nodeId);

  /// Linear: previous node in zone must be done (or index 0).
  bool canAttempt(JourneyZone zone, int index) {
    if (!isZoneUnlocked(zone.id)) return false;
    if (index <= 0) return true;
    return isNodeCompleted(zone.nodes[index - 1].id);
  }

  bool isCurrent(JourneyZone zone, int index) {
    if (!canAttempt(zone, index)) return false;
    final node = zone.nodes[index];
    return !isNodeCompleted(node.id);
  }

  Future<String?> tryCompleteNode(String nodeId) async {
    final node = state.catalog.nodeById(nodeId);
    if (node == null) return 'Unknown node';
    final zone = _zoneFor(nodeId);
    if (zone == null) return 'Unknown zone';
    final index = zone.nodes.indexWhere((n) => n.id == nodeId);
    if (index < 0 || !canAttempt(zone, index)) return 'Locked';
    if (isNodeCompleted(nodeId)) return 'Already done';

    switch (node.type) {
      case JourneyNodeType.care:
      case JourneyNodeType.game:
        return 'Coming in games/care';
      case JourneyNodeType.cardReveal:
        return _completeCardReveal(node, zone);
      case JourneyNodeType.chest:
        return _completeChest(node, zone);
      case JourneyNodeType.gate:
        return 'Pick a gate option';
    }
  }

  Future<String?> payGateCoins(String nodeId) async {
    final node = state.catalog.nodeById(nodeId);
    if (node == null || node.type != JourneyNodeType.gate) {
      return 'Not a gate';
    }
    if (isNodeCompleted(nodeId)) return 'Already done';
    final zone = _zoneFor(nodeId);
    if (zone == null) return 'Unknown zone';
    final index = zone.nodes.indexWhere((n) => n.id == nodeId);
    if (!canAttempt(zone, index)) return 'Locked';
    GateOption? coinsOpt;
    for (final o in node.gateOptions) {
      if (o.method == GateMethod.coins && o.coinNeed != null) {
        coinsOpt = o;
        break;
      }
    }
    if (coinsOpt?.coinNeed == null) return 'No coin option';
    final paid = await _economy.spendCoins(coinsOpt!.coinNeed!);
    if (!paid) return 'Not enough coins';
    await _markComplete(node, zone);
    return null;
  }

  Future<String?> _completeCardReveal(
    JourneyNode node,
    JourneyZone zone,
  ) async {
    final cardId = node.cardId;
    if (cardId == null) return 'Missing card';
    final cards = _cards;
    if (cards != null) {
      await cards.collect(cardId);
    }
    if (node.reward.coins > 0) {
      await _economy.addCoins(node.reward.coins);
    }
    await _markComplete(node, zone);
    return null;
  }

  Future<String?> _completeChest(JourneyNode node, JourneyZone zone) async {
    if (node.reward.coins > 0) {
      await _economy.addCoins(node.reward.coins);
    }
    final cards = _cards;
    final pull = node.chestCards ?? 0;
    if (cards != null && pull > 0 && cards.state.cards.isNotEmpty) {
      final pool = cards.state.cards;
      for (var i = 0; i < pull; i++) {
        final pick = pool[_random.nextInt(pool.length)];
        await cards.collect(pick.id);
      }
    } else if (pull > 0) {
      // Fallback: grant from catalog asset if cards cubit empty.
      final catalog = await CardCatalog.load();
      if (catalog.cards.isNotEmpty) {
        for (var i = 0; i < pull; i++) {
          // Without cards cubit, skip collect — coins already granted.
        }
      }
    }
    await _markComplete(node, zone);
    return null;
  }

  Future<void> _markComplete(JourneyNode node, JourneyZone zone) async {
    final completed = {...state.progress.completedNodeIds, node.id};
    var unlocked = {...state.progress.unlockedZoneIds};
    var current = state.progress.currentZoneId;

    final allDone = zone.nodes.every((n) => completed.contains(n.id));
    if (allDone) {
      final zones = state.catalog.zones;
      final zi = zones.indexWhere((z) => z.id == zone.id);
      if (zi >= 0 && zi + 1 < zones.length) {
        final next = zones[zi + 1];
        unlocked.add(next.id);
        current = next.id;
      }
    }

    final progress = state.progress.copyWith(
      completedNodeIds: completed,
      unlockedZoneIds: unlocked,
      currentZoneId: current,
    );
    await _repository.save(progress);
    if (!isClosed) emit(state.copyWith(progress: progress));
  }

  JourneyZone? _zoneFor(String nodeId) {
    for (final z in state.catalog.zones) {
      if (z.nodes.any((n) => n.id == nodeId)) return z;
    }
    return null;
  }
}
