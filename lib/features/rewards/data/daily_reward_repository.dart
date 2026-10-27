import 'package:hive_ce/hive.dart';

import '../domain/daily_streak_state.dart';

abstract final class DailyRewardStorageKeys {
  static const streakDay = 'daily_streak_day';
  static const lastClaimDate = 'daily_last_claim_date';
}

abstract class DailyRewardRepository {
  Future<DailyStreakState> load();
  Future<void> save(DailyStreakState state);
}

class HiveDailyRewardRepository implements DailyRewardRepository {
  HiveDailyRewardRepository(this._box);

  final Box<dynamic> _box;

  @override
  Future<DailyStreakState> load() async {
    final day = _box.get(DailyRewardStorageKeys.streakDay);
    final last = _box.get(DailyRewardStorageKeys.lastClaimDate);
    return DailyStreakState(
      streakDay: day is int ? day : 0,
      lastClaimDate: last is String ? last : null,
    );
  }

  @override
  Future<void> save(DailyStreakState state) async {
    await _box.put(DailyRewardStorageKeys.streakDay, state.streakDay);
    if (state.lastClaimDate == null) {
      await _box.delete(DailyRewardStorageKeys.lastClaimDate);
    } else {
      await _box.put(
        DailyRewardStorageKeys.lastClaimDate,
        state.lastClaimDate,
      );
    }
  }
}

class MemoryDailyRewardRepository implements DailyRewardRepository {
  DailyStreakState _state = DailyStreakState.empty;

  @override
  Future<DailyStreakState> load() async => _state;

  @override
  Future<void> save(DailyStreakState state) async {
    _state = state;
  }
}
