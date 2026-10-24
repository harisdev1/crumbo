import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'app.dart';
import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RiveNative.init();
  await configureDependencies();
  runApp(const CrumboApp());
}
