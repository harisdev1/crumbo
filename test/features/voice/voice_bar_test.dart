import 'package:crumbo/features/crumbo/presentation/cubit/crumbo_cubit.dart';
import 'package:crumbo/features/home/presentation/widgets/care_action_bar.dart';
import 'package:crumbo/features/voice/data/fake_voice_services.dart';
import 'package:crumbo/features/voice/data/voice_preset_store.dart';
import 'package:crumbo/features/voice/domain/voice_phase.dart';
import 'package:crumbo/features/voice/presentation/cubit/voice_cubit.dart';
import 'package:crumbo/features/voice/presentation/widgets/voice_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('mic on care bar; deny shows Allow Mic', (tester) async {
    final crumbo = CrumboCubit();
    final recorder = FakeVoiceRecorder(grantOnRequest: false);
    final cubit = VoiceCubit(
      recorder: recorder,
      player: FakeVoicePlayer(),
      presetStore: MemoryVoicePresetStore(),
      crumboCubit: crumbo,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: crumbo),
            BlocProvider.value(value: cubit),
          ],
          child: const Scaffold(
            body: Column(
              children: [
                VoiceBar(),
                CareActionBar(),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('action_mic')), findsOneWidget);
    expect(find.byKey(const Key('voice_bar')), findsOneWidget);

    await tester.tap(find.byKey(const Key('action_mic')));
    await tester.pumpAndSettle();

    expect(cubit.state.phase, VoicePhase.denied);
    expect(find.byKey(const Key('voice_allow_mic')), findsOneWidget);

    await cubit.close();
    await crumbo.close();
  });
}
