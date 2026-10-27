import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/di/injection.dart';
import '../../data/economy_repository.dart';
import '../../domain/wallet.dart';

class EconomyCubit extends Cubit<Wallet> {
  EconomyCubit({EconomyRepository? repository})
      : _repository = repository ?? _defaultRepository(),
        super(Wallet.starter());

  static EconomyRepository _defaultRepository() {
    if (GetIt.instance.isRegistered<EconomyRepository>()) {
      return getIt<EconomyRepository>();
    }
    return MemoryEconomyRepository();
  }

  final EconomyRepository _repository;

  Future<void> hydrate() async {
    final wallet = await _repository.load();
    if (!isClosed) emit(wallet);
  }

  Future<void> addCoins(int amount) async {
    final next = state.addCoins(amount);
    await _repository.save(next);
    if (!isClosed) emit(next);
  }

  Future<void> addGems(int amount) async {
    final next = state.addGems(amount);
    await _repository.save(next);
    if (!isClosed) emit(next);
  }

  /// Returns false if insufficient coins.
  Future<bool> spendCoins(int amount) async {
    final next = state.trySpendCoins(amount);
    if (next == null) return false;
    await _repository.save(next);
    if (!isClosed) emit(next);
    return true;
  }

  /// Returns false if insufficient gems.
  Future<bool> spendGems(int amount) async {
    final next = state.trySpendGems(amount);
    if (next == null) return false;
    await _repository.save(next);
    if (!isClosed) emit(next);
    return true;
  }
}
