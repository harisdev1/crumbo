import '../domain/voice_player.dart';
import '../domain/voice_preset.dart';
import '../domain/voice_recorder.dart';

/// Plugin-free recorder for widget tests / DI fallback.
class FakeVoiceRecorder implements VoiceRecorder {
  FakeVoiceRecorder({
    this.grantOnRequest = true,
    this.permanentlyDenied = false,
  });

  bool grantOnRequest;
  bool permanentlyDenied;
  bool openSettingsCalled = false;
  bool recording = false;
  String? path;
  final List<double> amplitudeQueue = [];
  int _ampIndex = 0;
  final List<String> deletedPaths = [];

  @override
  Future<bool> hasPermission() async => grantOnRequest && !permanentlyDenied;

  @override
  Future<bool> requestPermission() async {
    if (permanentlyDenied) return false;
    return grantOnRequest;
  }

  @override
  Future<bool> isPermanentlyDenied() async => permanentlyDenied;

  @override
  Future<void> openSystemSettings() async {
    openSettingsCalled = true;
  }

  @override
  Future<String> start() async {
    recording = true;
    path = 'fake_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _ampIndex = 0;
    return path!;
  }

  @override
  Future<String?> stop() async {
    recording = false;
    return path;
  }

  @override
  Future<void> cancel() async {
    recording = false;
    if (path != null) deletedPaths.add(path!);
    path = null;
  }

  @override
  Future<double?> amplitude() async {
    if (_ampIndex < amplitudeQueue.length) {
      return amplitudeQueue[_ampIndex++];
    }
    return 0.5;
  }

  @override
  Future<void> dispose() async {}
}

class FakeVoicePlayer implements VoicePlayer {
  final List<({String path, VoicePreset preset})> played = [];
  Duration playDelay = Duration.zero;

  @override
  Future<void> play(String path, VoicePreset preset) async {
    played.add((path: path, preset: preset));
    if (playDelay > Duration.zero) {
      await Future<void>.delayed(playDelay);
    }
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}
