import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/home_room.dart';
import '../cubit/home_theme_cubit.dart';
import '../cubit/room_cubit.dart';

/// Kitchen / Bedroom / Bathroom switcher (B2).
class RoomChipBar extends StatelessWidget {
  const RoomChipBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, HomeRoom>(
      builder: (context, room) {
        return Padding(
          key: const Key('room_chip_bar'),
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
          child: Row(
            children: [
              for (final r in HomeRoom.values) ...[
                Expanded(
                  child: _RoomChip(
                    key: Key('room_${r.id}'),
                    room: r,
                    selected: room == r,
                    onTap: () async {
                      final roomCubit = context.read<RoomCubit>();
                      roomCubit.bindThemeCubit(context.read<HomeThemeCubit>());
                      await roomCubit.goTo(r);
                    },
                  ),
                ),
                if (r != HomeRoom.values.last) const SizedBox(width: 6),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _RoomChip extends StatelessWidget {
  const _RoomChip({
    super.key,
    required this.room,
    required this.selected,
    required this.onTap,
  });

  final HomeRoom room;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon => switch (room) {
        HomeRoom.kitchen => Icons.restaurant_rounded,
        HomeRoom.bedroom => Icons.bedtime_rounded,
        HomeRoom.bathroom => Icons.bathtub_rounded,
      };

  Color get _color => switch (room) {
        HomeRoom.kitchen => const Color(0xFFFFB74D),
        HomeRoom.bedroom => const Color(0xFF7EB8DA),
        HomeRoom.bathroom => const Color(0xFF4FC3F7),
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? _color.withValues(alpha: 0.95)
              : Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? _color : Colors.white,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _icon,
              size: 18,
              color: selected ? Colors.white : GameColors.ink,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                room.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : GameColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
