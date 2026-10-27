import 'package:hive_ce/hive.dart';

abstract final class CardsCollectionStorageKeys {
  static const collectedCounts = 'collected_card_counts';
}

abstract class CardsCollectionRepository {
  Future<Map<String, int>> loadCounts();
  Future<void> saveCounts(Map<String, int> counts);
  Future<int> countOf(String id);
  Future<bool> isOwned(String id);
  Future<int> addCopy(String id);
}

class HiveCardsCollectionRepository implements CardsCollectionRepository {
  HiveCardsCollectionRepository(this._box);

  final Box<dynamic> _box;

  @override
  Future<Map<String, int>> loadCounts() async {
    final raw = _box.get(CardsCollectionStorageKeys.collectedCounts);
    if (raw is! Map) return {};
    return raw.map(
      (k, v) => MapEntry(k.toString(), v is int ? v : int.tryParse('$v') ?? 0),
    );
  }

  @override
  Future<void> saveCounts(Map<String, int> counts) async {
    await _box.put(CardsCollectionStorageKeys.collectedCounts, counts);
  }

  @override
  Future<int> countOf(String id) async {
    final counts = await loadCounts();
    return counts[id] ?? 0;
  }

  @override
  Future<bool> isOwned(String id) async => (await countOf(id)) >= 1;

  @override
  Future<int> addCopy(String id) async {
    final counts = await loadCounts();
    final next = (counts[id] ?? 0) + 1;
    counts[id] = next;
    await saveCounts(counts);
    return next;
  }
}

class MemoryCardsCollectionRepository implements CardsCollectionRepository {
  final Map<String, int> _counts = {};

  @override
  Future<Map<String, int>> loadCounts() async => Map.from(_counts);

  @override
  Future<void> saveCounts(Map<String, int> counts) async {
    _counts
      ..clear()
      ..addAll(counts);
  }

  @override
  Future<int> countOf(String id) async => _counts[id] ?? 0;

  @override
  Future<bool> isOwned(String id) async => (_counts[id] ?? 0) >= 1;

  @override
  Future<int> addCopy(String id) async {
    final next = (_counts[id] ?? 0) + 1;
    _counts[id] = next;
    return next;
  }
}
