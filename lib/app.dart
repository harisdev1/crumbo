import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class CrumboApp extends StatelessWidget {
  const CrumboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Crumbo',
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
