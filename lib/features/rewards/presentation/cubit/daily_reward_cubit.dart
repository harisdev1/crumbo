import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/di/injection.dart';
import '../../../economy/presentation/cubit/economy_cubit.dart';
import '../../data/daily_reward_repository.dart';
import '../../domain/daily_claim_logic.dart';
import '../../domain/daily_rewards_catalog.dart';
import '../../domain/daily_streak_state.dart';

class DailyRewardUiState {
  const DailyRewardUiState({
    required this.catalog,
    required this.streak,
    required this.plan,
    this.ready = false,
    this.claiming = false,
  });

  final DailyRewardsCatalog catalog;
  final DailyStreakState streak;
  final DailyClaimPlan plan;
  final bool ready;
  final bool claiming;

  static DailyRewardUiState initial(DateTime now) {
    return DailyRewardUiState(
      catalog: DailyRewardsCatalog(const []),
      streak: DailyStreakState.empty,
      plan: DailyClaimLogic.evaluate(
        state: DailyStreakState.empty,
        now: now,
      ),
    );
  }

  bool get canClaim =>
      ready &&
      !claiming &&
      plan.availability == DailyClaimAvailability.canClaim;

  DailyRewardUiState copyWith({
    DailyRewardsCatalog? catalog,
    DailyStreakState? streak,
    DailyClaimPlan? plan,
    bool? ready,
    bool? claiming,
  }) {
    return DailyRewardUiState(
      catalog: catalog ?? this.catalog,
      streak: streak ?? this.streak,
      plan: plan ?? this.plan,
      ready: ready ?? this.ready,
      claiming: claiming ?? this.claiming,
    );
  }
}

class DailyRewardCubit extends Cubit<DailyRewardUiState> {
  DailyRewardCubit({
    required EconomyCubit economy,
    DailyRewardRepository? repository,
    Future<DailyRewardsCatalog> Function()? catalogLoader,
    DateTime Function()? clock,
  })  : _economy = economy,
        _repository = repository ?? _defaultRepo(),
        _catalogLoader = catalogLoader ?? DailyRewardsCatalog.load,
        _clock = clock ?? DateTime.now,
        super(DailyRewardUiState.initial(DateTime.now()));

  static DailyRewardRepository _defaultRepo() {
    if (GetIt.instance.isRegistered<DailyRewardRepository>()) {
      return getIt<DailyRewardRepository>();
    }
    return MemoryDailyRewardRepository();
  }

  final EconomyCubit _economy;
  final DailyRewardRepository _repository;
  final Future<DailyRewardsCatalog> Function() _catalogLoader;
  final DateTime Function() _clock;

  Future<void> hydrate() async {
    final catalog = await _catalogLoader();
    final streak = await _repository.load();
    final now = _clock();
    final plan = DailyClaimLogic.evaluate(state: streak, now: now);
    if (!isClosed) {
      emit(
        DailyRewardUiState(
          catalog: catalog,
          streak: streak,
          plan: plan,
          ready: true,
        ),
      );
    }
  }

  /// Returns true if coins were granted.
  Future<bool> claim() async {
    if (!state.canClaim) return false;
    emit(state.copyWith(claiming: true));
    final now = _clock();
    final plan = DailyClaimLogic.evaluate(state: state.streak, now: now);
    if (plan.availability != DailyClaimAvailability.canClaim) {
      if (!isClosed) {
        emit(state.copyWith(plan: plan, claiming: false));
      }
      return false;
    }

    final coins = state.catalog.coinsFor(plan.nextDay);
    if (coins > 0) {
      await _economy.addCoins(coins);
    }
    final nextStreak = DailyClaimLogic.applyClaim(
      state: state.streak,
      claimedDay: plan.nextDay,
      now: now,
    );
    await _repository.save(nextStreak);
    final nextPlan = DailyClaimLogic.evaluate(state: nextStreak, now: now);
    if (!isClosed) {
      emit(
        state.copyWith(
          streak: nextStreak,
          plan: nextPlan,
          claiming: false,
        ),
      );
    }
    return true;
  }
}
