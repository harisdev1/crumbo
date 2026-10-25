import 'package:crumbo/features/crumbo/domain/owl_bonk.dart';
import 'package:crumbo/features/crumbo/domain/owl_expression.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bonk reactions follow angry dizzy sleep', () {
    expect(owlBonkReaction(1), OwlExpression.angry);
    expect(owlBonkReaction(2), OwlExpression.dizzy);
    expect(owlBonkReaction(3), OwlExpression.sleep);
    expect(owlBonkIsExhausted(3), isTrue);
    expect(owlBonkIsExhausted(2), isFalse);
  });

  test('streak resets after combo window', () {
    expect(
      owlBonkStreakAfter(
        previousStreak: 2,
        sinceLastTap: owlBonkComboWindow + const Duration(milliseconds: 1),
      ),
      1,
    );
    expect(
      owlBonkStreakAfter(
        previousStreak: 1,
        sinceLastTap: const Duration(milliseconds: 400),
      ),
      2,
    );
  });
}
