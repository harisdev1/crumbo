import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_page.dart';

abstract final class AppRoutes {
  static const home = '/';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
