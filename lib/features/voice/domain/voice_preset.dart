/// Local funny voice presets — speed only (kids-safe, on-device).
enum VoicePreset {
  sleepy(id: 'sleepy', label: 'Sleepy', speed: 0.75),
  chipmunk(id: 'chipmunk', label: 'Chipmunk', speed: 1.45),
  deepHoot(id: 'deep_hoot', label: 'Deep Hoot', speed: 0.85);

  const VoicePreset({
    required this.id,
    required this.label,
    required this.speed,
  });

  final String id;
  final String label;

  /// Playback rate for [just_audio] `setSpeed`.
  final double speed;

  static const VoicePreset defaultPreset = VoicePreset.chipmunk;

  static VoicePreset fromId(String? id) {
    if (id == null) return defaultPreset;
    for (final preset in values) {
      if (preset.id == id) return preset;
    }
    return defaultPreset;
  }

  VoicePreset get next {
    final i = (index + 1) % values.length;
    return values[i];
  }
}
