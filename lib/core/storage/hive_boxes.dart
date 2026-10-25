import 'package:hive_ce/hive.dart';

/// Named Hive boxes for local offline storage (no personal data).
abstract final class HiveBoxNames {
  static const crumboState = 'crumbo_state';
  static const inventory = 'inventory';
  static const economy = 'economy';
  static const settings = 'settings';

  static const all = [crumboState, inventory, economy, settings];
}

/// Opened boxes after [HiveStorage.init].
class HiveBoxes {
  HiveBoxes({
    required this.crumboState,
    required this.inventory,
    required this.economy,
    required this.settings,
  });

  final Box<dynamic> crumboState;
  final Box<dynamic> inventory;
  final Box<dynamic> economy;
  final Box<dynamic> settings;
}
