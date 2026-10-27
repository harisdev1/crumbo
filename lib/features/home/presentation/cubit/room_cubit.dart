import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/di/injection.dart';
import '../../data/room_preferences.dart';
import '../../domain/home_room.dart';
import 'home_theme_cubit.dart';

class RoomCubit extends Cubit<HomeRoom> {
  RoomCubit({
    RoomPreferences? preferences,
    HomeThemeCubit? themeCubit,
  })  : _preferences = preferences ?? _defaultPreferences(),
        _themeCubit = themeCubit,
        super(HomeRoom.defaultRoom);

  static RoomPreferences _defaultPreferences() {
    if (GetIt.instance.isRegistered<RoomPreferences>()) {
      return getIt<RoomPreferences>();
    }
    return MemoryRoomPreferences();
  }

  final RoomPreferences _preferences;
  HomeThemeCubit? _themeCubit;

  /// Attach theme cubit after both are created (same home tree).
  void bindThemeCubit(HomeThemeCubit themeCubit) {
    _themeCubit = themeCubit;
  }

  Future<void> hydrate() async {
    final saved = await _preferences.readRoom();
    final room = saved ?? HomeRoom.defaultRoom;
    if (!isClosed) emit(room);
  }

  Future<void> goTo(HomeRoom room) async {
    if (state == room) return;
    emit(room);
    await _preferences.writeRoom(room);
    final theme = _themeCubit;
    if (theme != null) {
      await theme.applyTheme(room.defaultThemeId);
    }
  }
}
