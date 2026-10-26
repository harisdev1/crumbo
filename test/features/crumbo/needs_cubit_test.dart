import 'package:crumbo/features/crumbo/data/needs_repository.dart';
import 'package:crumbo/features/crumbo/domain/need_kind.dart';
import 'package:crumbo/features/crumbo/domain/pet_mood.dart';
import 'package:crumbo/features/crumbo/domain/pet_needs.dart';
import 'package:crumbo/features/crumbo/presentation/cubit/needs_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MemoryNeedsRepository repo;
  late DateTime now;

  setUp(() {
    repo = MemoryNeedsRepository();
    now = DateTime.utc(2026, 10, 25, 12);
  });

  NeedsCubit cubit() => NeedsCubit(repository: repo, clock: () => now);

  test('hydrate applies decay across clock jump', () async {
    await repo.save(
      PetNeeds(
        hunger: 100,
        sleep: 100,
        fun: 100,
        clean: 100,
        love: 100,
        lastSeenAt: now,
      ),
    );
    now = now.add(const Duration(hours: 3));

    final c = cubit();
    await c.hydrate();

    expect(c.state.needs.hunger, 88); // 100 - 4*3
    expect(c.state.needs.fun, 85); // 100 - 5*3
    expect(c.state.needs.lastSeenAt, now);
    expect(c.state.mood, PetMood.happy);
    await c.close();
  });

  test('boost raises a need and clamps', () async {
    final c = cubit();
    await c.hydrate();
    final before = c.state.needs.hunger;
    await c.boost(NeedKind.hunger, 50);
    expect(c.state.needs.hunger, (before + 50).clamp(0, 100));
    await c.boost(NeedKind.hunger, 100);
    expect(c.state.needs.hunger, 100);
    await c.close();
  });

  test('fresh hydrate starts near default level', () async {
    final c = cubit();
    await c.hydrate();
    expect(c.state.needs.hunger, PetNeeds.defaultLevel);
    expect(c.state.mood, PetMood.happy);
    await c.close();
  });
}
