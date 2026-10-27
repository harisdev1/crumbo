import 'package:flutter/material.dart';

/// AnggaMotion Owl Expression Pack — MAIN-sheet artboards `"1"`…`"15"`,
/// plus custom sleep in [assetPath] `owl_sleep.riv`.
///
/// Source: https://rive.app/marketplace/25712-48015-owl-mascot-expression-pack-cute-cartoon-vector-for-app-ui-and-branding/
/// License: CC BY — credit AnggaMotion in UI.
enum OwlExpression {
  happy(
    '1',
    'Happy',
    Icons.emoji_emotions_rounded,
    Color(0xFFCE93D8),
    'Dancing!',
  ),
  wink(
    '2',
    'Wink',
    Icons.visibility_rounded,
    Color(0xFFF48FB1),
    'Wink!',
  ),
  cry(
    '3',
    'Cry',
    Icons.water_drop_rounded,
    Color(0xFF64B5F6),
    'Waah…',
  ),
  cool(
    '4',
    'Cool',
    Icons.thumb_up_rounded,
    Color(0xFF78909C),
    'Too cool',
  ),
  love(
    '5',
    'Love',
    Icons.favorite_border_rounded,
    Color(0xFFE57373),
    'Heart eyes',
  ),
  dizzy(
    '6',
    'Dizzy',
    Icons.sync_rounded,
    Color(0xFFFFB74D),
    'Whoa…',
    stageScale: 0.78,
  ),
  shocked(
    '7',
    'Shock',
    Icons.sentiment_very_satisfied_rounded,
    Color(0xFFFF8A65),
    'Oh!',
    stageScale: 0.90,
  ),
  angry(
    '8',
    'Angry',
    Icons.local_fire_department_rounded,
    Color(0xFFE53935),
    'Grr!',
    stageScale: 0.90,
  ),
  wave(
    '9',
    'Wave',
    Icons.waving_hand_rounded,
    Color(0xFF81C784),
    'Hi!',
  ),
  eat(
    '10',
    'Eat',
    Icons.restaurant_rounded,
    Color(0xFFFFB74D),
    'Nom nom…',
  ),
  /// Calm open-eye pose — default idle (not the wink board).
  think(
    '11',
    'Idle',
    Icons.favorite_rounded,
    Color(0xFFF48FB1),
    'Tap me!',
  ),
  heartBalloon(
    '12',
    'Heart',
    Icons.volunteer_activism_rounded,
    Color(0xFFEF5350),
    'For you',
    stageScale: 1.12,
  ),
  /// Pack board 13 = bubble wand (not sleep).
  bubbles(
    '13',
    'Bubbles',
    Icons.bubble_chart_rounded,
    Color(0xFF4FC3F7),
    'Blowing bubbles!',
    stageScale: 1.08,
  ),
  balloons(
    '14',
    'Party',
    Icons.celebration_rounded,
    Color(0xFFBA68C8),
    'Party!',
    stageScale: 1.25,
  ),
  birthday(
    '15',
    'Cake',
    Icons.cake_rounded,
    Color(0xFFFFCA28),
    'Make a wish',
    stageScale: 1.22,
  ),
  /// Custom sleep — closed eyes + floating Zzz (`assets/rive/owl_sleep.riv`).
  sleep(
    'sleep',
    'Sleep',
    Icons.bedtime_rounded,
    Color(0xFF7EB8DA),
    'Zzz — tap to wake',
    assetPath: 'assets/rive/owl_sleep.riv',
  ),
  /// Mic listening — sound waves (`assets/rive/owl_listen.riv`).
  listen(
    'listen',
    'Listen',
    Icons.hearing_rounded,
    Color(0xFF348EA0),
    'Listening…',
    assetPath: 'assets/rive/owl_listen.riv',
  ),
  /// Voice playback — mouth bob (`assets/rive/owl_talk.riv`).
  talk(
    'talk',
    'Talk',
    Icons.record_voice_over_rounded,
    Color(0xFFFF8A65),
    'Talking!',
    assetPath: 'assets/rive/owl_talk.riv',
  ),
  /// Front-facing bath — bubbles (`assets/rive/owl_bath.riv`).
  bath(
    'bath',
    'Bath',
    Icons.bathtub_rounded,
    Color(0xFF4FC3F7),
    'Bubble bath!',
    assetPath: 'assets/rive/owl_bath.riv',
  ),
  /// Front-facing clean — sparkles (`assets/rive/owl_clean.riv`).
  clean(
    'clean',
    'Clean',
    Icons.auto_awesome_rounded,
    Color(0xFFFFC107),
    'All sparkly!',
    assetPath: 'assets/rive/owl_clean.riv',
  );

  const OwlExpression(
    this.artboardName,
    this.label,
    this.icon,
    this.color,
    this.statusLabel, {
    this.assetPath = packAssetPath,
    this.stageScale = 1.0,
  });

  static const packAssetPath = 'assets/rive/owl.riv';

  /// Rive artboard name.
  final String artboardName;
  final String label;
  final IconData icon;
  final Color color;
  final String statusLabel;

  /// Which `.riv` file holds this artboard (pack vs custom sleep).
  final String assetPath;

  /// Shrink oversized pack boards so the owl looks the same size on stage.
  final double stageScale;

  /// Default resting pose — calm think board (no wink).
  static const OwlExpression idle = OwlExpression.think;

  /// Dance shortcut → happy jump.
  static const OwlExpression dance = OwlExpression.happy;

  /// Poke shortcut → wave.
  static const OwlExpression poke = OwlExpression.wave;

  /// Stays until user wakes / picks Idle / voice ends — no auto-return.
  bool get holdsUntilDismissed =>
      this == OwlExpression.sleep ||
      this == OwlExpression.think ||
      this == OwlExpression.listen ||
      this == OwlExpression.talk;

  /// Pack MAIN boards only (`"1"`…`"15"`).
  static List<OwlExpression> get packExpressions => values
      .where((e) => e.assetPath == packAssetPath)
      .toList(growable: false);

  /// Bottom care bar (day-1): always on home, no side rails.
  static const careBar = <OwlExpression>[
    sleep,
    eat,
    happy,
    wink,
  ];

  /// Moods sheet — care/tray/voice-driven expressions stay out.
  static List<OwlExpression> get moodPicker => values
      .where(
        (e) =>
            e != sleep &&
            e != eat &&
            e != listen &&
            e != talk &&
            e != bath &&
            e != clean,
      )
      .toList(growable: false);

  /// Extra moods in the More sheet (unlocked ones usable; rest locked).
  static const moreTray = <OwlExpression>[
    think,
    bubbles,
    cry,
    cool,
    love,
    dizzy,
    shocked,
    angry,
    wave,
    heartBalloon,
    balloons,
    birthday,
  ];

  /// Soft day-1 unlock mock — journey later expands this set.
  static const dayOneUnlocked = <OwlExpression>{
    sleep,
    think,
    eat,
    happy,
    wink,
    listen,
    talk,
    bath,
    clean,
  };

  /// Dev/playtest flag: when true, every expression is usable (no locks).
  /// Flip to false before journey gates ship.
  static const bool unlockAllExpressions = true;

  static bool isUnlocked(OwlExpression expression) {
    if (unlockAllExpressions) return true;
    return dayOneUnlocked.contains(expression);
  }
}
