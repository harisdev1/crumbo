import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../../core/ui/glossy_button.dart';
import '../../home/domain/home_theme.dart';
import '../../home/presentation/cubit/home_theme_cubit.dart';

class ThemeShopPage extends StatefulWidget {
  const ThemeShopPage({super.key});

  @override
  State<ThemeShopPage> createState() => _ThemeShopPageState();
}

class _ThemeShopPageState extends State<ThemeShopPage> {
  String _selected = HomeTheme.morningGlowId;

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('theme_shop_page'),
      title: 'Themes',
      body: FutureBuilder<HomeThemeCatalog>(
        future: HomeThemeCatalog.load(),
        builder: (context, snap) {
          final catalog = snap.data;
          if (catalog == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final theme = catalog.byId(_selected);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 140,
                    width: double.infinity,
                    child: SvgPicture.asset(theme.svg, fit: BoxFit.cover),
                  ),
                ),
              ),
              Text(
                theme.name,
                style: const TextStyle(
                  fontFamily: AppTheme.displayFamily,
                  fontSize: 20,
                  color: GameColors.ink,
                ),
              ),
              const Text('Free'),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: catalog.themes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final item = catalog.themes[index];
                    return GestureDetector(
                      key: Key('theme_shop_${item.id}'),
                      onTap: () => setState(() => _selected = item.id),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SvgPicture.asset(item.svg, fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: GlossyButton(
                  key: const Key('theme_shop_apply'),
                  label: 'Apply',
                  expand: true,
                  color: GameColors.green,
                  onPressed: () => _apply(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _apply(BuildContext context) {
    try {
      context.read<HomeThemeCubit>().applyTheme(_selected);
    } catch (_) {
      // Preview still shows the scene when opened without the home cubit.
    }
  }
}
