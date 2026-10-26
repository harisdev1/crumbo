import 'need_kind.dart';

/// Five care meters 0–100 plus last-seen for offline decay.
class PetNeeds {
  const PetNeeds({
    required this.hunger,
    required this.sleep,
    required this.fun,
    required this.clean,
    required this.love,
    required this.lastSeenAt,
  });

  /// First-launch defaults — not full so decay is visible in testing.
  factory PetNeeds.fresh({DateTime? at}) {
    final now = at ?? DateTime.now();
    return PetNeeds(
      hunger: defaultLevel,
      sleep: defaultLevel,
      fun: defaultLevel,
      clean: defaultLevel,
      love: defaultLevel,
      lastSeenAt: now,
    );
  }

  static const defaultLevel = 80.0;

  final double hunger;
  final double sleep;
  final double fun;
  final double clean;
  final double love;
  final DateTime lastSeenAt;

  double get average => (hunger + sleep + fun + clean + love) / 5;

  double valueOf(NeedKind kind) {
    return switch (kind) {
      NeedKind.hunger => hunger,
      NeedKind.sleep => sleep,
      NeedKind.fun => fun,
      NeedKind.clean => clean,
      NeedKind.love => love,
    };
  }

  PetNeeds copyWith({
    double? hunger,
    double? sleep,
    double? fun,
    double? clean,
    double? love,
    DateTime? lastSeenAt,
  }) {
    return PetNeeds(
      hunger: hunger ?? this.hunger,
      sleep: sleep ?? this.sleep,
      fun: fun ?? this.fun,
      clean: clean ?? this.clean,
      love: love ?? this.love,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }

  PetNeeds clampAll() {
    return PetNeeds(
      hunger: _clamp(hunger),
      sleep: _clamp(sleep),
      fun: _clamp(fun),
      clean: _clamp(clean),
      love: _clamp(love),
      lastSeenAt: lastSeenAt,
    );
  }

  PetNeeds boost(NeedKind kind, double delta) {
    return switch (kind) {
      NeedKind.hunger => copyWith(hunger: _clamp(hunger + delta)),
      NeedKind.sleep => copyWith(sleep: _clamp(sleep + delta)),
      NeedKind.fun => copyWith(fun: _clamp(fun + delta)),
      NeedKind.clean => copyWith(clean: _clamp(clean + delta)),
      NeedKind.love => copyWith(love: _clamp(love + delta)),
    };
  }

  static double _clamp(double v) => v.clamp(0.0, 100.0);

  @override
  bool operator ==(Object other) {
    return other is PetNeeds &&
        other.hunger == hunger &&
        other.sleep == sleep &&
        other.fun == fun &&
        other.clean == clean &&
        other.love == love &&
        other.lastSeenAt == lastSeenAt;
  }

  @override
  int get hashCode => Object.hash(hunger, sleep, fun, clean, love, lastSeenAt);
}
