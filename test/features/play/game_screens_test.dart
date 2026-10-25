import 'package:crumbo/core/router/app_routes.dart';
import 'package:crumbo/core/ui/glossy_button.dart';
import 'package:crumbo/features/crumbo/domain/owl_expression.dart';
import 'package:crumbo/features/crumbo/domain/owl_skin.dart';
import 'package:crumbo/features/crumbo/presentation/cubit/crumbo_cubit.dart';
import 'package:crumbo/features/home/data/theme_preferences.dart';
import 'package:crumbo/features/home/domain/home_theme.dart';
import 'package:crumbo/features/home/presentation/cubit/home_theme_cubit.dart';
import 'package:crumbo/features/level/presentation/level_up_page.dart';
import 'package:crumbo/features/owls/presentation/coloring_page.dart';
import 'package:crumbo/features/owls/presentation/my_owls_page.dart';
import 'package:crumbo/features/play/domain/play_content.dart';
import 'package:crumbo/features/play/presentation/game_over_page.dart';
import 'package:crumbo/features/play/presentation/games_hub_page.dart';
import 'package:crumbo/features/play/presentation/reward_page.dart';
import 'package:crumbo/features/profile/presentation/achievements_page.dart';
import 'package:crumbo/features/profile/presentation/profile_page.dart';
import 'package:crumbo/features/profile/presentation/scores_page.dart';
import 'package:crumbo/features/rewards/presentation/daily_rewards_page.dart';
import 'package:crumbo/features/rewards/presentation/food_page.dart';
import 'package:crumbo/features/rewards/presentation/market_page.dart';
import 'package:crumbo/features/rewards/presentation/theme_shop_page.dart';
import 'package:crumbo/features/settings/presentation/settings_page.dart';
import 'package:crumbo/features/shop/presentation/shop_page.dart';
import 'package:crumbo/features/store/presentation/parental_gate.dart';
import 'package:crumbo/features/store/presentation/store_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PlayContent.debugReset();
    OwlSkinCatalog.debugReset();
    HomeThemeCatalog.debugReset();
    await PlayContent.load();
    await OwlSkinCatalog.load();
    await HomeThemeCatalog.load();
  });

  testWidgets('Play and Earn shows six games and Coming soon', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: GamesHubPage()));
    await tester.pumpAndSettle();

    final content = await PlayContent.load();
    expect(content.games, hasLength(6));
    for (final game in content.games) {
      expect(find.byKey(Key('game_${game.id}')), findsOneWidget);
    }

    await tester.tap(find.byKey(const Key('game_jump_owl')));
    await tester.pump();
    expect(find.text('Coming soon'), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('Game Over and reward chest stay at zero', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: GameOverPage()));
    expect(
      tester.widget<Text>(find.byKey(const Key('game_over_score'))).data,
      '0',
    );
    expect(
      tester.widget<Text>(find.byKey(const Key('game_over_bonus'))).data,
      '+0',
    );

    await tester.pumpWidget(const MaterialApp(home: RewardPage()));
    expect(find.text('You got'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('reward_amount'))).data,
      '+0',
    );
  });

  testWidgets('Settings toggles are local and Level Up opens', (tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.settings,
      routes: [
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: AppRoutes.levelUp,
          builder: (context, state) => const LevelUpPage(),
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();

    SwitchListTile sound() => tester.widget<SwitchListTile>(
      find.byKey(const Key('toggle_sound')),
    );
    expect(sound().value, isTrue);
    await tester.tap(find.byKey(const Key('toggle_sound')));
    await tester.pump();
    expect(sound().value, isFalse);
    expect(find.text('Logout'), findsNothing);

    await tester.tap(find.byKey(const Key('open_level_up')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('level_up_star')), findsOneWidget);
    expect(find.text('+50'), findsOneWidget);
    expect(find.byKey(const Key('level_up_particles')), findsOneWidget);
  });

  testWidgets('Shop prices cannot be bought', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ShopPage()));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<GlossyButton>(find.byKey(const Key('shop_buy_coin_sack')))
          .onPressed,
      isNull,
    );
    expect(find.text('Coming soon'), findsWidgets);
  });

  testWidgets('Profile, achievements, scores and daily rewards render', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
    await tester.pumpAndSettle();
    expect(find.text('Player'), findsWidgets);
    expect(find.text('Level 1'), findsOneWidget);
    expect(find.text('Logout'), findsNothing);

    await tester.pumpWidget(const MaterialApp(home: AchievementsPage()));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('achievement_play_5')), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: ScoresPage()));
    await tester.pumpAndSettle();
    expect(find.text('My Best Scores'), findsOneWidget);
    expect(find.text('Sam'), findsNothing);

    await tester.pumpWidget(const MaterialApp(home: DailyRewardsPage()));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('reward_day_1')), findsOneWidget);
    expect(find.byIcon(Icons.lock_rounded), findsNWidgets(6));
  });

  testWidgets('Food tap starts eat', (tester) async {
    final cubit = CrumboCubit();
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: cubit, child: const FoodPage()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('food_fruits')));
    await tester.pump();
    expect(cubit.state.expression, OwlExpression.eat);
    await tester.pump(const Duration(seconds: 3));
    await cubit.close();
  });

  testWidgets('Market shows hat tab', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MarketPage()));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('market_red_hat')), findsOneWidget);
    expect(find.text('Hats'), findsWidgets);
  });

  testWidgets('Theme shop apply is free', (tester) async {
    final catalog = await HomeThemeCatalog.load();
    final prefs = MemoryThemePreferences();
    final cubit = HomeThemeCubit(preferences: prefs, catalog: catalog);
    await cubit.hydrate();
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: cubit, child: const ThemeShopPage()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('theme_shop_sleepy_night')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('theme_shop_apply')));
    await tester.pumpAndSettle();
    expect(await prefs.readThemeId(), 'sleepy_night');
    await cubit.close();
  });

  testWidgets('Get Coins stays behind the grown-up check', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: StorePage()));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('coin_prices')), findsNothing);

    await tester.tap(find.byKey(const Key('get_coins')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('parental_gate')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('parental_answer')), '1');
    await tester.tap(find.byKey(const Key('parental_ok')));
    await tester.pump();
    expect(find.text('Try again'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('parental_answer')),
      '${ParentalGate.answer}',
    );
    await tester.tap(find.byKey(const Key('parental_ok')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('coin_prices')), findsOneWidget);
    expect(
      tester.widget<GlossyButton>(find.byKey(const Key('buy_coins_100'))).onPressed,
      isNull,
    );
  });

  testWidgets('My Owls detail has no share button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyOwlsPage()));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('owl_card_classic_brown')), findsOneWidget);
    await tester.tap(find.byKey(const Key('owl_card_classic_brown')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('owl_detail')), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
    expect(find.textContaining('Share'), findsNothing);
    expect(find.text('Instagram'), findsNothing);
  });

  testWidgets('Coloring fill follows the palette', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ColoringPage()));
    await tester.tap(find.byKey(const Key('color_swatch_2')));
    await tester.pump();
    final box = tester.widget<DecoratedBox>(find.byKey(const Key('owl_fill')));
    final decoration = box.decoration as BoxDecoration;
    expect(decoration.color, ColoringPage.palette[2]);
  });
}
