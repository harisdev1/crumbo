import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

/// Registers app-wide dependencies. Call once from [main] before [runApp].
Future<void> configureDependencies() async {
  // Feature repositories / cubits register here as they are added.
}
