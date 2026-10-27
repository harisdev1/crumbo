import 'daily_streak_state.dart';

abstract final class DailyClaimLogic {
  static String formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static DateTime dateOnly(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  /// Yesterday relative to [today] (date-only).
  static String yesterdayOf(DateTime today) {
    return formatDate(dateOnly(today).subtract(const Duration(days: 1)));
  }

  static DailyClaimPlan evaluate({
    required DailyStreakState state,
    required DateTime now,
  }) {
    final today = formatDate(now);
    if (state.lastClaimDate == today) {
      return DailyClaimPlan(
        availability: DailyClaimAvailability.alreadyClaimedToday,
        nextDay: state.streakDay == 0 ? 1 : state.streakDay,
        streakBroken: false,
      );
    }

    final broken = _isStreakBroken(state, today, now);
    final nextDay = broken
        ? 1
        : (state.streakDay >= 7 ? 1 : state.streakDay + 1);

    return DailyClaimPlan(
      availability: DailyClaimAvailability.canClaim,
      nextDay: nextDay,
      streakBroken: broken,
    );
  }

  static bool _isStreakBroken(
    DailyStreakState state,
    String today,
    DateTime now,
  ) {
    final last = state.lastClaimDate;
    if (last == null || state.streakDay == 0) return false;
    if (last == today) return false;
    if (last == yesterdayOf(now)) return false;
    return true;
  }

  static DailyStreakState applyClaim({
    required DailyStreakState state,
    required int claimedDay,
    required DateTime now,
  }) {
    return DailyStreakState(
      streakDay: claimedDay,
      lastClaimDate: formatDate(now),
    );
  }

  /// Days 1..streakDay are claimed in the current unbroken cycle.
  static bool isDayClaimedInCycle({
    required DailyStreakState state,
    required int day,
    required DateTime now,
  }) {
    final plan = evaluate(state: state, now: now);
    if (plan.streakBroken) return false;
    if (state.streakDay <= 0) return false;
    return day <= state.streakDay;
  }
}
