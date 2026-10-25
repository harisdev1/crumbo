import 'package:get_it/get_it.dart';

import '../../features/crumbo/data/skin_preferences.dart';
import '../../features/home/data/theme_preferences.dart';
import '../storage/hive_boxes.dart';
import '../storage/hive_storage.dart';

final GetIt getIt = GetIt.instance;

/// Registers app-wide dependencies. Call once from [main] before [runApp].
///
/// Pass [hivePath] in tests so Hive does not need path_provider plugins.
Future<void> configureDependencies({String? hivePath}) async {
  final boxes = await HiveStorage.init(hivePath: hivePath);
  getIt.registerSingleton<HiveBoxes>(boxes);
  getIt.registerSingleton<SkinPreferences>(
    HiveSkinPreferences(boxes.settings),
  );
  getIt.registerSingleton<ThemePreferences>(
    HiveThemePreferences(boxes.settings),
  );
}
