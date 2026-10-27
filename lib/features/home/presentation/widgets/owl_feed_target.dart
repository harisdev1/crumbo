import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../cards/data/task_progress_store.dart';
import '../../../crumbo/domain/need_kind.dart';
import '../../../crumbo/domain/owl_expression.dart';
import '../../../crumbo/presentation/cubit/crumbo_cubit.dart';
import '../../../crumbo/presentation/cubit/needs_cubit.dart';
import '../../domain/bath_item.dart';
import '../../domain/food_item.dart';

void _recordTask(String key) {
  final gi = GetIt.instance;
  if (!gi.isRegistered<TaskProgressStore>()) return;
  gi.get<TaskProgressStore>().add(key, 1);
}

/// Accepts dragged food or bath tool ids onto the owl stage.
class OwlFeedTarget extends StatelessWidget {
  const OwlFeedTarget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      key: const Key('owl_feed_target'),
      onWillAcceptWithDetails: (details) =>
          FoodItem.tray.any((f) => f.id == details.data) ||
          BathItem.isBathTool(details.data),
      onAcceptWithDetails: (details) {
        HapticFeedback.lightImpact();
        final id = details.data;
        if (BathItem.isBathTool(id)) {
          context.read<CrumboCubit>().setExpression(OwlExpression.bath);
          context.read<NeedsCubit>().boost(
                NeedKind.clean,
                BathItem.cleanBoost,
              );
          context.read<NeedsCubit>().boost(NeedKind.fun, BathItem.funBoost);
          _recordTask('bath');
          return;
        }
        context.read<CrumboCubit>().setExpression(OwlExpression.eat);
        context.read<NeedsCubit>().boost(NeedKind.hunger, FoodItem.hungerBoost);
        _recordTask('feed');
      },
      builder: (context, candidate, rejected) {
        final hovering = candidate.isNotEmpty;
        final bathHover = candidate.any(
          (id) => id != null && BathItem.isBathTool(id),
        );
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: hovering
                ? Border.all(color: Colors.white, width: 4)
                : null,
            boxShadow: hovering
                ? [
                    BoxShadow(
                      color: (bathHover
                              ? const Color(0xFF4FC3F7)
                              : const Color(0xFFFFC107))
                          .withValues(alpha: 0.45),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: child,
        );
      },
    );
  }
}
