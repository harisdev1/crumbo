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
  const HomePage({super.key, this.character});

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
                        // "Tap me!" / mood status line hidden for now.
                        // const _StatusBubble(),
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

/// Sizes the owl without a painted circle, so the SVG background shows through.
class _OwlStage extends StatelessWidget {
  const _OwlStage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.biggest.shortestSide;
        final diameter = (side * 0.98).clamp(300.0, 560.0);
        final placement = context
            .select<HomeThemeCubit, ({double offsetY, double scale})>(
              (cubit) => (
                offsetY: cubit.activeTheme.owlOffsetY,
                scale: cubit.activeTheme.owlScale,
              ),
            );
        final drop = MediaQuery.sizeOf(context).height * placement.offsetY;
        return Center(
          child: SizedBox(
            key: const Key('owl_stage'),
            width: diameter,
            height: diameter,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOutCubic,
              tween: Tween(end: drop),
              builder: (context, animatedDrop, translatedChild) {
                return Transform.translate(
                  key: const Key('owl_theme_offset'),
                  offset: Offset(0, animatedDrop),
                  transformHitTests: true,
                  child: translatedChild,
                );
              },
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOutCubic,
                tween: Tween(end: placement.scale),
                builder: (context, scale, scaledChild) {
                  return Transform.scale(
                    key: const Key('owl_theme_scale'),
                    scale: scale,
                    child: scaledChild,
                  );
                },
                child: child,
              ),
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
    final dark = context.select<HomeThemeCubit, bool>(
      (c) => c.activeTheme.isDark,
    );
    final base = Theme.of(context).textTheme;
    return Column(
      children: [
        // "A cute little owl with big feelings." hidden for now.
        // Text(HomePage.tagline, key: Key('home_tagline')),
        AnimatedDefaultTextStyle(
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
        ),
      ],
    );
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
