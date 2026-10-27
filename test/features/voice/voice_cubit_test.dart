import 'package:crumbo/features/crumbo/domain/owl_expression.dart';
import 'package:crumbo/features/crumbo/presentation/cubit/crumbo_cubit.dart';
import 'package:crumbo/features/voice/data/fake_voice_services.dart';
import 'package:crumbo/features/voice/data/voice_preset_store.dart';
import 'package:crumbo/features/voice/domain/silence_detector.dart';
import 'package:crumbo/features/voice/domain/voice_phase.dart';
import 'package:crumbo/features/voice/domain/voice_preset.dart';
import 'package:crumbo/features/voice/presentation/cubit/voice_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CrumboCubit crumbo;
  late FakeVoiceRecorder recorder;
  late FakeVoicePlayer player;
  late MemoryVoicePresetStore presets;
  late VoiceCubit cubit;

  setUp(() {
    crumbo = CrumboCubit();
    recorder = FakeVoiceRecorder();
    player = FakeVoicePlayer();
    presets = MemoryVoicePresetStore();
    cubit = VoiceCubit(
      recorder: recorder,
      player: player,
      presetStore: presets,
      crumboCubit: crumbo,
      silenceDetector: SilenceDetector(
        quietThreshold: 0.1,
        quietStreakNeeded: 2,
        minSamplesBeforeStop: 2,
      ),
      amplitudePollInterval: const Duration(milliseconds: 20),
      maxListenDuration: const Duration(seconds: 30),
    );
  });

  tearDown(() async {
    await cubit.close();
    await crumbo.close();
  });

  test('deny shows denied phase', () async {
    recorder.grantOnRequest = false;
    await cubit.onMicTap();
    expect(cubit.state.phase, VoicePhase.denied);
    expect(crumbo.state.expression, OwlExpression.idle);
  });

  test('allow mic retry after deny', () async {
    recorder.grantOnRequest = false;
    await cubit.onMicTap();
    expect(cubit.state.phase, VoicePhase.denied);

    recorder.grantOnRequest = true;
    await cubit.onAllowMicTap();
    expect(cubit.state.phase, VoicePhase.listening);
    expect(crumbo.state.expression, OwlExpression.listen);
  });

  test('permanent deny opens settings', () async {
    recorder.permanentlyDenied = true;
    recorder.grantOnRequest = false;
    await cubit.onMicTap();
    await cubit.onAllowMicTap();
    expect(recorder.openSettingsCalled, isTrue);
    expect(cubit.state.phase, VoicePhase.denied);
  });

  test('listen then stop plays and returns idle with talk expression mid-flight',
      () async {
    player.playDelay = const Duration(milliseconds: 40);
    await cubit.onMicTap();
    expect(cubit.state.phase, VoicePhase.listening);
    expect(crumbo.state.expression, OwlExpression.listen);

    final stopFuture = cubit.onMicTap();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(cubit.state.phase, VoicePhase.talking);
    expect(crumbo.state.expression, OwlExpression.talk);

    await stopFuture;
    expect(player.played, isNotEmpty);
    expect(cubit.state.phase, VoicePhase.idle);
    expect(crumbo.state.expression, OwlExpression.idle);
  });

  test('silence stops listening', () async {
    recorder.amplitudeQueue.addAll([0.5, 0.0, 0.0]);
    await cubit.onMicTap();
    await Future<void>.delayed(const Duration(milliseconds: 120));
    expect(player.played, isNotEmpty);
    expect(cubit.state.phase, VoicePhase.idle);
  });

  test('setPreset persists', () async {
    await cubit.setPreset(VoicePreset.sleepy);
    expect(cubit.state.preset, VoicePreset.sleepy);
    expect(await presets.read(), VoicePreset.sleepy);
  });
}
