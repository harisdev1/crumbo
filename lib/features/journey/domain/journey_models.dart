enum JourneyNodeType { care, game, cardReveal, chest, gate }

enum GateMethod { task, coins, ad }

class JourneyReward {
  const JourneyReward({this.coins = 0});

  final int coins;

  factory JourneyReward.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const JourneyReward();
    return JourneyReward(coins: (json['coins'] as num?)?.toInt() ?? 0);
  }
}

class GateOption {
  const GateOption({
    required this.method,
    this.needMap,
    this.coinNeed,
    this.placement,
  });

  final GateMethod method;
  final Map<String, int>? needMap;
  final int? coinNeed;
  final String? placement;

  factory GateOption.fromJson(Map<String, dynamic> json) {
    final methodRaw = (json['method'] as String? ?? 'coins').toLowerCase();
    final method = switch (methodRaw) {
      'task' => GateMethod.task,
      'ad' => GateMethod.ad,
      _ => GateMethod.coins,
    };
    Map<String, int>? needMap;
    int? coinNeed;
    final need = json['need'];
    if (need is Map) {
      needMap = need.map(
        (k, v) => MapEntry(k.toString(), (v as num).toInt()),
      );
    } else if (need is num) {
      coinNeed = need.toInt();
    }
    return GateOption(
      method: method,
      needMap: needMap,
      coinNeed: coinNeed,
      placement: json['placement'] as String?,
    );
  }

  bool get isNonAd => method != GateMethod.ad;
}

class JourneyNode {
  const JourneyNode({
    required this.id,
    required this.type,
    this.task,
    this.count,
    this.game,
    this.target,
    this.cardId,
    this.chestCards,
    this.reward = const JourneyReward(),
    this.gateOptions = const [],
  });

  final String id;
  final JourneyNodeType type;
  final String? task;
  final int? count;
  final String? game;
  final int? target;
  final String? cardId;
  final int? chestCards;
  final JourneyReward reward;
  final List<GateOption> gateOptions;

  factory JourneyNode.fromJson(Map<String, dynamic> json) {
    final typeRaw = (json['type'] as String? ?? 'care').toLowerCase();
    final type = switch (typeRaw) {
      'game' => JourneyNodeType.game,
      'card_reveal' => JourneyNodeType.cardReveal,
      'chest' => JourneyNodeType.chest,
      'gate' => JourneyNodeType.gate,
      _ => JourneyNodeType.care,
    };
    final optionsRaw = json['options'] as List<dynamic>? ?? const [];
    return JourneyNode(
      id: json['id'] as String,
      type: type,
      task: json['task'] as String?,
      count: (json['count'] as num?)?.toInt(),
      game: json['game'] as String?,
      target: (json['target'] as num?)?.toInt(),
      cardId: json['card'] as String?,
      chestCards: (json['cards'] as num?)?.toInt(),
      reward: JourneyReward.fromJson(json['reward'] as Map<String, dynamic>?),
      gateOptions: optionsRaw
          .map((e) => GateOption.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  bool get hasNonAdGate {
    if (type != JourneyNodeType.gate) return true;
    return gateOptions.any((o) => o.isNonAd);
  }
}

class JourneyZone {
  const JourneyZone({
    required this.id,
    required this.name,
    required this.nodes,
  });

  final String id;
  final String name;
  final List<JourneyNode> nodes;

  factory JourneyZone.fromJson(Map<String, dynamic> json) {
    final nodesRaw = json['nodes'] as List<dynamic>? ?? const [];
    return JourneyZone(
      id: json['id'] as String,
      name: json['name'] as String? ?? json['id'] as String,
      nodes: nodesRaw
          .map((e) => JourneyNode.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}

class JourneyProgress {
  const JourneyProgress({
    required this.currentZoneId,
    required this.completedNodeIds,
    required this.unlockedZoneIds,
  });

  final String currentZoneId;
  final Set<String> completedNodeIds;
  final Set<String> unlockedZoneIds;

  factory JourneyProgress.initial(String firstZoneId) {
    return JourneyProgress(
      currentZoneId: firstZoneId,
      completedNodeIds: {},
      unlockedZoneIds: {firstZoneId},
    );
  }

  Map<String, dynamic> toJson() => {
        'currentZoneId': currentZoneId,
        'completedNodeIds': completedNodeIds.toList(),
        'unlockedZoneIds': unlockedZoneIds.toList(),
      };

  factory JourneyProgress.fromJson(Map<String, dynamic> json) {
    return JourneyProgress(
      currentZoneId: json['currentZoneId'] as String? ?? '',
      completedNodeIds: {
        for (final e in (json['completedNodeIds'] as List<dynamic>? ?? const []))
          e.toString(),
      },
      unlockedZoneIds: {
        for (final e in (json['unlockedZoneIds'] as List<dynamic>? ?? const []))
          e.toString(),
      },
    );
  }

  JourneyProgress copyWith({
    String? currentZoneId,
    Set<String>? completedNodeIds,
    Set<String>? unlockedZoneIds,
  }) {
    return JourneyProgress(
      currentZoneId: currentZoneId ?? this.currentZoneId,
      completedNodeIds: completedNodeIds ?? this.completedNodeIds,
      unlockedZoneIds: unlockedZoneIds ?? this.unlockedZoneIds,
    );
  }
}
