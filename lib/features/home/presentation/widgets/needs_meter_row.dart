import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/glossy_button.dart';
import '../../../../core/ui/rounded_progress_bar.dart';
import '../../../crumbo/domain/need_kind.dart';
import '../../../crumbo/domain/pet_mood.dart';
import '../../../crumbo/presentation/cubit/needs_cubit.dart';

/// Compact home meters + mood chip (not the Moods expression sheet).
class NeedsMeterRow extends StatelessWidget {
  const NeedsMeterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NeedsCubit, NeedsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Container(
            key: const Key('needs_meter_row'),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F4FF),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final kind in NeedKind.values) ...[
                      if (kind != NeedKind.values.first)
                        const SizedBox(width: 4),
                      Expanded(child: _NeedMeter(kind: kind)),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                _MoodChip(mood: state.mood),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NeedMeter extends StatelessWidget {
  const _NeedMeter({required this.kind});

  final NeedKind kind;

  static const _circleSize = 42.0;

  @override
  Widget build(BuildContext context) {
    final value = context.select<NeedsCubit, double>(
      (c) => c.state.needs.valueOf(kind) / 100,
    );
    final color = _colorFor(kind);
    return Column(
      key: Key('need_${kind.name}'),
      mainAxisSize: MainAxisSize.min,
      children: [
        GlossySurface(
          circle: true,
          color: color,
          child: SizedBox(
            width: _circleSize,
            height: _circleSize,
            child: Icon(
              _iconFor(kind),
              color: Colors.white,
              size: _circleSize * 0.46,
            ),
          ),
        ),
        const SizedBox(height: 6),
        RoundedProgressBar(
          value: value,
          shine: false,
          fillColor: color,
          height: 8,
        ),
      ],
    );
  }

  static IconData _iconFor(NeedKind kind) {
    return switch (kind) {
      NeedKind.hunger => Icons.restaurant_rounded,
      NeedKind.sleep => Icons.nightlight_round,
      NeedKind.fun => Icons.sports_esports_rounded,
      NeedKind.clean => Icons.bathtub_rounded,
      NeedKind.love => Icons.favorite_rounded,
    };
  }

  static Color _colorFor(NeedKind kind) {
    return switch (kind) {
      NeedKind.hunger => const Color(0xFFFF6B6B),
      NeedKind.sleep => GameColors.purple,
      NeedKind.fun => const Color(0xFFFFC107),
      NeedKind.clean => const Color(0xFF26C6DA),
      NeedKind.love => GameColors.pink,
    };
  }
}

class _MoodChip extends StatelessWidget {
  const _MoodChip({required this.mood});

  final PetMood mood;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: const Key('pet_mood_chip'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: GameColors.ink.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Text(
          'Mood: ${mood.label}',
          style: const TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: GameColors.ink,
          ),
        ),
      ),
    );
  }
}
