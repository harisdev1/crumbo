import 'splash_flow.dart';

/// Splash hero PNGs (Photoroom exports).
abstract final class SplashIcons {
  static const paths = <String>[
    'assets/images/splash_icons/1-Photoroom.png',
    'assets/images/splash_icons/2-Photoroom.png',
  ];

  /// Which frame we start on for this launch (does not affect saved owl skin).
  static int launchFrameIndex(int seed) => splashSkinIndex(paths.length, seed);
}
