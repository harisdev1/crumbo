import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemePreferences {
  Future<String?> readThemeId();
  Future<void> writeThemeId(String id);
}

class SharedThemePreferences implements ThemePreferences {
  static const key = 'home_theme_id';

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
