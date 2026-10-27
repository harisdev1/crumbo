import 'package:hive_ce/hive.dart';

import '../domain/wallet.dart';

abstract final class EconomyStorageKeys {
  static const coins = 'coins';
  static const gems = 'gems';
  static const seeded = 'economy_seeded_v1';
}

abstract class EconomyRepository {
  Future<Wallet> load();
  Future<void> save(Wallet wallet);
}

class HiveEconomyRepository implements EconomyRepository {
  HiveEconomyRepository(this._box);

  final Box<dynamic> _box;

  @override
  Future<Wallet> load() async {
    if (_box.get(EconomyStorageKeys.seeded) != true) {
      final starter = Wallet.starter();
      await save(starter);
      await _box.put(EconomyStorageKeys.seeded, true);
      return starter;
    }
    final coins = _box.get(EconomyStorageKeys.coins);
    final gems = _box.get(EconomyStorageKeys.gems);
    return Wallet(
      coins: coins is int ? coins : Wallet.starterCoins,
      gems: gems is int ? gems : Wallet.starterGems,
    );
  }

  @override
  Future<void> save(Wallet wallet) async {
    await _box.put(EconomyStorageKeys.coins, wallet.coins);
    await _box.put(EconomyStorageKeys.gems, wallet.gems);
  }
}

class MemoryEconomyRepository implements EconomyRepository {
  Wallet _wallet = Wallet.starter();
  bool _seeded = false;

  @override
  Future<Wallet> load() async {
    if (!_seeded) {
      _wallet = Wallet.starter();
      _seeded = true;
    }
    return _wallet;
  }

  @override
  Future<void> save(Wallet wallet) async {
    _wallet = wallet;
    _seeded = true;
  }
}
