class DailyStreakState {
  const DailyStreakState({
    required this.streakDay,
    this.lastClaimDate,
  });

  /// Last successfully claimed day in the current cycle (0 = none).
  final int streakDay;

  /// Local calendar date `yyyy-MM-dd` of last claim, if any.
  final String? lastClaimDate;

  static const empty = DailyStreakState(streakDay: 0);

  DailyStreakState copyWith({int? streakDay, String? lastClaimDate}) {
    return DailyStreakState(
      streakDay: streakDay ?? this.streakDay,
      lastClaimDate: lastClaimDate ?? this.lastClaimDate,
    );
  }
}

enum DailyClaimAvailability {
  canClaim,
  alreadyClaimedToday,
}

class DailyClaimPlan {
  const DailyClaimPlan({
    required this.availability,
    required this.nextDay,
    required this.streakBroken,
  });

  final DailyClaimAvailability availability;
  final int nextDay;
  final bool streakBroken;
}
