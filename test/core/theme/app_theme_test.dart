import 'package:crumbo/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppTheme.light uses character-sheet palette and Fredoka', () {
    final theme = AppTheme.light;

    expect(theme.scaffoldBackgroundColor, CrumboColors.scaffold);
    expect(theme.colorScheme.primary, CrumboColors.crust);
    expect(theme.textTheme.headlineMedium?.fontFamily, 'Fredoka');
    expect(theme.useMaterial3, isTrue);
  });
}
