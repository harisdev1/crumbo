import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/glass_panel.dart';
import '../../../../core/ui/glossy_icon_button.dart';
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

/// Bottom care row: Sleep / Eat / Play / Moods (all faces in one sheet).
class CareActionBar extends StatelessWidget {
  const CareActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrumboCubit, CrumboCharacterState>(
      builder: (context, state) {
        return Container(
          key: const Key('care_action_bar'),
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
              for (final expression in const [
                OwlExpression.sleep,
                OwlExpression.eat,
              ])
                CareBubbleButton(
                  key: Key(actionKeyFor(expression)),
                  expression: expression,
                  selected: state.expression == expression,
                  locked: !OwlExpression.isUnlocked(expression),
                  onTap: () => _onExpressionTap(context, expression),
                ),
              CareBubbleButton(
                key: const Key('action_play'),
                icon: Icons.sports_esports_rounded,
                label: 'Play',
                color: GameColors.purple,
                selected: false,
                locked: false,
                onTap: () => pushAppRoute(context, AppRoutes.play),
              ),
              CareBubbleButton(
                key: const Key('action_moods'),
                icon: Icons.emoji_emotions_rounded,
                label: 'Moods',
                color: const Color(0xFFFF8A65),
                selected: false,
                locked: false,
                onTap: () => showMoodsSheet(context),
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

Future<void> showMoodsSheet(BuildContext context) {
  final cubit = context.read<CrumboCubit>();
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return BlocProvider.value(
        value: cubit,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            12,
            0,
            12,
            12 + MediaQuery.viewPaddingOf(sheetContext).bottom,
          ),
          child: GlassPanel(
            key: const Key('moods_sheet'),
            child: _MoodPicker(
              onClose: () => Navigator.of(sheetContext).pop(),
            ),
          ),
        ),
      );
    },
  );
}

class _MoodPicker extends StatelessWidget {
  const _MoodPicker({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final moods = OwlExpression.moodPicker;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.55,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GlossyIconButton(
              key: const Key('moods_close'),
              icon: Icons.close_rounded,
              color: GameColors.coral,
              size: 36,
              onTap: onClose,
            ),
          ),
          const Text(
            'Pick a mood',
            style: TextStyle(
              fontFamily: AppTheme.displayFamily,
              fontSize: 22,
              color: GameColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap one — locked ones need more play',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 12,
              color: GameColors.ink.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: BlocBuilder<CrumboCubit, CrumboCharacterState>(
              builder: (context, state) {
                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisExtent: 82,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: moods.length,
                  itemBuilder: (context, index) {
                    final expression = moods[index];
                    return Center(
                      child: CareBubbleButton(
                        key: Key(actionKeyFor(expression)),
                        expression: expression,
                        selected: state.expression == expression,
                        locked: !OwlExpression.isUnlocked(expression),
                        onTap: () {
                          _onExpressionTap(context, expression);
                          if (OwlExpression.isUnlocked(expression)) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
  }) : assert(
         expression != null || (icon != null && label != null && color != null),
       );

  final OwlExpression? expression;
  final IconData? icon;
  final String? label;
  final Color? color;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlossyIconButton(
      icon: expression?.icon ?? icon!,
      label: expression?.label ?? label!,
      color: expression?.color ?? color!,
      selected: selected,
      locked: locked,
      size: 46,
      onTap: onTap,
    );
  }
}
