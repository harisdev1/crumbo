import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/glossy_icon_button.dart';
import '../../domain/voice_phase.dart';
import '../../domain/voice_preset.dart';
import '../cubit/voice_cubit.dart';

/// Denied Allow-Mic row + compact voice preset chips (Mic lives on care bar).
class VoiceBar extends StatelessWidget {
  const VoiceBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VoiceCubit, VoiceState>(
      listenWhen: (prev, next) =>
          prev.message != next.message && next.message != null,
      listener: (context, state) {
        final msg = state.message;
        if (msg == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      builder: (context, state) {
        final denied = state.phase == VoicePhase.denied;
        final active = state.phase == VoicePhase.listening ||
            state.phase == VoicePhase.talking ||
            denied;

        // Idle: zero height so home owl taps stay hittable.
        if (!active) {
          return const SizedBox.shrink(key: Key('voice_bar'));
        }

        return Padding(
          key: const Key('voice_bar'),
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (denied) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GlossyIconButton(
                      key: const Key('voice_allow_mic'),
                      icon: Icons.mic_rounded,
                      label: 'Allow Mic',
                      color: GameColors.coral,
                      size: 42,
                      onTap: () => context.read<VoiceCubit>().onAllowMicTap(),
                    ),
                    const SizedBox(width: 10),
                    GlossyIconButton(
                      key: const Key('voice_dismiss_denied'),
                      icon: Icons.close_rounded,
                      label: 'Later',
                      color: GameColors.ink,
                      size: 36,
                      onTap: () => context.read<VoiceCubit>().dismissDenied(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
              if (!denied)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final preset in VoicePreset.values)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: _PresetChip(
                          key: Key('voice_preset_${preset.id}'),
                          preset: preset,
                          selected: state.preset == preset,
                          onTap: () =>
                              context.read<VoiceCubit>().setPreset(preset),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    super.key,
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final VoicePreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: selected
              ? GameColors.purple.withValues(alpha: 0.85)
              : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? GameColors.purple : Colors.white,
            width: 2,
          ),
        ),
        child: Text(
          preset.label,
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 11,
            color: selected ? Colors.white : GameColors.ink,
          ),
        ),
      ),
    );
  }
}
