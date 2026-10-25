import 'package:crumbo/features/crumbo/domain/owl_bonk.dart';
import 'package:crumbo/features/crumbo/domain/owl_expression.dart';
import 'package:crumbo/features/crumbo/presentation/cubit/crumbo_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CrumboCubit cubit;

  setUp(() {
    cubit = CrumboCubit();
  });

  tearDown(() async {
    await cubit.close();
  });

  test('starts idle on think artboard 11 (not wink)', () {
    expect(cubit.state.expression, OwlExpression.think);
    expect(cubit.state.artboardName, '11');
    expect(cubit.state.expression, isNot(OwlExpression.wink));
  });

  test('all 15 pack expressions map to unique artboards 1-15', () {
    final boards =
        OwlExpression.packExpressions.map((e) => e.artboardName).toList();
    expect(boards.toSet().length, 15);
    expect(
      boards.toSet(),
      {for (var i = 1; i <= 15; i++) '$i'},
    );
  });

  test('setSleep uses custom sleep riv and holds', () async {
    cubit.setSleep();
    expect(cubit.state.expression, OwlExpression.sleep);
    expect(cubit.state.artboardName, 'sleep');
    expect(cubit.state.expression.assetPath, 'assets/rive/owl_sleep.riv');
    await Future<void>.delayed(const Duration(milliseconds: 3000));
    expect(cubit.state.expression, OwlExpression.sleep);
  });

  test('eat auto-returns to idle', () async {
    cubit.setExpression(OwlExpression.eat);
    expect(cubit.state.artboardName, '10');
    await Future<void>.delayed(const Duration(milliseconds: 2900));
    expect(cubit.state.expression, OwlExpression.idle);
    expect(cubit.state.artboardName, '11');
  });

  test('wink is a separate expression then auto-idles', () async {
    cubit.setExpression(OwlExpression.wink);
    expect(cubit.state.artboardName, '2');
    await Future<void>.delayed(const Duration(milliseconds: 2900));
    expect(cubit.state.artboardName, '11');
  });

  test('setDance uses happy artboard 1', () {
    cubit.setDance();
    expect(cubit.state.artboardName, '1');
  });

  test('onCharacterTapped wakes from sleep', () {
    cubit.setSleep();
    cubit.onCharacterTapped();
    expect(cubit.state.expression, OwlExpression.idle);
  });

  test('three quick body bonks end in sleep', () {
    final t0 = DateTime(2026, 1, 1, 12);
    cubit.onCharacterTapped(now: t0);
    expect(cubit.state.artboardName, '8');
    cubit.onCharacterTapped(now: t0.add(const Duration(milliseconds: 400)));
    expect(cubit.state.artboardName, '6');
    cubit.onCharacterTapped(now: t0.add(const Duration(milliseconds: 800)));
    expect(cubit.state.expression, OwlExpression.sleep);
  });

  test('slow bonk restarts at angry', () {
    final t0 = DateTime(2026, 1, 1, 12);
    cubit.onCharacterTapped(now: t0);
    expect(cubit.state.artboardName, '8');
    cubit.onCharacterTapped(
      now: t0.add(owlBonkComboWindow + const Duration(seconds: 1)),
    );
    expect(cubit.state.artboardName, '8');
  });

  test('poke uses wave then returns idle', () async {
    cubit.poke();
    expect(cubit.state.artboardName, '9');
    await Future<void>.delayed(const Duration(milliseconds: 2900));
    expect(cubit.state.expression, OwlExpression.idle);
  });

  test('care aliases', () {
    expect(OwlExpression.idle.artboardName, '11');
    expect(OwlExpression.sleep.artboardName, 'sleep');
    expect(OwlExpression.dance.artboardName, '1');
    expect(OwlExpression.poke.artboardName, '9');
  });

  test('mood picker lists every face except sleep and eat', () {
    expect(
      OwlExpression.moodPicker,
      hasLength(OwlExpression.values.length - 2),
    );
    expect(OwlExpression.moodPicker, isNot(contains(OwlExpression.sleep)));
    expect(OwlExpression.moodPicker, isNot(contains(OwlExpression.eat)));
    expect(
      {...OwlExpression.moodPicker, OwlExpression.sleep, OwlExpression.eat},
      OwlExpression.values.toSet(),
    );
  });

  test('day-one unlocks are the starter care set', () {
    expect(OwlExpression.dayOneUnlocked, {
      OwlExpression.sleep,
      OwlExpression.think,
      OwlExpression.eat,
      OwlExpression.happy,
      OwlExpression.wink,
    });
    expect(OwlExpression.dayOneUnlocked.contains(OwlExpression.cool), isFalse);
    expect(OwlExpression.dayOneUnlocked.contains(OwlExpression.eat), isTrue);
  });

  test('unlockAllExpressions flag allows every mood for now', () {
    expect(OwlExpression.unlockAllExpressions, isTrue);
    expect(OwlExpression.isUnlocked(OwlExpression.cool), isTrue);
    expect(OwlExpression.isUnlocked(OwlExpression.bubbles), isTrue);
    expect(OwlExpression.isUnlocked(OwlExpression.birthday), isTrue);
  });

  test('stageScale unifies owl size vs idle baseline', () {
    expect(OwlExpression.think.stageScale, 1.0);
    expect(OwlExpression.balloons.stageScale, greaterThan(1));
    expect(OwlExpression.birthday.stageScale, greaterThan(1));
    expect(OwlExpression.heartBalloon.stageScale, greaterThan(1));
    expect(OwlExpression.bubbles.stageScale, greaterThan(1));
    expect(OwlExpression.shocked.stageScale, lessThan(1));
    expect(OwlExpression.angry.stageScale, lessThan(1));
    expect(OwlExpression.dizzy.stageScale, lessThan(1));
  });
}
