import 'package:crumbo/features/crumbo/data/needs_repository.dart';
import 'package:crumbo/features/crumbo/domain/needs_decay.dart';
import 'package:crumbo/features/crumbo/domain/pet_mood.dart';
import 'package:crumbo/features/crumbo/domain/pet_needs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final t0 = DateTime.utc(2026, 10, 25, 12);

  PetNeeds fullAt(DateTime at) => PetNeeds(
        hunger: 100,
        sleep: 100,
        fun: 100,
        clean: 100,
        love: 100,
        lastSeenAt: at,
      );

  test('0 elapsed keeps values and stamps lastSeenAt', () {
    final before = fullAt(t0);
    final after = NeedsDecay.apply(before, t0);
    expect(after.hunger, 100);
    expect(after.fun, 100);
    expect(after.lastSeenAt, t0);
  });

  test('1 hour subtracts plan rates', () {
    final after = NeedsDecay.apply(fullAt(t0), t0.add(const Duration(hours: 1)));
    expect(after.hunger, 96);
    expect(after.sleep, 97);
    expect(after.fun, 95);
    expect(after.clean, 98);
    expect(after.love, 97.5);
    expect(after.lastSeenAt, t0.add(const Duration(hours: 1)));
  });

  test('0.5 hour applies half rates', () {
    final after =
        NeedsDecay.apply(fullAt(t0), t0.add(const Duration(minutes: 30)));
    expect(after.hunger, 98);
    expect(after.fun, 97.5);
    expect(after.love, 98.75);
  });

  test('100 hours clamps to zero never negative', () {
    final after =
        NeedsDecay.apply(fullAt(t0), t0.add(const Duration(hours: 100)));
    expect(after.hunger, 0);
    expect(after.sleep, 0);
    expect(after.fun, 0);
    expect(after.clean, 0);
    expect(after.love, 0);
  });

  test('MemoryNeedsRepository round-trip', () async {
    final repo = MemoryNeedsRepository();
    final needs = PetNeeds(
      hunger: 40,
      sleep: 50,
      fun: 60,
      clean: 70,
      love: 80,
      lastSeenAt: t0,
    );
    await repo.save(needs);
    final loaded = await repo.load(now: t0);
    expect(loaded.hunger, 40);
    expect(loaded.sleep, 50);
    expect(loaded.fun, 60);
    expect(loaded.clean, 70);
    expect(loaded.love, 80);
    expect(loaded.lastSeenAt, t0);
  });

  test('PetMood happy when all high', () {
    expect(PetMood.fromNeeds(PetNeeds.fresh(at: t0)), PetMood.happy);
  });

  test('PetMood hungry when hunger critical', () {
    final needs = PetNeeds.fresh(at: t0).copyWith(hunger: 10);
    expect(PetMood.fromNeeds(needs), PetMood.hungry);
  });

  test('PetMood picks lowest critical need', () {
    final needs = PetNeeds.fresh(at: t0).copyWith(hunger: 12, sleep: 5);
    expect(PetMood.fromNeeds(needs), PetMood.sleepy);
  });
}
