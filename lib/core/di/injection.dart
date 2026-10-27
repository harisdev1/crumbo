import 'package:get_it/get_it.dart';

import '../../features/cards/data/cards_collection_repository.dart';
import '../../features/cards/data/task_progress_store.dart';
import '../../features/crumbo/data/needs_repository.dart';
import '../../features/crumbo/data/skin_preferences.dart';
import '../../features/economy/data/economy_repository.dart';
import '../../features/home/data/room_preferences.dart';
import '../../features/home/data/theme_preferences.dart';
import '../../features/journey/data/journey_repository.dart';
import '../../features/rewards/data/daily_reward_repository.dart';
import '../../features/shop/data/inventory_repository.dart';
import '../../features/voice/data/just_audio_voice_player.dart';
import '../../features/voice/data/record_voice_recorder.dart';
import '../../features/voice/data/voice_preset_store.dart';
import '../../features/voice/domain/voice_player.dart';
import '../../features/voice/domain/voice_recorder.dart';
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
  getIt.registerSingleton<RoomPreferences>(
    HiveRoomPreferences(boxes.settings),
  );
  getIt.registerSingleton<NeedsRepository>(
    HiveNeedsRepository(boxes.crumboState),
  );
  getIt.registerSingleton<EconomyRepository>(
    HiveEconomyRepository(boxes.economy),
  );
  getIt.registerSingleton<InventoryRepository>(
    HiveInventoryRepository(boxes.inventory),
  );
  getIt.registerSingleton<DailyRewardRepository>(
    HiveDailyRewardRepository(boxes.settings),
  );
  getIt.registerSingleton<CardsCollectionRepository>(
    HiveCardsCollectionRepository(boxes.inventory),
  );
  getIt.registerSingleton<TaskProgressStore>(
    HiveTaskProgressStore(boxes.settings),
  );
  getIt.registerSingleton<JourneyRepository>(
    HiveJourneyRepository(boxes.crumboState),
  );
  getIt.registerLazySingleton<VoiceRecorder>(RecordVoiceRecorder.new);
  getIt.registerLazySingleton<VoicePlayer>(JustAudioVoicePlayer.new);
  getIt.registerLazySingleton<VoicePresetStore>(
    () => HiveVoicePresetStore(boxes.settings),
  );
}
