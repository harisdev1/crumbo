import 'package:flutter/material.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/currency_pill.dart';
import '../../../../core/ui/glass_panel.dart';
import '../../../../core/ui/glossy_icon_button.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
      child: Row(
        children: [
          const CurrencyPill(
            key: Key('coin_pill'),
            kind: CurrencyKind.coin,
            amount: 0,
          ),
          const SizedBox(width: 8),
          const CurrencyPill(
            key: Key('gem_pill'),
            kind: CurrencyKind.gem,
            amount: 0,
          ),
          const Spacer(),
          GlossyIconButton(
            key: const Key('action_nav'),
            icon: Icons.grid_view_rounded,
            color: GameColors.purple,
            size: 44,
            onTap: () => showHomeNav(context),
          ),
          const SizedBox(width: 8),
          GlossyIconButton(
            key: const Key('action_settings'),
            icon: Icons.settings_rounded,
            color: const Color(0xFF5C6BC0),
            size: 44,
            onTap: () => pushAppRoute(context, AppRoutes.settings),
          ),
        ],
      ),
    );
  }
}

class _NavLink {
  const _NavLink(this.route, this.label, this.icon, this.keyName);

  final String route;
  final String label;
  final IconData icon;
  final String keyName;
}

const _links = <_NavLink>[
  _NavLink(AppRoutes.shop, 'Shop', Icons.storefront_rounded, 'nav_shop'),
  _NavLink(AppRoutes.profile, 'Player', Icons.person_rounded, 'nav_profile'),
  _NavLink(
    AppRoutes.achievements,
    'Awards',
    Icons.emoji_events_rounded,
    'nav_achievements',
  ),
  _NavLink(AppRoutes.scores, 'Scores', Icons.leaderboard_rounded, 'nav_scores'),
  _NavLink(AppRoutes.daily, 'Daily', Icons.calendar_month_rounded, 'nav_daily'),
  _NavLink(AppRoutes.food, 'Food', Icons.restaurant_rounded, 'nav_food'),
  _NavLink(AppRoutes.market, 'Market', Icons.checkroom_rounded, 'nav_market'),
  _NavLink(
    AppRoutes.themeShop,
    'Themes',
    Icons.landscape_rounded,
    'nav_themes',
  ),
  _NavLink(AppRoutes.myOwls, 'Owls', Icons.pets_rounded, 'nav_owls'),
  _NavLink(AppRoutes.coloring, 'Color', Icons.palette_rounded, 'nav_coloring'),
  _NavLink(AppRoutes.store, 'Coins', Icons.monetization_on_rounded, 'nav_store'),
];

Future<void> showHomeNav(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: GlassPanel(
          key: const Key('nav_sheet'),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.72,
            children: [
              for (final link in _links)
                GlossyIconButton(
                  key: Key(link.keyName),
                  icon: link.icon,
                  label: link.label,
                  color: GameColors.purple,
                  size: 46,
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    pushAppRoute(context, link.route);
                  },
                ),
            ],
          ),
        ),
      );
    },
  );
}
