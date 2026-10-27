import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'daily_reward_day.dart';

class DailyRewardsCatalog {
  DailyRewardsCatalog(this.days);

  final List<DailyRewardDay> days;

  static DailyRewardsCatalog? _cached;
  static const assetPath = 'assets/data/daily_rewards.json';

  int coinsFor(int day) {
    for (final d in days) {
      if (d.day == day) return d.coins;
    }
    return 0;
  }

  static Future<DailyRewardsCatalog> load({AssetBundle? bundle}) async {
    if (_cached != null) return _cached!;
    final raw = await (bundle ?? rootBundle).loadString(assetPath);
    _cached = parse(raw);
    return _cached!;
  }

  @visibleForTesting
  static DailyRewardsCatalog parse(String raw) {
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final list = (map['days'] as List<dynamic>? ?? const [])
        .map((e) => DailyRewardDay.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return DailyRewardsCatalog(list);
  }

  @visibleForTesting
  static void debugReset() {
    _cached = null;
  }
}
