import 'dart:io';

import 'package:crumbo/core/di/injection.dart';
import 'package:crumbo/features/cards/data/cards_collection_repository.dart';
import 'package:crumbo/features/cards/data/task_progress_store.dart';
import 'package:crumbo/features/crumbo/data/needs_repository.dart';
import 'package:crumbo/features/crumbo/data/skin_preferences.dart';
import 'package:crumbo/features/economy/data/economy_repository.dart';
import 'package:crumbo/features/home/data/room_preferences.dart';
import 'package:crumbo/features/home/data/theme_preferences.dart';
import 'package:crumbo/features/journey/data/journey_repository.dart';
import 'package:crumbo/features/rewards/data/daily_reward_repository.dart';
import 'package:crumbo/features/shop/data/inventory_repository.dart';
import 'package:hive_ce/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// In-memory prefs only — safe for parallel widget tests (no global Hive).
Future<void> configureMemoryPreferences() async {
  SharedPreferences.setMockInitialValues({});
  await getIt.reset();
  getIt.registerSingleton<SkinPreferences>(MemorySkinPreferences());
  getIt.registerSingleton<ThemePreferences>(MemoryThemePreferences());
  getIt.registerSingleton<RoomPreferences>(MemoryRoomPreferences());
  getIt.registerSingleton<NeedsRepository>(MemoryNeedsRepository());
  getIt.registerSingleton<EconomyRepository>(MemoryEconomyRepository());
  getIt.registerSingleton<InventoryRepository>(MemoryInventoryRepository());
  getIt.registerSingleton<DailyRewardRepository>(
    MemoryDailyRewardRepository(),
  );
  getIt.registerSingleton<CardsCollectionRepository>(
    MemoryCardsCollectionRepository(),
  );
  getIt.registerSingleton<TaskProgressStore>(MemoryTaskProgressStore());
  getIt.registerSingleton<JourneyRepository>(MemoryJourneyRepository());
}

/// Full Hive DI on a temp path. Prefer `--concurrency=1` or serial use only.
Future<Directory> configureTestDependencies() async {
  SharedPreferences.setMockInitialValues({});
  await getIt.reset();
  await Hive.close();
  final dir = await Directory.systemTemp.createTemp('crumbo_hive_test_');
  await configureDependencies(hivePath: dir.path);
  return dir;
}

Future<void> tearDownTestHive(Directory dir) async {
  await getIt.reset();
  await Hive.close();
  if (dir.existsSync()) {
    await dir.delete(recursive: true);
  }
}
