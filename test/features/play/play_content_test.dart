import 'package:crumbo/features/play/domain/play_content.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(PlayContent.debugReset);

  test('play content has the static game boards', () async {
    final content = await PlayContent.load();
    expect(content.games, hasLength(6));
    expect(content.games.map((game) => game.id), contains('jump_owl'));
    expect(content.rewards, hasLength(7));
    expect(content.rewards.first.unlocked, isTrue);
    expect(content.rewards.skip(1).every((day) => !day.unlocked), isTrue);
    expect(content.profile.name, 'Player');
    expect(content.profile.level, 1);
    expect(content.scores.every((score) => score.score == 0), isTrue);
    expect(content.coinPacks, isNotEmpty);
    expect(content.gemPacks, isNotEmpty);
    expect(content.foods.map((food) => food.id), contains('fruits'));
  });
}
