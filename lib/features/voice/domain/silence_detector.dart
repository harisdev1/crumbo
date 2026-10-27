/// Pure amplitude → silence stop decision (no plugins).
///
/// [amplitude] is expected in 0..1 (normalized from recorder dBFS).
class SilenceDetector {
  SilenceDetector({
    this.quietThreshold = 0.08,
    this.quietStreakNeeded = 4,
    this.minSamplesBeforeStop = 6,
  });

  /// Below this = quiet frame.
  final double quietThreshold;

  /// Consecutive quiet samples required to stop (~800ms–1.2s at ~250ms poll).
  final int quietStreakNeeded;

  /// Don't stop until we've heard at least this many samples (avoid instant cut).
  final int minSamplesBeforeStop;

  int _quietStreak = 0;
  int _sampleCount = 0;

  void reset() {
    _quietStreak = 0;
    _sampleCount = 0;
  }

  /// Feed one amplitude sample. Returns true when recording should stop.
  bool addSample(double amplitude) {
    _sampleCount++;
    final quiet = amplitude < quietThreshold;
    if (quiet) {
      _quietStreak++;
    } else {
      _quietStreak = 0;
    }
    if (_sampleCount < minSamplesBeforeStop) return false;
    return _quietStreak >= quietStreakNeeded;
  }
}
