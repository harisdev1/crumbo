import 'package:crumbo/features/voice/domain/silence_detector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('loud samples reset quiet streak', () {
    final detector = SilenceDetector(
      quietThreshold: 0.1,
      quietStreakNeeded: 3,
      minSamplesBeforeStop: 2,
    );
    expect(detector.addSample(0.01), isFalse);
    expect(detector.addSample(0.01), isFalse);
    expect(detector.addSample(0.5), isFalse);
    expect(detector.addSample(0.01), isFalse);
    expect(detector.addSample(0.01), isFalse);
    expect(detector.addSample(0.01), isTrue);
  });

  test('does not stop before min samples', () {
    final detector = SilenceDetector(
      quietThreshold: 0.1,
      quietStreakNeeded: 2,
      minSamplesBeforeStop: 5,
    );
    expect(detector.addSample(0), isFalse);
    expect(detector.addSample(0), isFalse);
    expect(detector.addSample(0), isFalse);
    expect(detector.addSample(0), isFalse);
    expect(detector.addSample(0), isTrue);
  });

  test('reset clears streak', () {
    final detector = SilenceDetector(
      quietThreshold: 0.1,
      quietStreakNeeded: 2,
      minSamplesBeforeStop: 1,
    );
    detector.addSample(0);
    detector.reset();
    expect(detector.addSample(0), isFalse);
    expect(detector.addSample(0), isTrue);
  });
}
