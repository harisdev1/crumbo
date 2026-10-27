import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'shop_catalog_item.dart';

/// Loaded shop catalog from `assets/data/items.json`.
class ShopCatalog {
  ShopCatalog(this.items);

  final List<ShopCatalogItem> items;

  static ShopCatalog? _cached;

  static const assetPath = 'assets/data/items.json';

  /// Distinct categories in catalog order of first appearance.
  List<String> get categories {
    final seen = <String>{};
    final out = <String>[];
    for (final item in items) {
      if (seen.add(item.category)) out.add(item.category);
    }
    return out;
  }

  List<ShopCatalogItem> byCategory(String category) {
    return items.where((e) => e.category == category).toList(growable: false);
  }

  ShopCatalogItem? findById(String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  static Future<ShopCatalog> load({AssetBundle? bundle}) async {
    if (_cached != null) return _cached!;
    final raw = await (bundle ?? rootBundle).loadString(assetPath);
    _cached = parse(raw);
    return _cached!;
  }

  @visibleForTesting
  static ShopCatalog parse(String raw) {
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final list = (map['items'] as List<dynamic>? ?? const [])
        .map((e) => ShopCatalogItem.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return ShopCatalog(list);
  }

  @visibleForTesting
  static void debugReset() {
    _cached = null;
  }
}
