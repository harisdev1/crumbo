import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../crumbo/presentation/cubit/crumbo_cubit.dart';
import '../../../crumbo/presentation/cubit/needs_cubit.dart';
import '../../../crumbo/presentation/widgets/crumbo_view.dart';
import '../../../economy/presentation/cubit/economy_cubit.dart';
import '../../../voice/data/fake_voice_services.dart';
import '../../../voice/data/voice_preset_store.dart';
import '../../../voice/domain/voice_player.dart';
import '../../../voice/domain/voice_recorder.dart';
import '../../../voice/presentation/cubit/voice_cubit.dart';
import '../../../voice/presentation/widgets/voice_bar.dart';
import '../../domain/home_room.dart';
import '../cubit/home_theme_cubit.dart';
import '../cubit/room_cubit.dart';
import '../widgets/bath_tray.dart';
import '../widgets/care_action_bar.dart';
import '../widgets/exit_dialog.dart';
import '../widgets/food_tray.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/needs_meter_row.dart';
import '../widgets/owl_feed_target.dart';
import '../widgets/owl_perch_layer.dart';
import '../widgets/room_chip_bar.dart';
import '../widgets/skins_sheet.dart';
import '../widgets/sleep_dim.dart';
import '../widgets/themed_background.dart';
import '../widgets/themes_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.character});

  static const tagline = 'A cute little owl with big feelings.';

  /// Override for widget tests (avoids loading `rive_native` in CI/desktop).
  final Widget? character;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CrumboCubit()..hydrate(),
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => HomeThemeCubit()..hydrate()),
              BlocProvider(create: (_) => NeedsCubit()..hydrate()),
              BlocProvider(create: (_) => EconomyCubit()..hydrate()),
              BlocProvider(
                create: (ctx) {
                  final rooms = RoomCubit()..hydrate();
                  rooms.bindThemeCubit(ctx.read<HomeThemeCubit>());
                  return rooms;
                },
              ),
              BlocProvider(
                create: (_) => _createVoiceCubit(context.read<CrumboCubit>())
                  ..hydrate(),
              ),
            ],
            child: _HomeLifecycle(character: character),
          );
        },
      ),
    );
  }
}

VoiceCubit _createVoiceCubit(CrumboCubit crumbo) {
  final gi = GetIt.instance;
  final recorder = gi.isRegistered<VoiceRecorder>()
      ? gi.get<VoiceRecorder>()
      : FakeVoiceRecorder();
  final player =
      gi.isRegistered<VoicePlayer>() ? gi.get<VoicePlayer>() : FakeVoicePlayer();
  final presets = gi.isRegistered<VoicePresetStore>()
      ? gi.get<VoicePresetStore>()
      : MemoryVoicePresetStore();
  return VoiceCubit(
    recorder: recorder,
    player: player,
    presetStore: presets,
    crumboCubit: crumbo,
  );
}

/// Re-applies needs decay when the app returns to foreground.
class _HomeLifecycle extends StatefulWidget {
  const _HomeLifecycle({this.character});

  final Widget? character;

  @override
  State<_HomeLifecycle> createState() => _HomeLifecycleState();
}

class _HomeLifecycleState extends State<_HomeLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<NeedsCubit>().touch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _HomeBody(character: widget.character);
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({this.character});

  final Widget? character;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        showExitDialog(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF9FD6FF),
        body: Stack(
          fit: StackFit.expand,
          children: [
            const ThemedBackground(key: Key('home_background')),
            OwlPerchLayer(
              child: OwlFeedTarget(child: character ?? const CrumboView()),
            ),
            const SleepDim(),
            SafeArea(
              child: Column(
                children: [
                  const HomeTopBar(),
                  const SizedBox(height: 6),
                  const RoomChipBar(),
                  const SizedBox(height: 4),
                  const NeedsMeterRow(),
                  const SizedBox(height: 6),
                  const _TitleRow(),
                  // Let taps reach the owl below; only [OwlBodyTapShell] handles bonks.
                  const Expanded(child: SizedBox.shrink()),
                  const _ThemedCaptions(),
                  const _RoomTrays(),
                  // Presets / Allow Mic only while voice active — keeps owl taps clear.
                  const VoiceBar(),
                  const CareActionBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomTrays extends StatelessWidget {
  const _RoomTrays();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, HomeRoom>(
      builder: (context, room) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (room.showsFoodTray) const FoodTray(),
            if (room.showsBathTray) const BathTray(),
          ],
        );
      },
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          ThemesButton(),
          Expanded(child: SizedBox.shrink()),
          // Center "Owl" title pill hidden for now.
          // Expanded(child: Center(child: _BubbleTitle())),
          SkinsButton(),
        ],
      ),
    );
  }
}

// Center "Owl" title pill hidden for now.
/*
class _BubbleTitle extends StatelessWidget {
  const _BubbleTitle();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: CrumboColors.crust.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        'Owl',
        key: const Key('home_title'),
        style: const TextStyle(
          fontFamily: AppTheme.displayFamily,
          fontSize: 28,
          color: GameColors.ink,
        ),
      ),
    );
  }
}
*/

/// Tagline + credit; colors animate with the background theme.
class _ThemedCaptions extends StatelessWidget {
  const _ThemedCaptions();

  @override
  Widget build(BuildContext context) {
    // "A cute little owl with big feelings." hidden for now.
    // Text(HomePage.tagline, key: Key('home_tagline')),
    // Owl art credit hidden for now.
    /*
    final dark = context.select<HomeThemeCubit, bool>(
      (c) => c.activeTheme.isDark,
    );
    final base = Theme.of(context).textTheme;
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 700),
      style: (base.labelSmall ?? const TextStyle()).copyWith(
        color: dark
            ? Colors.white.withValues(alpha: 0.7)
            : CrumboColors.detail.withValues(alpha: 0.65),
        fontSize: 10,
      ),
      child: const Text(
        'Owl art © AnggaMotion (CC BY)',
        key: Key('owl_attribution'),
      ),
    );
    */
    return const SizedBox.shrink();
  }
}

// Mood line ("Tap me!", "Zzz — tap to wake", …). Hidden for now.
/*
class _StatusBubble extends StatelessWidget {
  const _StatusBubble();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrumboCubit, CrumboCharacterState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            state.expression.statusLabel,
            key: const Key('crumbo_status'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: CrumboColors.crust,
                  fontWeight: FontWeight.w700,
                ),
          ),
        );
      },
    );
  }
}
*/
