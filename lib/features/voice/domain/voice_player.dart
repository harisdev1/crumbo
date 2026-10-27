import 'voice_preset.dart';

/// Abstraction over clip playback — fakes in tests.
abstract class VoicePlayer {
  /// Play [path] with [preset] speed. Completes when done or error.
  Future<void> play(String path, VoicePreset preset);

  Future<void> stop();

  Future<void> dispose();
}
