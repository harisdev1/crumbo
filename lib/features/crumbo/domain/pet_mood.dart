import 'need_kind.dart';
import 'pet_needs.dart';

/// Kids-safe mood label derived from need meters (not Rive artboards).
enum PetMood {
  happy,
  cozy,
  ok,
  hungry,
  sleepy,
  bored,
  messy,
  lonely;

  String get label => switch (this) {
        PetMood.happy => 'Happy',
        PetMood.cozy => 'Cozy',
        PetMood.ok => 'OK',
        PetMood.hungry => 'Hungry',
        PetMood.sleepy => 'Sleepy',
        PetMood.bored => 'Bored',
        PetMood.messy => 'Messy',
        PetMood.lonely => 'Lonely',
      };

  /// Priority: critical low need → happy → cozy → ok.
  static PetMood fromNeeds(PetNeeds needs) {
    const critical = 15.0;
    NeedKind? lowestCritical;
    var lowestValue = double.infinity;

    for (final kind in NeedKind.values) {
      final v = needs.valueOf(kind);
      if (v <= critical && v < lowestValue) {
        lowestValue = v;
        lowestCritical = kind;
      }
    }

    if (lowestCritical != null) {
      return switch (lowestCritical) {
        NeedKind.hunger => PetMood.hungry,
        NeedKind.sleep => PetMood.sleepy,
        NeedKind.fun => PetMood.bored,
        NeedKind.clean => PetMood.messy,
        NeedKind.love => PetMood.lonely,
      };
    }

    if (needs.hunger >= 70 &&
        needs.sleep >= 70 &&
        needs.fun >= 70 &&
        needs.clean >= 70 &&
        needs.love >= 70) {
      return PetMood.happy;
    }

    if (needs.average >= 50) return PetMood.cozy;
    return PetMood.ok;
  }
}
