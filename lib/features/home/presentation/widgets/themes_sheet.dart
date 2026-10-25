import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/home_theme.dart';
import '../cubit/home_theme_cubit.dart';

/// Round landscape button that opens the Themes sheet.
class ThemesButton extends StatelessWidget {
  const ThemesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: CrumboColors.crust.withValues(alpha: 0.3),
      child: InkWell(
        key: const Key('action_themes'),
        customBorder: const CircleBorder(),
        onTap: () => showThemesSheet(context),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(
            Icons.landscape_rounded,
            color: Color(0xFF42A5F5),
            size: 28,
          ),
        ),
      ),
    );
  }
}

Future<void> showThemesSheet(BuildContext context) {
  final cubit = context.read<HomeThemeCubit>();
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return BlocProvider.value(
        value: cubit,
        child: const _ThemesSheet(),
      );
    },
  ).whenComplete(cubit.clearThemePreview);
}

class _ThemesSheet extends StatelessWidget {
  const _ThemesSheet();

  @override
  Widget build(BuildContext context) {
    final catalog = context.select<HomeThemeCubit, HomeThemeCatalog?>(
      (c) => c.catalogOrNull,
    );
    final themes = catalog?.themes ?? const <HomeTheme>[];

    return Container(
      key: const Key('themes_sheet'),
      height: MediaQuery.sizeOf(context).height * 0.86,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 12),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: CrumboColors.detail.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Text(
              '${themes.length} Background Themes',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: CrumboColors.crust,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            Text(
              'Tap to preview • Use this to keep it',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CrumboColors.detail.withValues(alpha: 0.8),
                  ),
            ),
            const SizedBox(height: 10),
            if (catalog != null) _SelectedPreview(catalog: catalog),
            const SizedBox(height: 10),
            Expanded(
              child: themes.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      key: const Key('themes_grid'),
                      itemCount: themes.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, index) {
                        final theme = themes[index];
                        return BlocBuilder<HomeThemeCubit, HomeThemeState>(
                          buildWhen: (p, n) =>
                              p.activeThemeId != n.activeThemeId ||
                              p.themeId != n.themeId,
                          builder: (context, state) => _ThemeCard(
                            theme: theme,
                            selected: state.activeThemeId == theme.id,
                            applied: state.themeId == theme.id,
                            onTap: () => context
                                .read<HomeThemeCubit>()
                                .previewTheme(theme.id),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 10),
            const _ApplyButton(),
          ],
        ),
      ),
    );
  }
}

class _SelectedPreview extends StatelessWidget {
  const _SelectedPreview({required this.catalog});

  final HomeThemeCatalog catalog;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeThemeCubit, HomeThemeState>(
      buildWhen: (p, n) => p.activeThemeId != n.activeThemeId,
      builder: (context, state) {
        final theme = catalog.byId(state.activeThemeId);
        return AnimatedContainer(
          key: const Key('themes_selected_preview'),
          duration: const Duration(milliseconds: 220),
          height: 140,
          decoration: BoxDecoration(
            color: theme.stageColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white, width: 3),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              SizedBox(
                width: 110,
                height: 140,
                child: SvgPicture.asset(theme.svg, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  theme.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: theme.isDark ? Colors.white : CrumboColors.detail,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ApplyButton extends StatelessWidget {
  const _ApplyButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeThemeCubit, HomeThemeState>(
      builder: (context, state) {
        final activeId = state.activeThemeId;
        final already = state.themeId == activeId;
        return FilledButton(
          key: const Key('themes_apply_button'),
          onPressed: () async {
            if (!already) {
              await context.read<HomeThemeCubit>().applyTheme(activeId);
            }
            if (context.mounted) Navigator.of(context).pop();
          },
          style: FilledButton.styleFrom(
            backgroundColor: CrumboColors.crust,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Text(already ? 'Looking good!' : 'Use this'),
        );
      },
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.theme,
    required this.selected,
    required this.applied,
    required this.onTap,
  });

  final HomeTheme theme;
  final bool selected;
  final bool applied;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('theme_${theme.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: theme.stageColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? CrumboColors.crust : Colors.white,
              width: selected ? 3 : 2,
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: SvgPicture.asset(theme.svg, fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
                    child: Text(
                      theme.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: theme.isDark
                                ? Colors.white
                                : CrumboColors.detail,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
              if (applied)
                const Positioned(
                  top: 6,
                  right: 6,
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: CrumboColors.crust,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
