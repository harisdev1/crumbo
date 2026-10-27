/// Care rooms on the single home scene (B2).
enum HomeRoom {
  kitchen(
    id: 'kitchen',
    label: 'Kitchen',
    defaultThemeId: 'morning_glow',
  ),
  bedroom(
    id: 'bedroom',
    label: 'Bedroom',
    defaultThemeId: 'sleepy_night',
  ),
  bathroom(
    id: 'bathroom',
    label: 'Bathroom',
    defaultThemeId: 'playful_bubbles',
  );

  const HomeRoom({
    required this.id,
    required this.label,
    required this.defaultThemeId,
  });

  final String id;
  final String label;
  final String defaultThemeId;

  static const HomeRoom defaultRoom = HomeRoom.kitchen;

  bool get showsFoodTray => this == HomeRoom.kitchen;

  bool get showsBathTray => this == HomeRoom.bathroom;

  static HomeRoom fromId(String? id) {
    if (id == null) return defaultRoom;
    for (final room in values) {
      if (room.id == id) return room;
    }
    return defaultRoom;
  }
}
