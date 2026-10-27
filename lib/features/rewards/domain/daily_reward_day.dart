class DailyRewardDay {
  const DailyRewardDay({required this.day, required this.coins});

  final int day;
  final int coins;

  factory DailyRewardDay.fromJson(Map<String, dynamic> json) {
    return DailyRewardDay(
      day: (json['day'] as num).toInt(),
      coins: (json['coins'] as num?)?.toInt() ?? 0,
    );
  }
}
