import 'package:hive_ce/hive.dart';

import '../../../core/storage/settings_keys.dart';
import '../domain/voice_preset.dart';

abstract class VoicePresetStore {
  Future<VoicePreset> read();
  Future<void> write(VoicePreset preset);
}

class HiveVoicePresetStore implements VoicePresetStore {
  HiveVoicePresetStore(this._settings);

  final Box<dynamic> _settings;

  @override
  Future<VoicePreset> read() async {
    final value = _settings.get(SettingsKeys.voicePreset);
    return VoicePreset.fromId(value is String ? value : null);
  }

  @override
  Future<void> write(VoicePreset preset) async {
    await _settings.put(SettingsKeys.voicePreset, preset.id);
  }
}

class MemoryVoicePresetStore implements VoicePresetStore {
  VoicePreset _preset = VoicePreset.defaultPreset;

  @override
  Future<VoicePreset> read() async => _preset;

  @override
  Future<void> write(VoicePreset preset) async {
    _preset = preset;
  }
}
