import 'package:crumbo/features/splash/domain/splash_icons.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('splash icons list both Photoroom PNGs', () {
    expect(SplashIcons.paths, hasLength(2));
    expect(SplashIcons.paths.first, contains('1-Photoroom.png'));
    expect(SplashIcons.paths.last, contains('2-Photoroom.png'));
    expect(SplashIcons.launchFrameIndex(0), 0);
    expect(SplashIcons.launchFrameIndex(3), 1);
  });
}
