import 'package:hive_ce/hive.dart';

import '../domain/pet_needs.dart';

abstract class NeedsRepository {
  Future<PetNeeds> load({DateTime? now});
  Future<void> save(PetNeeds needs);
}

abstract final class NeedsStorageKeys {
  static const hunger = 'hunger';
  static const sleep = 'sleep';
  static const fun = 'fun';
  static const clean = 'clean';
  static const love = 'love';
  static const lastSeenMs = 'last_seen_ms';
}

/// Hive `crumbo_state` box — no personal data.
class HiveNeedsRepository implements NeedsRepository {
  HiveNeedsRepository(this._box);

  final Box<dynamic> _box;

  @override
  Future<PetNeeds> load({DateTime? now}) async {
    final at = now ?? DateTime.now();
    if (!_box.containsKey(NeedsStorageKeys.lastSeenMs)) {
      return PetNeeds.fresh(at: at);
    }

    return PetNeeds(
      hunger: _readDouble(NeedsStorageKeys.hunger, PetNeeds.defaultLevel),
      sleep: _readDouble(NeedsStorageKeys.sleep, PetNeeds.defaultLevel),
      fun: _readDouble(NeedsStorageKeys.fun, PetNeeds.defaultLevel),
      clean: _readDouble(NeedsStorageKeys.clean, PetNeeds.defaultLevel),
      love: _readDouble(NeedsStorageKeys.love, PetNeeds.defaultLevel),
      lastSeenAt: DateTime.fromMillisecondsSinceEpoch(
        (_box.get(NeedsStorageKeys.lastSeenMs) as num?)?.toInt() ??
            at.millisecondsSinceEpoch,
      ),
    ).clampAll();
  }

  @override
  Future<void> save(PetNeeds needs) async {
    final clamped = needs.clampAll();
    await _box.put(NeedsStorageKeys.hunger, clamped.hunger);
    await _box.put(NeedsStorageKeys.sleep, clamped.sleep);
    await _box.put(NeedsStorageKeys.fun, clamped.fun);
    await _box.put(NeedsStorageKeys.clean, clamped.clean);
    await _box.put(NeedsStorageKeys.love, clamped.love);
    await _box.put(
      NeedsStorageKeys.lastSeenMs,
      clamped.lastSeenAt.millisecondsSinceEpoch,
    );
  }

  double _readDouble(String key, double fallback) {
    final v = _box.get(key);
    if (v is num) return v.toDouble();
    return fallback;
  }
}

/// In-memory store for unit / widget tests.
class MemoryNeedsRepository implements NeedsRepository {
  PetNeeds? _stored;

  @override
  Future<PetNeeds> load({DateTime? now}) async {
    return _stored ?? PetNeeds.fresh(at: now ?? DateTime.now());
  }

  @override
  Future<void> save(PetNeeds needs) async {
    _stored = needs.clampAll();
  }
}
