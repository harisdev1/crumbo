/// Abstraction over mic capture — fakes in tests.
abstract class VoiceRecorder {
  Future<bool> hasPermission();

  /// Returns true if granted after request (or already granted).
  Future<bool> requestPermission();

  /// Permanently denied — open system settings instead of OS dialog.
  Future<bool> isPermanentlyDenied();

  Future<void> openSystemSettings();

  /// Start recording to a temp path; returns path.
  Future<String> start();

  /// Stop and return path (same as start). Null if nothing was recording.
  Future<String?> stop();

  /// Cancel and delete without playback.
  Future<void> cancel();

  /// Normalized 0..1 amplitude, or null if unavailable.
  Future<double?> amplitude();

  Future<void> dispose();
}
