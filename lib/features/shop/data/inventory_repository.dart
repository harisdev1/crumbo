import 'package:hive_ce/hive.dart';

abstract final class InventoryStorageKeys {
  static const ownedIds = 'owned_ids';
}

abstract class InventoryRepository {
  Future<Set<String>> loadOwned();
  Future<void> addOwned(String id);
}

class HiveInventoryRepository implements InventoryRepository {
  HiveInventoryRepository(this._box);

  final Box<dynamic> _box;

  @override
  Future<Set<String>> loadOwned() async {
    final raw = _box.get(InventoryStorageKeys.ownedIds);
    if (raw is! List) return <String>{};
    return raw.map((e) => e.toString()).toSet();
  }

  @override
  Future<void> addOwned(String id) async {
    final owned = await loadOwned();
    if (owned.contains(id)) return;
    owned.add(id);
    await _box.put(InventoryStorageKeys.ownedIds, owned.toList());
  }
}

class MemoryInventoryRepository implements InventoryRepository {
  final Set<String> _owned = <String>{};

  @override
  Future<Set<String>> loadOwned() async => Set<String>.from(_owned);

  @override
  Future<void> addOwned(String id) async {
    _owned.add(id);
  }
}
