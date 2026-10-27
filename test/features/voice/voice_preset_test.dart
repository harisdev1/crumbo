import 'package:crumbo/features/voice/domain/voice_preset.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('chipmunk is faster than sleepy', () {
    expect(VoicePreset.chipmunk.speed, greaterThan(VoicePreset.sleepy.speed));
  });

  test('deep hoot is slower than chipmunk', () {
    expect(VoicePreset.deepHoot.speed, lessThan(VoicePreset.chipmunk.speed));
  });

  test('fromId falls back to default', () {
    expect(VoicePreset.fromId(null), VoicePreset.defaultPreset);
    expect(VoicePreset.fromId('nope'), VoicePreset.defaultPreset);
    expect(VoicePreset.fromId('sleepy'), VoicePreset.sleepy);
  });
}
