import 'package:hive_ce/hive.dart';

abstract final class TaskProgressStorageKeys {
  static const progress = 'task_progress_v1';
}

abstract class TaskProgressStore {
  Future<Map<String, int>> load();
  Future<void> add(String key, int delta);
  Future<int> valueOf(String key);
  Future<bool> meets(Map<String, int> need);
}

class HiveTaskProgressStore implements TaskProgressStore {
  HiveTaskProgressStore(this._box);

  final Box<dynamic> _box;

  @override
  Future<Map<String, int>> load() async {
    final raw = _box.get(TaskProgressStorageKeys.progress);
    if (raw is! Map) return {};
    return raw.map(
      (k, v) => MapEntry(k.toString(), v is int ? v : int.tryParse('$v') ?? 0),
    );
  }

  Future<void> _save(Map<String, int> map) async {
    await _box.put(TaskProgressStorageKeys.progress, map);
  }

  @override
  Future<void> add(String key, int delta) async {
    if (delta <= 0) return;
    final map = await load();
    map[key] = (map[key] ?? 0) + delta;
    await _save(map);
  }

  @override
  Future<int> valueOf(String key) async {
    final map = await load();
    return map[key] ?? 0;
  }

  @override
  Future<bool> meets(Map<String, int> need) async {
    final map = await load();
    for (final entry in need.entries) {
      if ((map[entry.key] ?? 0) < entry.value) return false;
    }
    return true;
  }
}

class MemoryTaskProgressStore implements TaskProgressStore {
  final Map<String, int> _map = {};

  @override
  Future<Map<String, int>> load() async => Map.from(_map);

  @override
  Future<void> add(String key, int delta) async {
    if (delta <= 0) return;
    _map[key] = (_map[key] ?? 0) + delta;
  }

  @override
  Future<int> valueOf(String key) async => _map[key] ?? 0;

  @override
  Future<bool> meets(Map<String, int> need) async {
    for (final entry in need.entries) {
      if ((_map[entry.key] ?? 0) < entry.value) return false;
    }
    return true;
  }
}
