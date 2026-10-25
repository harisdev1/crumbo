import 'dart:io';

import 'package:crumbo/core/storage/hive_boxes.dart';
import 'package:crumbo/core/storage/hive_storage.dart';
import 'package:crumbo/core/storage/settings_keys.dart';
import 'package:crumbo/features/crumbo/data/skin_preferences.dart';
import 'package:crumbo/features/home/data/theme_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('crumbo_hive_');
    Hive.init(tempDir.path);
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('openBoxes creates four named boxes', () async {
    final boxes = await HiveStorage.openBoxes(
      sharedPreferences: await SharedPreferences.getInstance(),
    );

    expect(boxes.crumboState.name, HiveBoxNames.crumboState);
    expect(boxes.inventory.name, HiveBoxNames.inventory);
    expect(boxes.economy.name, HiveBoxNames.economy);
    expect(boxes.settings.name, HiveBoxNames.settings);
    expect(boxes.crumboState.isEmpty, isTrue);
    expect(boxes.inventory.isEmpty, isTrue);
    expect(boxes.economy.isEmpty, isTrue);
  });

  test('settings put/get round-trips skin and theme', () async {
    final boxes = await HiveStorage.openBoxes(
      sharedPreferences: await SharedPreferences.getInstance(),
    );
    final skin = HiveSkinPreferences(boxes.settings);
    final theme = HiveThemePreferences(boxes.settings);

    await skin.writeSkinId('mint_green');
    await theme.writeThemeId('sleepy_night');

    expect(await skin.readSkinId(), 'mint_green');
    expect(await theme.readThemeId(), 'sleepy_night');
    expect(boxes.settings.get(SettingsKeys.owlSkinId), 'mint_green');
    expect(boxes.settings.get(SettingsKeys.homeThemeId), 'sleepy_night');
  });

  test('migrate copies SharedPreferences once into settings', () async {
    SharedPreferences.setMockInitialValues({
      SettingsKeys.owlSkinId: 'forest_green',
      SettingsKeys.homeThemeId: 'rainbow_meadow',
    });
    final prefs = await SharedPreferences.getInstance();

    final boxes = await HiveStorage.openBoxes(sharedPreferences: prefs);

    expect(boxes.settings.get(SettingsKeys.owlSkinId), 'forest_green');
    expect(boxes.settings.get(SettingsKeys.homeThemeId), 'rainbow_meadow');
    expect(boxes.settings.get(SettingsKeys.prefsMigratedV1), isTrue);

    await prefs.setString(SettingsKeys.owlSkinId, 'should_not_overwrite');
    await HiveStorage.migrateSharedPreferencesOnce(
      boxes.settings,
      sharedPreferences: prefs,
    );
    expect(boxes.settings.get(SettingsKeys.owlSkinId), 'forest_green');
  });

  test('migrate does not overwrite existing Hive values', () async {
    SharedPreferences.setMockInitialValues({
      SettingsKeys.owlSkinId: 'from_sp',
    });
    final prefs = await SharedPreferences.getInstance();
    final settings = await Hive.openBox<dynamic>(HiveBoxNames.settings);
    await settings.put(SettingsKeys.owlSkinId, 'already_hive');

    await HiveStorage.migrateSharedPreferencesOnce(
      settings,
      sharedPreferences: prefs,
    );

    expect(settings.get(SettingsKeys.owlSkinId), 'already_hive');
    expect(settings.get(SettingsKeys.prefsMigratedV1), isTrue);
  });
}
