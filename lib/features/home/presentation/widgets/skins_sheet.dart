import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/glossy_button.dart';
import '../../../../core/ui/glossy_icon_button.dart';
import '../../../crumbo/domain/owl_skin.dart';
import '../../../crumbo/presentation/cubit/crumbo_cubit.dart';

/// Round palette button on home that opens the Skins sheet.
class SkinsButton extends StatelessWidget {
  const SkinsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GlossyIconButton(
      key: const Key('action_skins'),
      icon: Icons.palette_rounded,
      color: const Color(0xFFFF9F43),
      size: 48,
      onTap: () => showSkinsSheet(context),
    );
  }
}

Future<void> showSkinsSheet(BuildContext context) {
  final cubit = context.read<CrumboCubit>();
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return BlocProvider.value(
        value: cubit,
        child: const _SkinsSheet(),
      );
    },
  ).whenComplete(cubit.clearSkinPreview);
}

class _SkinsSheet extends StatelessWidget {
  const _SkinsSheet();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CrumboCubit>();
    final catalog = cubit.catalogOrNull;
    final skins = catalog?.skins ?? const <OwlSkin>[];

    return Container(
      key: const Key('skins_sheet'),
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
              '${skins.length} Owl Color Themes',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: CrumboColors.crust,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            Text(
              'Same cute owl • Different vibes • Pick your favorite',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CrumboColors.detail.withValues(alpha: 0.8),
                  ),
            ),
            const SizedBox(height: 10),
            if (catalog != null) _SelectedPreview(catalog: catalog),
            const SizedBox(height: 10),
            Expanded(
              child: skins.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      key: const Key('skins_grid'),
                      itemCount: skins.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.78,
                      ),
                      itemBuilder: (context, index) {
                        final skin = skins[index];
                        return BlocBuilder<CrumboCubit, CrumboCharacterState>(
                          buildWhen: (p, n) =>
                              p.activeSkinId != n.activeSkinId ||
                              p.skinId != n.skinId,
                          builder: (context, state) => _SkinCard(
                            skin: skin,
                            number: index + 1,
                            selected: state.activeSkinId == skin.id,
                            applied: state.skinId == skin.id,
                            onTap: () => context
                                .read<CrumboCubit>()
                                .previewSkin(skin.id),
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

/// Big preview of the currently picked skin (real pack owl render).
class _SelectedPreview extends StatelessWidget {
  const _SelectedPreview({required this.catalog});

  final OwlSkinCatalog catalog;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrumboCubit, CrumboCharacterState>(
      buildWhen: (p, n) => p.activeSkinId != n.activeSkinId,
      builder: (context, state) {
        final skin = catalog.byId(state.activeSkinId);
        return AnimatedContainer(
          key: const Key('skins_selected_preview'),
          duration: const Duration(milliseconds: 220),
          height: 150,
          decoration: BoxDecoration(
            color: skin.cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Image.asset(skin.thumbnailPath, width: 130, height: 130),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${catalog.numberOf(skin)}. ${skin.name}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: CrumboColors.detail,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    _PaletteDots(colors: skin.paletteDots, size: 16),
                  ],
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
    return BlocBuilder<CrumboCubit, CrumboCharacterState>(
      builder: (context, state) {
        final activeId = state.activeSkinId;
        final already = state.skinId == activeId;
        return GlossyButton(
          key: const Key('skins_apply_button'),
          label: already ? 'Looking good!' : 'Use this',
          expand: true,
          onPressed: () {
            if (!already) {
              context.read<CrumboCubit>().applySkin(activeId);
            }
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class _SkinCard extends StatelessWidget {
  const _SkinCard({
    required this.skin,
    required this.number,
    required this.selected,
    required this.applied,
    required this.onTap,
  });

  final OwlSkin skin;
  final int number;
  final bool selected;
  final bool applied;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('skin_${skin.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: skin.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? CrumboColors.crust : Colors.white,
              width: selected ? 3 : 2,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
                child: Column(
                  children: [
                    Expanded(child: Image.asset(skin.thumbnailPath)),
                    const SizedBox(height: 4),
                    Text(
                      '$number. ${skin.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: CrumboColors.detail,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    _PaletteDots(colors: skin.paletteDots, size: 9),
                  ],
                ),
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

class _PaletteDots extends StatelessWidget {
  const _PaletteDots({required this.colors, required this.size});

  final List<Color> colors;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final color in colors)
          Container(
            width: size,
            height: size,
            margin: EdgeInsets.symmetric(horizontal: size * 0.2),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.2),
            ),
          ),
      ],
    );
  }
}
