import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'hive_boxes.dart';
import 'settings_keys.dart';

/// Opens the four app boxes and migrates theme/skin prefs once from SP.
class HiveStorage {
  HiveStorage._();

  /// [hivePath] skips Flutter path_provider (use in unit/widget tests).
  static Future<HiveBoxes> init({
    SharedPreferences? sharedPreferences,
    String? hivePath,
  }) async {
    if (hivePath != null) {
      Hive.init(hivePath);
    } else {
      await Hive.initFlutter();
    }
    return openBoxes(sharedPreferences: sharedPreferences);
  }

  /// Opens boxes after [Hive.init] / [Hive.initFlutter]. Used by tests with a temp path.
  static Future<HiveBoxes> openBoxes({
    SharedPreferences? sharedPreferences,
  }) async {
    final crumboState = await Hive.openBox<dynamic>(HiveBoxNames.crumboState);
    final inventory = await Hive.openBox<dynamic>(HiveBoxNames.inventory);
    final economy = await Hive.openBox<dynamic>(HiveBoxNames.economy);
    final settings = await Hive.openBox<dynamic>(HiveBoxNames.settings);

    final boxes = HiveBoxes(
      crumboState: crumboState,
      inventory: inventory,
      economy: economy,
      settings: settings,
    );

    await migrateSharedPreferencesOnce(
      boxes.settings,
      sharedPreferences: sharedPreferences,
    );

    return boxes;
  }

  /// One-shot copy of legacy SharedPreferences theme/skin into settings.
  static Future<void> migrateSharedPreferencesOnce(
    Box<dynamic> settings, {
    SharedPreferences? sharedPreferences,
  }) async {
    if (settings.get(SettingsKeys.prefsMigratedV1) == true) return;

    final prefs = sharedPreferences ?? await SharedPreferences.getInstance();

    final skin = prefs.getString(SettingsKeys.owlSkinId);
    if (skin != null &&
        skin.isNotEmpty &&
        settings.get(SettingsKeys.owlSkinId) == null) {
      await settings.put(SettingsKeys.owlSkinId, skin);
    }

    final theme = prefs.getString(SettingsKeys.homeThemeId);
    if (theme != null &&
        theme.isNotEmpty &&
        settings.get(SettingsKeys.homeThemeId) == null) {
      await settings.put(SettingsKeys.homeThemeId, theme);
    }

    await settings.put(SettingsKeys.prefsMigratedV1, true);
  }
}
