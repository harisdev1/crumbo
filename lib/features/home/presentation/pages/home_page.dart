import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../crumbo/presentation/cubit/crumbo_cubit.dart';
import '../../../crumbo/presentation/widgets/crumbo_view.dart';
import '../cubit/home_theme_cubit.dart';
import '../widgets/care_action_bar.dart';
import '../widgets/exit_dialog.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/owl_perch_layer.dart';
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        showExitDialog(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF9FD6FF),
        body: Stack(
          fit: StackFit.expand,
          children: [
            const ThemedBackground(key: Key('home_background')),
            OwlPerchLayer(child: character ?? const CrumboView()),
            SafeArea(
              child: Column(
                children: [
                  const HomeTopBar(),
                  const SizedBox(height: 6),
                  const _TitleRow(),
                  // Let taps reach the owl below; only [OwlBodyTapShell] handles bonks.
                  const Expanded(child: SizedBox.shrink()),
                  // "Tap me!" / mood status line hidden for now.
                  // _StatusBubble(),
                  const _ThemedCaptions(),
                  const SizedBox(height: 8),
                  const CareActionBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          ThemesButton(),
          Expanded(child: SizedBox.shrink()),
          // Center "Owl" title pill hidden for now.
          // Expanded(child: Center(child: _BubbleTitle())),
          SkinsButton(),
        ],
      ),
    );
  }
}

// Center "Owl" title pill hidden for now.
/*
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
        style: const TextStyle(
          fontFamily: AppTheme.displayFamily,
          fontSize: 28,
          color: GameColors.ink,
        ),
      ),
    );
  }
}
*/

/// Tagline + credit; colors animate with the background theme.
class _ThemedCaptions extends StatelessWidget {
  const _ThemedCaptions();

  @override
  Widget build(BuildContext context) {
    // "A cute little owl with big feelings." hidden for now.
    // Text(HomePage.tagline, key: Key('home_tagline')),
    // Owl art credit hidden for now.
    /*
    final dark = context.select<HomeThemeCubit, bool>(
      (c) => c.activeTheme.isDark,
    );
    final base = Theme.of(context).textTheme;
    return AnimatedDefaultTextStyle(
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
    );
    */
    return const SizedBox.shrink();
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
