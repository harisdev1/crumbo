import 'package:flutter/material.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../../core/ui/glossy_button.dart';

class _Link {
  const _Link(this.label, this.route, this.keyName);
  final String label;
  final String route;
  final String keyName;
}

const _links = <_Link>[
  _Link('Shop', AppRoutes.shop, 'link_shop'),
  _Link('Profile', AppRoutes.profile, 'link_profile'),
  _Link('Achievements', AppRoutes.achievements, 'link_achievements'),
  _Link('Best Scores', AppRoutes.scores, 'link_scores'),
  _Link('Daily Rewards', AppRoutes.daily, 'link_daily'),
  _Link('Food', AppRoutes.food, 'link_food'),
  _Link('Market', AppRoutes.market, 'link_market'),
  _Link('Theme Shop', AppRoutes.themeShop, 'link_theme_shop'),
  _Link('My Owls', AppRoutes.myOwls, 'link_owls'),
  _Link('Coloring', AppRoutes.coloring, 'link_coloring'),
  _Link('Get Coins', AppRoutes.store, 'link_store'),
];

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _sound = true;
  var _music = true;
  var _vibration = true;
  var _notifications = true;

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('settings_page'),
      title: 'Settings',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        children: [
          _toggle('Sound', _sound, 'toggle_sound', (v) {
            setState(() => _sound = v);
          }),
          _toggle('Music', _music, 'toggle_music', (v) {
            setState(() => _music = v);
          }),
          _toggle('Vibration', _vibration, 'toggle_vibration', (v) {
            setState(() => _vibration = v);
          }),
          _toggle('Notifications', _notifications, 'toggle_notifications', (v) {
            setState(() => _notifications = v);
          }),
          const SizedBox(height: 8),
          GlossyButton(
            key: const Key('open_level_up'),
            label: 'Level Up',
            expand: true,
            icon: Icons.star_rounded,
            color: GameColors.coin,
            onPressed: () => pushAppRoute(context, AppRoutes.levelUp),
          ),
          const SizedBox(height: 10),
          for (final link in _links) ...[
            GlossyButton(
              key: Key(link.keyName),
              label: link.label,
              expand: true,
              onPressed: () => pushAppRoute(context, link.route),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _toggle(
    String label,
    bool value,
    String keyName,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      key: Key(keyName),
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: AppTheme.displayFamily,
          color: GameColors.ink,
          fontSize: 18,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
