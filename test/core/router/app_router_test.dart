import 'package:crumbo/app.dart';
import 'package:crumbo/core/di/injection.dart';
import 'package:crumbo/core/theme/app_theme.dart';
import 'package:crumbo/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    await configureDependencies();
  });

  testWidgets('CrumboApp theme + routed home without native Rive',
      (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomePage(
            character: const ColoredBox(
              key: Key('crumbo_rive'),
              color: Color(0xFFFFE4B5),
            ),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        title: 'Crumbo',
        theme: AppTheme.light,
        routerConfig: router,
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('home_title')), findsOneWidget);
    expect(find.byKey(const Key('home_background')), findsOneWidget);
    expect(find.text(HomePage.tagline), findsOneWidget);
    expect(find.byKey(const Key('care_action_bar')), findsOneWidget);

    final BuildContext context =
        tester.element(find.byKey(const Key('home_title')));
    expect(
      Theme.of(context).textTheme.bodyLarge?.fontFamily,
      AppTheme.fontFamily,
    );
    expect(Theme.of(context).colorScheme.primary, CrumboColors.crust);
  });

  testWidgets('CrumboApp widget builds', (tester) async {
    expect(const CrumboApp(), isA<Widget>());
  });
}
