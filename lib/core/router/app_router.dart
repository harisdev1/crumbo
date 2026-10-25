import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/level/presentation/level_up_page.dart';
import '../../features/owls/presentation/coloring_page.dart';
import '../../features/owls/presentation/my_owls_page.dart';
import '../../features/play/presentation/game_over_page.dart';
import '../../features/play/presentation/games_hub_page.dart';
import '../../features/play/presentation/reward_page.dart';
import '../../features/profile/presentation/achievements_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/profile/presentation/scores_page.dart';
import '../../features/rewards/presentation/daily_rewards_page.dart';
import '../../features/rewards/presentation/food_page.dart';
import '../../features/rewards/presentation/market_page.dart';
import '../../features/rewards/presentation/theme_shop_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/shop/presentation/shop_page.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../features/store/presentation/store_page.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.shop,
      builder: (context, state) => const ShopPage(),
    ),
    GoRoute(
      path: AppRoutes.levelUp,
      builder: (context, state) => const LevelUpPage(),
    ),
    GoRoute(
      path: AppRoutes.play,
      builder: (context, state) => const GamesHubPage(),
    ),
    GoRoute(
      path: AppRoutes.gameOver,
      builder: (context, state) => const GameOverPage(),
    ),
    GoRoute(
      path: AppRoutes.reward,
      builder: (context, state) => const RewardPage(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: AppRoutes.achievements,
      builder: (context, state) => const AchievementsPage(),
    ),
    GoRoute(
      path: AppRoutes.scores,
      builder: (context, state) => const ScoresPage(),
    ),
    GoRoute(
      path: AppRoutes.daily,
      builder: (context, state) => const DailyRewardsPage(),
    ),
    GoRoute(
      path: AppRoutes.food,
      builder: (context, state) => const FoodPage(),
    ),
    GoRoute(
      path: AppRoutes.market,
      builder: (context, state) => const MarketPage(),
    ),
    GoRoute(
      path: AppRoutes.themeShop,
      builder: (context, state) => const ThemeShopPage(),
    ),
    GoRoute(
      path: AppRoutes.store,
      builder: (context, state) => const StorePage(),
    ),
    GoRoute(
      path: AppRoutes.myOwls,
      builder: (context, state) => const MyOwlsPage(),
    ),
    GoRoute(
      path: AppRoutes.coloring,
      builder: (context, state) => const ColoringPage(),
    ),
  ],
);
