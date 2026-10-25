import 'package:flutter/widgets.dart';

/// True while `flutter test` is running.
///
/// Repeating tickers never go idle, so widget tests cannot `pumpAndSettle`.
bool get isFlutterTest =>
    WidgetsBinding.instance.runtimeType.toString().contains('Test');
