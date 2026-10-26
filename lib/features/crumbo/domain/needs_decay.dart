import 'pet_needs.dart';

/// Offline / realtime drain of pet needs (points per real hour).
abstract final class NeedsDecay {
  static const hungerPerHour = 4.0;
  static const sleepPerHour = 3.0;
  static const funPerHour = 5.0;
  static const cleanPerHour = 2.0;
  static const lovePerHour = 2.5;

  /// Apply elapsed time since [current.lastSeenAt], clamp 0–100, stamp [now].
  static PetNeeds apply(PetNeeds current, DateTime now) {
    final hours =
        now.difference(current.lastSeenAt).inMilliseconds / 3600000.0;
    if (hours <= 0) {
      return current.copyWith(lastSeenAt: now);
    }

    return PetNeeds(
      hunger: current.hunger - hungerPerHour * hours,
      sleep: current.sleep - sleepPerHour * hours,
      fun: current.fun - funPerHour * hours,
      clean: current.clean - cleanPerHour * hours,
      love: current.love - lovePerHour * hours,
      lastSeenAt: now,
    ).clampAll();
  }
}
