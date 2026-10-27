enum CardType { outfit, food, friend, room, sticker, surprise }

enum CardRarity { common, rare, superRare, golden }

enum UnlockMethod { task, journey, coins, ad }

class CardUnlock {
  const CardUnlock({
    required this.method,
    this.node,
    this.price,
    this.need,
    this.placement,
  });

  final UnlockMethod method;
  final String? node;
  final int? price;
  final Map<String, int>? need;
  final String? placement;

  factory CardUnlock.fromJson(Map<String, dynamic> json) {
    final methodRaw = (json['method'] as String? ?? 'coins').toLowerCase();
    final method = switch (methodRaw) {
      'task' => UnlockMethod.task,
      'journey' => UnlockMethod.journey,
      'ad' => UnlockMethod.ad,
      _ => UnlockMethod.coins,
    };
    Map<String, int>? need;
    final needRaw = json['need'];
    if (needRaw is Map) {
      need = needRaw.map(
        (k, v) => MapEntry(k.toString(), (v as num).toInt()),
      );
    }
    return CardUnlock(
      method: method,
      node: json['node'] as String?,
      price: (json['price'] as num?)?.toInt(),
      need: need,
      placement: json['placement'] as String?,
    );
  }

  bool get isNonAd => method != UnlockMethod.ad;
}

class CardDefinition {
  const CardDefinition({
    required this.id,
    required this.name,
    required this.type,
    required this.rarity,
    required this.setId,
    required this.unlock,
  });

  final String id;
  final String name;
  final CardType type;
  final CardRarity rarity;
  final String setId;
  final List<CardUnlock> unlock;

  bool get hasNonAdUnlock => unlock.any((u) => u.isNonAd);

  factory CardDefinition.fromJson(Map<String, dynamic> json) {
    final typeRaw = (json['type'] as String? ?? 'sticker').toLowerCase();
    final rarityRaw = (json['rarity'] as String? ?? 'common').toLowerCase();
    final unlockRaw = json['unlock'] as List<dynamic>? ?? const [];
    return CardDefinition(
      id: json['id'] as String,
      name: json['name'] as String? ?? json['id'] as String,
      type: switch (typeRaw) {
        'outfit' => CardType.outfit,
        'food' => CardType.food,
        'friend' => CardType.friend,
        'room' => CardType.room,
        'surprise' => CardType.surprise,
        _ => CardType.sticker,
      },
      rarity: switch (rarityRaw) {
        'rare' => CardRarity.rare,
        'super_rare' => CardRarity.superRare,
        'golden' => CardRarity.golden,
        _ => CardRarity.common,
      },
      setId: json['set'] as String? ?? 'default',
      unlock: unlockRaw
          .map((e) => CardUnlock.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}

/// Duplicate conversion payouts (B9 locked constants).
abstract final class DuplicateCoinTable {
  static int forRarity(CardRarity rarity) {
    return switch (rarity) {
      CardRarity.common => 5,
      CardRarity.rare => 15,
      CardRarity.superRare => 40,
      CardRarity.golden => 100,
    };
  }
}
