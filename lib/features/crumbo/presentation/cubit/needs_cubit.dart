import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/di/injection.dart';
import '../../data/needs_repository.dart';
import '../../domain/need_kind.dart';
import '../../domain/needs_decay.dart';
import '../../domain/pet_mood.dart';
import '../../domain/pet_needs.dart';

class NeedsState {
  const NeedsState({
    required this.needs,
    required this.mood,
  });

  factory NeedsState.fromNeeds(PetNeeds needs) {
    return NeedsState(needs: needs, mood: PetMood.fromNeeds(needs));
  }

  final PetNeeds needs;
  final PetMood mood;
}

/// Owns care meters; does not drive Rive artboards ([CrumboCubit] does).
class NeedsCubit extends Cubit<NeedsState> {
  NeedsCubit({
    NeedsRepository? repository,
    DateTime Function()? clock,
  })  : _repository = repository ?? _defaultRepository(),
        _clock = clock ?? DateTime.now,
        super(NeedsState.fromNeeds(PetNeeds.fresh()));

  static NeedsRepository _defaultRepository() {
    if (GetIt.instance.isRegistered<NeedsRepository>()) {
      return getIt<NeedsRepository>();
    }
    return MemoryNeedsRepository();
  }

  final NeedsRepository _repository;
  final DateTime Function() _clock;

  Future<void> hydrate() async {
    final loaded = await _repository.load(now: _clock());
    final decayed = NeedsDecay.apply(loaded, _clock());
    await _repository.save(decayed);
    if (!isClosed) emit(NeedsState.fromNeeds(decayed));
  }

  /// Re-apply decay on resume / foreground.
  Future<void> touch() => hydrate();

  Future<void> boost(NeedKind kind, double delta) async {
    final next = state.needs.boost(kind, delta).copyWith(lastSeenAt: _clock());
    await _repository.save(next);
    if (!isClosed) emit(NeedsState.fromNeeds(next));
  }
}
