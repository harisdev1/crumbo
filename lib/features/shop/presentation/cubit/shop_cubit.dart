import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/di/injection.dart';
import '../../../economy/presentation/cubit/economy_cubit.dart';
import '../../data/inventory_repository.dart';
import '../../domain/shop_catalog.dart';
import '../../domain/shop_catalog_item.dart';

class ShopState {
  const ShopState({
    required this.items,
    required this.owned,
    this.ready = false,
  });

  final List<ShopCatalogItem> items;
  final Set<String> owned;
  final bool ready;

  static const empty = ShopState(items: [], owned: {}, ready: false);

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

  bool isOwned(String id) => owned.contains(id);

  ShopState copyWith({
    List<ShopCatalogItem>? items,
    Set<String>? owned,
    bool? ready,
  }) {
    return ShopState(
      items: items ?? this.items,
      owned: owned ?? this.owned,
      ready: ready ?? this.ready,
    );
  }
}

class ShopCubit extends Cubit<ShopState> {
  ShopCubit({
    required EconomyCubit economy,
    InventoryRepository? inventory,
    Future<ShopCatalog> Function()? catalogLoader,
  })  : _economy = economy,
        _inventory = inventory ?? _defaultInventory(),
        _catalogLoader = catalogLoader ?? ShopCatalog.load,
        super(ShopState.empty);

  static InventoryRepository _defaultInventory() {
    if (GetIt.instance.isRegistered<InventoryRepository>()) {
      return getIt<InventoryRepository>();
    }
    return MemoryInventoryRepository();
  }

  final EconomyCubit _economy;
  final InventoryRepository _inventory;
  final Future<ShopCatalog> Function() _catalogLoader;

  Future<void> hydrate() async {
    final catalog = await _catalogLoader();
    final owned = await _inventory.loadOwned();
    if (!isClosed) {
      emit(ShopState(items: catalog.items, owned: owned, ready: true));
    }
  }

  /// Returns true if owned after call (already owned or purchase ok).
  Future<bool> buy(String id) async {
    if (state.owned.contains(id)) return true;
    ShopCatalogItem? item;
    for (final e in state.items) {
      if (e.id == id) {
        item = e;
        break;
      }
    }
    if (item == null) return false;

    final paid = item.currency == ShopCurrency.gems
        ? await _economy.spendGems(item.price)
        : await _economy.spendCoins(item.price);
    if (!paid) return false;

    await _inventory.addOwned(id);
    final next = {...state.owned, id};
    if (!isClosed) emit(state.copyWith(owned: next));
    return true;
  }
}
