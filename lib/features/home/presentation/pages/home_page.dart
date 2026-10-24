import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../crumbo/presentation/cubit/crumbo_cubit.dart';
import '../../../crumbo/presentation/widgets/crumbo_view.dart';
import '../widgets/care_action_bar.dart';
import '../cubit/home_theme_cubit.dart';
import '../widgets/skins_sheet.dart';
import '../widgets/themed_background.dart';
import '../widgets/themes_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    this.character,
  });

  static const tagline = 'A cute little owl with big feelings.';

  /// Override for widget tests (avoids loading `rive_native` in CI/desktop).
  final Widget? character;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CrumboCubit()..hydrate()),
        BlocProvider(create: (_) => HomeThemeCubit()..hydrate()),
      ],
      child: _HomeBody(character: character),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({this.character});

  final Widget? character;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9FD6FF),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ThemedBackground(key: Key('home_background')),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const _BubbleTitle(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Column(
                      children: [
                        Expanded(
                          child: _OwlStage(
                            child: character ?? const CrumboView(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const _StatusBubble(),
                        const SizedBox(height: 6),
                        const _ThemedCaptions(),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                const CareActionBar(),
              ],
            ),
          ),
          const SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 16, 0),
                child: SkinsButton(),
              ),
            ),
          ),
          const SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                child: ThemesButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 26,
              color: CrumboColors.crust,
            ),
      ),
    );
  }
}

/// Wide soft stage so the owl is the hero of the screen.
class _OwlStage extends StatelessWidget {
  const _OwlStage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use almost full stage so the owl reads large on phone.
        final side = constraints.biggest.shortestSide;
        final diameter = (side * 0.98).clamp(300.0, 560.0);
        final stage = context.select<HomeThemeCubit, Color>(
          (c) => c.activeTheme.stageColor,
        );
        return Center(
          child: AnimatedContainer(
            key: const Key('owl_stage'),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.lerp(stage, Colors.white, 0.35)!.withValues(alpha: 0.92),
                  stage.withValues(alpha: 0.88),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7EB8DA).withValues(alpha: 0.4),
                  blurRadius: 28,
                  spreadRadius: 4,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Tagline + credit; colors animate with the background theme.
class _ThemedCaptions extends StatelessWidget {
  const _ThemedCaptions();

  @override
  Widget build(BuildContext context) {
    final theme = context.select<HomeThemeCubit, ({Color tagline, bool dark})>(
      (c) => (tagline: c.activeTheme.taglineColor, dark: c.activeTheme.isDark),
    );
    final base = Theme.of(context).textTheme;
    return Column(
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 700),
          style: (base.bodySmall ?? const TextStyle()).copyWith(
            color: theme.tagline,
            fontStyle: FontStyle.italic,
          ),
          child: const Text(
            HomePage.tagline,
            key: Key('home_tagline'),
            textAlign: TextAlign.center,
          ),
        ),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 700),
          style: (base.labelSmall ?? const TextStyle()).copyWith(
            color: theme.dark
                ? Colors.white.withValues(alpha: 0.7)
                : CrumboColors.detail.withValues(alpha: 0.65),
            fontSize: 10,
          ),
          child: const Text(
            'Owl art © AnggaMotion (CC BY)',
            key: Key('owl_attribution'),
          ),
        ),
      ],
    );
  }
}

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
