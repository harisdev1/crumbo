import 'package:crumbo/features/home/data/room_preferences.dart';
import 'package:crumbo/features/home/domain/home_room.dart';
import 'package:crumbo/features/home/presentation/cubit/home_theme_cubit.dart';
import 'package:crumbo/features/home/presentation/cubit/room_cubit.dart';
import 'package:crumbo/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/hive_test_setup.dart';

void main() {
  setUp(() async {
    await configureMemoryPreferences();
  });

  test('room maps to default theme ids', () {
    expect(HomeRoom.kitchen.defaultThemeId, 'morning_glow');
    expect(HomeRoom.bedroom.defaultThemeId, 'sleepy_night');
    expect(HomeRoom.bathroom.defaultThemeId, 'playful_bubbles');
    expect(HomeRoom.kitchen.showsFoodTray, isTrue);
    expect(HomeRoom.kitchen.showsBathTray, isFalse);
    expect(HomeRoom.bathroom.showsBathTray, isTrue);
    expect(HomeRoom.bedroom.showsFoodTray, isFalse);
    expect(HomeRoom.bedroom.showsBathTray, isFalse);
  });

  test('fromId falls back to kitchen', () {
    expect(HomeRoom.fromId(null), HomeRoom.kitchen);
    expect(HomeRoom.fromId('nope'), HomeRoom.kitchen);
    expect(HomeRoom.fromId('bathroom'), HomeRoom.bathroom);
  });

  test('room prefs persist round-trip', () async {
    final prefs = MemoryRoomPreferences();
    await prefs.writeRoom(HomeRoom.bathroom);
    expect(await prefs.readRoom(), HomeRoom.bathroom);
  });

  test('RoomCubit goTo persists and applies theme', () async {
    final prefs = MemoryRoomPreferences();
    final theme = HomeThemeCubit();
    await theme.hydrate();
    final rooms = RoomCubit(preferences: prefs, themeCubit: theme);
    await rooms.hydrate();

    await rooms.goTo(HomeRoom.bathroom);
    expect(rooms.state, HomeRoom.bathroom);
    expect(await prefs.readRoom(), HomeRoom.bathroom);
    expect(theme.state.themeId, HomeRoom.bathroom.defaultThemeId);

    await rooms.goTo(HomeRoom.bedroom);
    expect(theme.state.themeId, HomeRoom.bedroom.defaultThemeId);

    await rooms.close();
    await theme.close();
  });

  testWidgets('bathroom chip shows bath tray hides food', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomePage(character: SizedBox())),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('room_chip_bar')), findsOneWidget);
    expect(find.byKey(const Key('food_tray')), findsOneWidget);
    expect(find.byKey(const Key('bath_tray')), findsNothing);

    await tester.tap(find.byKey(const Key('room_bathroom')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('bath_tray')), findsOneWidget);
    expect(find.byKey(const Key('food_tray')), findsNothing);

    await tester.tap(find.byKey(const Key('room_bedroom')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('food_tray')), findsNothing);
    expect(find.byKey(const Key('bath_tray')), findsNothing);

    await tester.tap(find.byKey(const Key('room_kitchen')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('food_tray')), findsOneWidget);
  });
}
