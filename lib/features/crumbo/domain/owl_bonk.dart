import 'owl_expression.dart';

/// How many quick taps start the tired-out reaction.
const owlBonkHitsToExhaust = 3;

/// Combo resets if the kid waits longer than this between taps.
const owlBonkComboWindow = Duration(milliseconds: 2200);

/// Next face after a tap on the owl body (1-based hit in the current combo).
OwlExpression owlBonkReaction(int hitInCombo) {
  switch (hitInCombo) {
    case 1:
      return OwlExpression.angry;
    case 2:
      return OwlExpression.dizzy;
    default:
      return OwlExpression.sleep;
  }
}

/// Whether this hit ends the combo with the exhausted pose.
bool owlBonkIsExhausted(int hitInCombo) =>
    hitInCombo >= owlBonkHitsToExhaust;

/// Streak after a tap, given the previous streak and time since last tap.
int owlBonkStreakAfter({
  required int previousStreak,
  required Duration sinceLastTap,
}) {
  if (sinceLastTap > owlBonkComboWindow) return 1;
  return previousStreak + 1;
}
