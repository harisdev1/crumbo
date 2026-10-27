import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/glossy_button.dart';
import '../../../../core/ui/glossy_icon_button.dart';
import '../../../crumbo/domain/need_kind.dart';
import '../../../crumbo/domain/owl_expression.dart';
import '../../../crumbo/presentation/cubit/crumbo_cubit.dart';
import '../../../crumbo/presentation/cubit/needs_cubit.dart';
import '../../domain/bath_item.dart';

/// Bath tools + Clean action (B1 front-facing riv moods).
class BathTray extends StatelessWidget {
  const BathTray({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('bath_tray'),
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Bath & clean — drag tools to owl',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: GameColors.ink.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final item in BathItem.tray) _BathChip(item: item),
              GlossyIconButton(
                key: const Key('action_clean'),
                icon: Icons.auto_awesome_rounded,
                label: 'Clean',
                color: const Color(0xFFFFC107),
                size: 42,
                onTap: () {
                  context.read<CrumboCubit>().setExpression(OwlExpression.clean);
                  context.read<NeedsCubit>().boost(
                        NeedKind.clean,
                        BathItem.cleanBoost,
                      );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BathChip extends StatelessWidget {
  const _BathChip({required this.item});

  final BathItem item;

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      key: Key('bath_${item.id}'),
      data: item.id,
      feedback: Material(
        color: Colors.transparent,
        child: GlossySurface(
          circle: true,
          color: item.color,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(item.icon, color: Colors.white, size: 26),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.35,
        child: _chipFace(item),
      ),
      child: _chipFace(item),
    );
  }

  Widget _chipFace(BathItem item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GlossySurface(
          circle: true,
          color: item.color,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(item.icon, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.label,
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 11,
            color: GameColors.ink,
          ),
        ),
      ],
    );
  }
}
