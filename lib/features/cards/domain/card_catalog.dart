import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'card_definition.dart';

class CardCatalog {
  CardCatalog(this.cards);

  final List<CardDefinition> cards;

  static CardCatalog? _cached;
  static const assetPath = 'assets/data/cards.json';

  CardDefinition? findById(String id) {
    for (final c in cards) {
      if (c.id == id) return c;
    }
    return null;
  }

  List<CardDefinition> bySet(String setId) {
    return cards.where((c) => c.setId == setId).toList(growable: false);
  }

  static Future<CardCatalog> load({AssetBundle? bundle}) async {
    if (_cached != null) return _cached!;
    final raw = await (bundle ?? rootBundle).loadString(assetPath);
    _cached = parse(raw);
    return _cached!;
  }

  @visibleForTesting
  static CardCatalog parse(String raw, {bool enforceNonAd = true}) {
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final list = (map['cards'] as List<dynamic>? ?? const [])
        .map((e) => CardDefinition.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);

    final ids = <String>{};
    for (final card in list) {
      if (!ids.add(card.id)) {
        throw FormatException('Duplicate card id: ${card.id}');
      }
      if (enforceNonAd && !card.hasNonAdUnlock) {
        throw FormatException('Card ${card.id} has only ad unlock');
      }
      for (final u in card.unlock) {
        if (u.method == UnlockMethod.coins && (u.price == null || u.price! <= 0)) {
          throw FormatException('Card ${card.id} coins unlock needs price > 0');
        }
      }
    }
    return CardCatalog(list);
  }

  @visibleForTesting
  static void debugReset() {
    _cached = null;
  }
}
