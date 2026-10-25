import 'package:crumbo/core/router/app_routes.dart';
import 'package:crumbo/features/home/domain/home_theme.dart';
import 'package:crumbo/features/home/presentation/pages/home_page.dart';
import 'package:crumbo/features/splash/domain/splash_icons.dart';
import 'package:crumbo/features/splash/presentation/splash_page.dart';
import 'package:crumbo/core/ui/rounded_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    HomeThemeCatalog.debugReset();
  });

  testWidgets('splash shows PNG hero art then opens home', (tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.splash,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomePage(
            character: ColoredBox(
              key: Key('crumbo_rive'),
              color: Color(0xFFFFE4B5),
            ),
          ),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();

    expect(find.text('Loading fun...'), findsOneWidget);
    expect(find.byKey(const Key('splash_owl')), findsOneWidget);
    expect(find.byKey(const Key('splash_icon_a')), findsOneWidget);
    expect(find.byKey(const Key('splash_icon_b')), findsOneWidget);
    final bar = tester.widget<RoundedProgressBar>(
      find.byKey(const Key('splash_progress')),
    );
    expect(bar.value, inInclusiveRange(0, 0.99));
    for (final path in SplashIcons.paths) {
      expect(
        find.byWidgetPredicate(
          (w) => w is Image && w.image is AssetImage && (w.image as AssetImage).assetName == path,
        ),
        findsWidgets,
      );
    }

    await tester.pumpAndSettle();
    expect(find.byKey(const Key('home_background')), findsOneWidget);
  });
}
