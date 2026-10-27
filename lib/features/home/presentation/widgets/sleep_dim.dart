import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../crumbo/domain/owl_expression.dart';
import '../../../crumbo/presentation/cubit/crumbo_cubit.dart';

/// Soft lights-out veil while the owl sleeps (taps pass through to owl).
class SleepDim extends StatelessWidget {
  const SleepDim({super.key});

  @override
  Widget build(BuildContext context) {
    final sleeping = context.select<CrumboCubit, bool>(
      (c) => c.state.expression == OwlExpression.sleep,
    );
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: sleeping ? 1 : 0,
        duration: const Duration(milliseconds: 400),
        child: const ColoredBox(
          key: Key('sleep_dim'),
          color: Color(0x66000000),
        ),
      ),
    );
  }
}
