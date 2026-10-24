import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../crumbo/domain/owl_expression.dart';
import '../../../crumbo/presentation/cubit/crumbo_cubit.dart';

String actionKeyFor(OwlExpression expression) {
  return switch (expression) {
    OwlExpression.sleep => 'action_sleep',
    OwlExpression.think => 'action_idle',
    OwlExpression.wink => 'action_wink',
    OwlExpression.eat => 'action_eat',
    OwlExpression.happy => 'action_dance',
    OwlExpression.wave => 'action_poke',
    OwlExpression.cool => 'action_cool',
    OwlExpression.bubbles => 'action_bubbles',
    _ => 'action_${expression.name}',
  };
}

/// Bottom care row: Sleep / Eat / Happy / Wink + More.
class CareActionBar extends StatelessWidget {
  const CareActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrumboCubit, CrumboCharacterState>(
      builder: (context, state) {
        return Container(
          key: const Key('care_action_bar'),
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final expression in OwlExpression.careBar)
                CareBubbleButton(
                  key: Key(actionKeyFor(expression)),
                  expression: expression,
                  selected: state.expression == expression,
                  locked: !OwlExpression.isUnlocked(expression),
                  onTap: () => _onExpressionTap(context, expression),
                ),
              CareBubbleButton(
                key: const Key('action_more'),
                icon: Icons.apps_rounded,
                label: 'More',
                color: const Color(0xFF90CAF9),
                selected: false,
                locked: false,
                onTap: () => showMoreMoodsSheet(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

void _onExpressionTap(BuildContext context, OwlExpression expression) {
  if (!OwlExpression.isUnlocked(expression)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Locked — play more to unlock!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }

  final cubit = context.read<CrumboCubit>();
  if (expression == OwlExpression.wave) {
    cubit.poke();
  } else if (expression == OwlExpression.eat) {
    cubit.toggleEat();
  } else {
    cubit.setExpression(expression);
  }
}

Future<void> showMoreMoodsSheet(BuildContext context) {
  final cubit = context.read<CrumboCubit>();
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return BlocProvider.value(
        value: cubit,
        child: const _MoreMoodsSheet(),
      );
    },
  );
}

class _MoreMoodsSheet extends StatelessWidget {
  const _MoreMoodsSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('more_moods_sheet'),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 12),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EF),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: CrumboColors.detail.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Text(
              'More moods',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: CrumboColors.crust,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'New ones unlock as you play',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CrumboColors.detail.withValues(alpha: 0.8),
                  ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<CrumboCubit, CrumboCharacterState>(
              builder: (context, state) {
                return Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final expression in OwlExpression.moreTray)
                      CareBubbleButton(
                        key: Key(actionKeyFor(expression)),
                        expression: expression,
                        selected: state.expression == expression,
                        locked: !OwlExpression.isUnlocked(expression),
                        onTap: () {
                          if (!OwlExpression.isUnlocked(expression)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Locked — play more to unlock!'),
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          _onExpressionTap(context, expression);
                          Navigator.of(context).pop();
                        },
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CareBubbleButton extends StatelessWidget {
  const CareBubbleButton({
    super.key,
    this.expression,
    this.icon,
    this.label,
    this.color,
    required this.selected,
    required this.locked,
    required this.onTap,
  }) : assert(expression != null || (icon != null && label != null && color != null));

  final OwlExpression? expression;
  final IconData? icon;
  final String? label;
  final Color? color;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final resolvedIcon = expression?.icon ?? icon!;
    final resolvedLabel = expression?.label ?? label!;
    final resolvedColor = expression?.color ?? color!;
    final size = selected ? 60.0 : 54.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: locked
                    ? resolvedColor.withValues(alpha: 0.45)
                    : resolvedColor,
                border: Border.all(
                  color: Colors.white,
                  width: selected ? 5 : 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: resolvedColor.withValues(alpha: 0.45),
                    blurRadius: selected ? 12 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    resolvedIcon,
                    color: Colors.white.withValues(alpha: locked ? 0.55 : 1),
                    size: selected ? 28 : 24,
                  ),
                  if (locked)
                    const Positioned(
                      right: 4,
                      bottom: 4,
                      child: Icon(
                        Icons.lock_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          resolvedLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: CrumboColors.detail,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 11,
              ),
        ),
      ],
    );
  }
}
