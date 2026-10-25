import 'package:crumbo/features/splash/domain/splash_flow.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('splash skin index stays inside the catalog', () {
    expect(splashSkinIndex(20, 0), 0);
    expect(splashSkinIndex(20, 21), 1);
    expect(splashSkinIndex(20, -3), 3);
    expect(splashSkinIndex(0, 4), 0);
  });

  test('loading progress stays between 0 and 1', () {
    expect(
      splashProgress(const Duration(milliseconds: 500), const Duration(seconds: 1)),
      0.5,
    );
    expect(
      splashProgress(const Duration(seconds: 3), const Duration(seconds: 1)),
      1,
    );
    expect(splashProgress(Duration.zero, const Duration(seconds: 1)), 0);
  });
}
