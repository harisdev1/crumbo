import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../crumbo/presentation/cubit/crumbo_cubit.dart';
import '../../domain/silence_detector.dart';
import '../../domain/voice_phase.dart';
import '../../domain/voice_player.dart';
import '../../domain/voice_preset.dart';
import '../../domain/voice_recorder.dart';
import '../../data/voice_preset_store.dart';

class VoiceState {
  const VoiceState({
    this.phase = VoicePhase.idle,
    this.preset = VoicePreset.defaultPreset,
    this.message,
  });

  final VoicePhase phase;
  final VoicePreset preset;
  final String? message;

  VoiceState copyWith({
    VoicePhase? phase,
    VoicePreset? preset,
    String? message,
    bool clearMessage = false,
  }) {
    return VoiceState(
      phase: phase ?? this.phase,
      preset: preset ?? this.preset,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}

/// Talking-Tom loop: mic → listen riv → silence → talk riv → delete file.
class VoiceCubit extends Cubit<VoiceState> {
  VoiceCubit({
    required VoiceRecorder recorder,
    required VoicePlayer player,
    required VoicePresetStore presetStore,
    required CrumboCubit crumboCubit,
    SilenceDetector? silenceDetector,
    this.amplitudePollInterval = const Duration(milliseconds: 250),
    this.maxListenDuration = const Duration(seconds: 10),
  })  : _recorder = recorder,
        _player = player,
        _presetStore = presetStore,
        _crumbo = crumboCubit,
        _silence = silenceDetector ?? SilenceDetector(),
        super(const VoiceState());

  final VoiceRecorder _recorder;
  final VoicePlayer _player;
  final VoicePresetStore _presetStore;
  final CrumboCubit _crumbo;
  final SilenceDetector _silence;
  final Duration amplitudePollInterval;
  final Duration maxListenDuration;

  Timer? _ampTimer;
  Timer? _maxTimer;
  String? _sessionPath;
  bool _busy = false;

  Future<void> hydrate() async {
    final preset = await _presetStore.read();
    if (!isClosed) emit(state.copyWith(preset: preset));
  }

  Future<void> setPreset(VoicePreset preset) async {
    emit(state.copyWith(preset: preset));
    await _presetStore.write(preset);
  }

  /// Mic button: start listen, or stop early while listening.
  Future<void> onMicTap() async {
    if (_busy) return;
    if (state.phase == VoicePhase.talking) return;

    if (state.phase == VoicePhase.listening) {
      await _finishListeningAndPlay();
      return;
    }

    await _startListening();
  }

  /// Denied UI "Allow Mic" — re-request or open settings.
  Future<void> onAllowMicTap() async {
    if (_busy) return;
    final permanent = await _recorder.isPermanentlyDenied();
    if (permanent) {
      await _recorder.openSystemSettings();
      emit(
        state.copyWith(
          phase: VoicePhase.denied,
          message: 'Turn on Mic in Settings, then tap Allow Mic',
        ),
      );
      return;
    }
    await _startListening();
  }

  Future<void> dismissDenied() async {
    if (state.phase == VoicePhase.denied) {
      emit(state.copyWith(phase: VoicePhase.idle, clearMessage: true));
    }
  }

  Future<void> _startListening() async {
    _busy = true;
    try {
      final granted = await _recorder.requestPermission();
      if (!granted) {
        emit(
          state.copyWith(
            phase: VoicePhase.denied,
            message: 'Mic needed to talk with the owl',
          ),
        );
        return;
      }

      _silence.reset();
      _sessionPath = await _recorder.start();
      _crumbo.beginListening();
      emit(
        state.copyWith(
          phase: VoicePhase.listening,
          clearMessage: true,
        ),
      );
      _startAmpPolling();
      _maxTimer?.cancel();
      _maxTimer = Timer(maxListenDuration, () {
        unawaited(_finishListeningAndPlay());
      });
    } catch (_) {
      _crumbo.endVoice();
      emit(
        state.copyWith(
          phase: VoicePhase.idle,
          message: 'Could not start mic',
        ),
      );
    } finally {
      _busy = false;
    }
  }

  void _startAmpPolling() {
    _ampTimer?.cancel();
    _ampTimer = Timer.periodic(amplitudePollInterval, (_) async {
      if (state.phase != VoicePhase.listening) return;
      final amp = await _recorder.amplitude() ?? 0;
      if (_silence.addSample(amp)) {
        await _finishListeningAndPlay();
      }
    });
  }

  Future<void> _finishListeningAndPlay() async {
    if (state.phase != VoicePhase.listening) return;
    if (_busy) return;
    _busy = true;
    _ampTimer?.cancel();
    _maxTimer?.cancel();

    String? path;
    try {
      path = await _recorder.stop() ?? _sessionPath;
      _sessionPath = path;

      if (path == null) {
        _crumbo.endVoice();
        emit(state.copyWith(phase: VoicePhase.idle, clearMessage: true));
        return;
      }

      // Fakes use virtual paths; real recorder writes a temp file.
      final file = File(path);
      final exists = await file.exists();
      final isFakePath = path.startsWith('fake_voice_');
      if (!exists && !isFakePath) {
        _crumbo.endVoice();
        emit(state.copyWith(phase: VoicePhase.idle, clearMessage: true));
        return;
      }

      _crumbo.beginTalking();
      emit(state.copyWith(phase: VoicePhase.talking, clearMessage: true));

      try {
        await _player.play(path, state.preset);
      } catch (_) {
        // still delete below
      }
    } finally {
      await _deleteSessionFile(path ?? _sessionPath);
      _sessionPath = null;
      _crumbo.endVoice();
      if (!isClosed) {
        emit(state.copyWith(phase: VoicePhase.idle, clearMessage: true));
      }
      _busy = false;
    }
  }

  Future<void> _deleteSessionFile(String? path) async {
    if (path == null) return;
    if (path.startsWith('fake_voice_')) return;
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }

  @override
  Future<void> close() async {
    _ampTimer?.cancel();
    _maxTimer?.cancel();
    await _recorder.cancel();
    await _player.dispose();
    await _recorder.dispose();
    return super.close();
  }
}
