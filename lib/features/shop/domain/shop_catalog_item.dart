enum ShopCurrency { coins, gems }

/// One row from `assets/data/items.json`.
class ShopCatalogItem {
  const ShopCatalogItem({
    required this.id,
    required this.name,
    required this.category,
    required this.currency,
    required this.price,
    required this.icon,
  });

  final String id;
  final String name;
  final String category;
  final ShopCurrency currency;
  final int price;
  final String icon;

  factory ShopCatalogItem.fromJson(Map<String, dynamic> json) {
    final currencyRaw = (json['currency'] as String? ?? 'coins').toLowerCase();
    return ShopCatalogItem(
      id: json['id'] as String,
      name: json['name'] as String? ?? json['id'] as String,
      category: json['category'] as String? ?? 'items',
      currency: currencyRaw == 'gems' ? ShopCurrency.gems : ShopCurrency.coins,
      price: (json['price'] as num?)?.toInt() ?? 0,
      icon: json['icon'] as String? ?? 'item',
    );
  }
}
