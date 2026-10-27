import 'dart:convert';

import 'package:hive_ce/hive.dart';

import '../domain/journey_models.dart';

abstract final class JourneyStorageKeys {
  static const progress = 'journey_progress_v1';
}

abstract class JourneyRepository {
  Future<JourneyProgress?> load();
  Future<void> save(JourneyProgress progress);
}

class HiveJourneyRepository implements JourneyRepository {
  HiveJourneyRepository(this._box);

  final Box<dynamic> _box;

  @override
  Future<JourneyProgress?> load() async {
    final raw = _box.get(JourneyStorageKeys.progress);
    if (raw is! String || raw.isEmpty) return null;
    return JourneyProgress.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> save(JourneyProgress progress) async {
    await _box.put(JourneyStorageKeys.progress, jsonEncode(progress.toJson()));
  }
}

class MemoryJourneyRepository implements JourneyRepository {
  JourneyProgress? _progress;

  @override
  Future<JourneyProgress?> load() async => _progress;

  @override
  Future<void> save(JourneyProgress progress) async {
    _progress = progress;
  }
}
