/// Index into the skin list for this launch. Does not touch the saved skin.
int splashSkinIndex(int skinCount, int seed) {
  if (skinCount <= 0) return 0;
  final safe = seed < 0 ? -seed : seed;
  return safe % skinCount;
}

/// 0 at the start of loading, 1 when [total] has elapsed.
double splashProgress(Duration elapsed, Duration total) {
  final totalUs = total.inMicroseconds;
  if (totalUs <= 0) return 1;
  final t = elapsed.inMicroseconds / totalUs;
  if (t <= 0) return 0;
  if (t >= 1) return 1;
  return t;
}
