/// Local coins + gems (no personal data).
class Wallet {
  const Wallet({required this.coins, required this.gems});

  final int coins;
  final int gems;

  static const starterCoins = 50;
  static const starterGems = 5;

  factory Wallet.starter() => const Wallet(
        coins: starterCoins,
        gems: starterGems,
      );

  factory Wallet.zero() => const Wallet(coins: 0, gems: 0);

  Wallet copyWith({int? coins, int? gems}) {
    return Wallet(
      coins: coins ?? this.coins,
      gems: gems ?? this.gems,
    );
  }

  Wallet addCoins(int amount) {
    if (amount <= 0) return this;
    return copyWith(coins: coins + amount);
  }

  Wallet addGems(int amount) {
    if (amount <= 0) return this;
    return copyWith(gems: gems + amount);
  }

  /// Returns null if not enough coins.
  Wallet? trySpendCoins(int amount) {
    if (amount <= 0) return this;
    if (coins < amount) return null;
    return copyWith(coins: coins - amount);
  }

  /// Returns null if not enough gems.
  Wallet? trySpendGems(int amount) {
    if (amount <= 0) return this;
    if (gems < amount) return null;
    return copyWith(gems: gems - amount);
  }

  @override
  bool operator ==(Object other) =>
      other is Wallet && other.coins == coins && other.gems == gems;

  @override
  int get hashCode => Object.hash(coins, gems);
}
