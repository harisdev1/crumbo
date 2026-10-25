import 'package:hive_ce/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/storage/settings_keys.dart';

/// Persists selected owl skin id locally (no personal data).
abstract class SkinPreferences {
  Future<String?> readSkinId();
  Future<void> writeSkinId(String id);
}

/// Hive `settings` box — source of truth after A4.
class HiveSkinPreferences implements SkinPreferences {
  HiveSkinPreferences(this._settings);

  final Box<dynamic> _settings;

  @override
  Future<String?> readSkinId() async {
    final value = _settings.get(SettingsKeys.owlSkinId);
    return value is String ? value : null;
  }

  @override
  Future<void> writeSkinId(String id) async {
    await _settings.put(SettingsKeys.owlSkinId, id);
  }
}

/// Legacy SharedPreferences — kept for migration / tests only.
class SharedSkinPreferences implements SkinPreferences {
  static const key = SettingsKeys.owlSkinId;

  @override
  Future<String?> readSkinId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<void> writeSkinId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, id);
  }
}

class MemorySkinPreferences implements SkinPreferences {
  String? _id;

  @override
  Future<String?> readSkinId() async => _id;

  @override
  Future<void> writeSkinId(String id) async {
    _id = id;
  }
}
