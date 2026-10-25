import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PlayerCard {
  const PlayerCard({
    required this.name,
    required this.level,
    required this.xp,
    required this.xpGoal,
    required this.gamesPlayed,
  });

  final String name;
  final int level;
  final int xp;
  final int xpGoal;
  final int gamesPlayed;

  factory PlayerCard.fromJson(Map<String, dynamic> json) {
    return PlayerCard(
      name: json['name'] as String? ?? 'Player',
      level: (json['level'] as num?)?.toInt() ?? 1,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      xpGoal: (json['xpGoal'] as num?)?.toInt() ?? 100,
      gamesPlayed: (json['gamesPlayed'] as num?)?.toInt() ?? 0,
    );
  }
}

class NamedIcon {
  const NamedIcon({required this.id, required this.name, required this.icon});

  final String id;
  final String name;
  final String icon;

  factory NamedIcon.fromJson(Map<String, dynamic> json) {
    return NamedIcon(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? 'other',
    );
  }
}

class AchievementItem {
  const AchievementItem({
    required this.id,
    required this.name,
    required this.progress,
    required this.goal,
  });

  final String id;
  final String name;
  final int progress;
  final int goal;

  double get fraction => goal <= 0 ? 0 : (progress / goal).clamp(0, 1);

  factory AchievementItem.fromJson(Map<String, dynamic> json) {
    return AchievementItem(
      id: json['id'] as String,
      name: json['name'] as String,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      goal: (json['goal'] as num?)?.toInt() ?? 1,
    );
  }
}

class DayReward {
  const DayReward({
    required this.day,
    required this.coins,
    required this.unlocked,
  });

  final int day;
  final int coins;
  final bool unlocked;

  factory DayReward.fromJson(Map<String, dynamic> json) {
    return DayReward(
      day: (json['day'] as num).toInt(),
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      unlocked: json['unlocked'] as bool? ?? false,
    );
  }
}

class MarketItem {
  const MarketItem({
    required this.id,
    required this.name,
    required this.tab,
    required this.icon,
  });

  final String id;
  final String name;
  final String tab;
  final String icon;

  factory MarketItem.fromJson(Map<String, dynamic> json) {
    return MarketItem(
      id: json['id'] as String,
      name: json['name'] as String,
      tab: json['tab'] as String? ?? 'Others',
      icon: json['icon'] as String? ?? 'other',
    );
  }
}

class ShopItem {
  const ShopItem({
    required this.id,
    required this.name,
    required this.price,
    required this.tab,
  });

  final String id;
  final String name;
  final String price;
  final String tab;

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: json['price'] as String? ?? '0',
      tab: json['tab'] as String? ?? 'Items',
    );
  }
}

class BestScore {
  const BestScore({required this.game, required this.score});

  final String game;
  final int score;

  factory BestScore.fromJson(Map<String, dynamic> json) {
    return BestScore(
      game: json['game'] as String,
      score: (json['score'] as num?)?.toInt() ?? 0,
    );
  }
}

class PricePack {
  const PricePack({
    required this.id,
    required this.amount,
    required this.price,
  });

  final String id;
  final int amount;
  final String price;

  factory PricePack.fromJson(Map<String, dynamic> json) {
    return PricePack(
      id: json['id'] as String,
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      price: json['price'] as String? ?? '',
    );
  }
}

class PlayContent {
  const PlayContent({
    required this.profile,
    required this.games,
    required this.achievements,
    required this.rewards,
    required this.foods,
    required this.market,
    required this.shopItems,
    required this.scores,
    required this.coinPacks,
    required this.gemPacks,
  });

  final PlayerCard profile;
  final List<NamedIcon> games;
  final List<AchievementItem> achievements;
  final List<DayReward> rewards;
  final List<NamedIcon> foods;
  final List<MarketItem> market;
  final List<ShopItem> shopItems;
  final List<BestScore> scores;
  final List<PricePack> coinPacks;
  final List<PricePack> gemPacks;

  static PlayContent? _cached;

  static Future<PlayContent> load({AssetBundle? bundle}) async {
    if (_cached != null) return _cached!;
    final raw = await (bundle ?? rootBundle).loadString(
      'assets/data/play_content.json',
    );
    _cached = PlayContent.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    return _cached!;
  }

  factory PlayContent.fromJson(Map<String, dynamic> json) {
    return PlayContent(
      profile: PlayerCard.fromJson(
        json['profile'] as Map<String, dynamic>? ?? const {},
      ),
      games: _list(json, 'games', NamedIcon.fromJson),
      achievements: _list(json, 'achievements', AchievementItem.fromJson),
      rewards: _list(json, 'rewards', DayReward.fromJson),
      foods: _list(json, 'foods', NamedIcon.fromJson),
      market: _list(json, 'market', MarketItem.fromJson),
      shopItems: _list(json, 'shopItems', ShopItem.fromJson),
      scores: _list(json, 'scores', BestScore.fromJson),
      coinPacks: _list(json, 'coinPacks', PricePack.fromJson),
      gemPacks: _list(json, 'gemPacks', PricePack.fromJson),
    );
  }

  @visibleForTesting
  static void debugReset() {
    _cached = null;
  }
}

List<T> _list<T>(
  Map<String, dynamic> json,
  String key,
  T Function(Map<String, dynamic>) parse,
) {
  final raw = json[key] as List<dynamic>? ?? const [];
  return raw
      .map((entry) => parse(entry as Map<String, dynamic>))
      .toList(growable: false);
}
