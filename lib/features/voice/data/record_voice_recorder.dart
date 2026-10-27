import 'dart:io';
import 'dart:math' as math;

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../domain/voice_recorder.dart';

class RecordVoiceRecorder implements VoiceRecorder {
  RecordVoiceRecorder({AudioRecorder? recorder})
      : _recorder = recorder ?? AudioRecorder();

  final AudioRecorder _recorder;
  String? _path;

  @override
  Future<bool> hasPermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  @override
  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  @override
  Future<bool> isPermanentlyDenied() async {
    final status = await Permission.microphone.status;
    return status.isPermanentlyDenied;
  }

  @override
  Future<void> openSystemSettings() => openAppSettings();

  @override
  Future<String> start() async {
    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}${Platform.pathSeparator}crumbo_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: path,
    );
    _path = path;
    return path;
  }

  @override
  Future<String?> stop() async {
    final path = await _recorder.stop() ?? _path;
    _path = path;
    return path;
  }

  @override
  Future<void> cancel() async {
    final path = _path;
    _path = null;
    try {
      if (await _recorder.isRecording()) {
        await _recorder.stop();
      }
    } catch (_) {}
    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  @override
  Future<double?> amplitude() async {
    try {
      final amp = await _recorder.getAmplitude();
      // current is dBFS (typically -160..0). Map to 0..1.
      final db = amp.current;
      if (db.isNaN || db.isInfinite) return 0;
      final normalized = (db + 60) / 60;
      return normalized.clamp(0.0, 1.0);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> dispose() async {
    await cancel();
    await _recorder.dispose();
  }
}

/// Maps raw dBFS into 0..1 for tests / docs.
double normalizeDbFs(double db) {
  if (db.isNaN || db.isInfinite) return 0;
  return ((db + 60) / 60).clamp(0.0, 1.0);
}

double loudnessFromLinear(double linear) =>
    linear <= 0 ? 0 : math.min(1.0, linear);
