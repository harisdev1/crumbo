import 'package:hive_ce/hive.dart';

import '../../../core/storage/settings_keys.dart';
import '../domain/home_room.dart';

abstract class RoomPreferences {
  Future<HomeRoom?> readRoom();
  Future<void> writeRoom(HomeRoom room);
}

class HiveRoomPreferences implements RoomPreferences {
  HiveRoomPreferences(this._settings);

  final Box<dynamic> _settings;

  @override
  Future<HomeRoom?> readRoom() async {
    final value = _settings.get(SettingsKeys.homeRoom);
    if (value is! String) return null;
    return HomeRoom.fromId(value);
  }

  @override
  Future<void> writeRoom(HomeRoom room) async {
    await _settings.put(SettingsKeys.homeRoom, room.id);
  }
}

class MemoryRoomPreferences implements RoomPreferences {
  HomeRoom? _room;

  @override
  Future<HomeRoom?> readRoom() async => _room;

  @override
  Future<void> writeRoom(HomeRoom room) async {
    _room = room;
  }
}
