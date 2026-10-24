import 'package:shared_preferences/shared_preferences.dart';

/// Persists selected owl skin id locally (no personal data).
abstract class SkinPreferences {
  Future<String?> readSkinId();
  Future<void> writeSkinId(String id);
}

class SharedSkinPreferences implements SkinPreferences {
  static const key = 'owl_skin_id';

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
