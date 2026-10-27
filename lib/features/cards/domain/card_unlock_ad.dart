/// Ad gateway for card unlocks — real AdMob arrives in D1–D2.
abstract class CardUnlockAd {
  bool get isAvailable;
  Future<bool> showRewarded(String placement);
}

class UnavailableCardUnlockAd implements CardUnlockAd {
  const UnavailableCardUnlockAd();

  @override
  bool get isAvailable => false;

  @override
  Future<bool> showRewarded(String placement) async => false;
}
