import 'package:just_audio/just_audio.dart';

import '../domain/voice_player.dart';
import '../domain/voice_preset.dart';

class JustAudioVoicePlayer implements VoicePlayer {
  JustAudioVoicePlayer({AudioPlayer? player})
      : _player = player ?? AudioPlayer();

  final AudioPlayer _player;

  @override
  Future<void> play(String path, VoicePreset preset) async {
    await _player.stop();
    await _player.setFilePath(path);
    await _player.setSpeed(preset.speed);
    await _player.play();
    await _player.processingStateStream.firstWhere(
      (state) =>
          state == ProcessingState.completed || state == ProcessingState.idle,
    );
  }

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> dispose() => _player.dispose();
}
