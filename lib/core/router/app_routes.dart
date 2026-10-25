import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const splash = '/splash';
  static const home = '/';
  static const settings = '/settings';
  static const shop = '/shop';
  static const levelUp = '/level-up';
  static const play = '/play';
  static const gameOver = '/game-over';
  static const reward = '/reward';
  static const profile = '/profile';
  static const achievements = '/achievements';
  static const scores = '/scores';
  static const daily = '/daily';
  static const food = '/food';
  static const market = '/market';
  static const themeShop = '/theme-shop';
  static const store = '/store';
  static const myOwls = '/my-owls';
  static const coloring = '/coloring';
}

void pushAppRoute(BuildContext context, String path) {
  final router = GoRouter.maybeOf(context);
  if (router == null) return;
  router.push(path);
}

void popAppRoute(BuildContext context) {
  final router = GoRouter.maybeOf(context);
  if (router != null) {
    if (router.canPop()) router.pop();
    return;
  }
  final navigator = Navigator.maybeOf(context);
  if (navigator != null && navigator.canPop()) navigator.pop();
}
