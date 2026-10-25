import 'package:hive_ce/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/storage/settings_keys.dart';

abstract class ThemePreferences {
  Future<String?> readThemeId();
  Future<void> writeThemeId(String id);
}

/// Hive `settings` box — source of truth after A4.
class HiveThemePreferences implements ThemePreferences {
  HiveThemePreferences(this._settings);

  final Box<dynamic> _settings;

  @override
  Future<String?> readThemeId() async {
    final value = _settings.get(SettingsKeys.homeThemeId);
    return value is String ? value : null;
  }

  @override
  Future<void> writeThemeId(String id) async {
    await _settings.put(SettingsKeys.homeThemeId, id);
  }
}

/// Legacy SharedPreferences — kept for migration / tests only.
class SharedThemePreferences implements ThemePreferences {
  static const key = SettingsKeys.homeThemeId;

  @override
  Future<String?> readThemeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<void> writeThemeId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, id);
  }
}

class MemoryThemePreferences implements ThemePreferences {
  String? _id;

  @override
  Future<String?> readThemeId() async => _id;

  @override
  Future<void> writeThemeId(String id) async {
    _id = id;
  }
}
