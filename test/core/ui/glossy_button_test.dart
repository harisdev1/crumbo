import 'package:crumbo/core/ui/glossy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('glossy button calls onPressed and ignores a disabled tap', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlossyButton(
            key: const Key('glossy'),
            label: 'Play',
            onPressed: () => taps++,
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('glossy')));
    await tester.pump();
    expect(taps, 1);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GlossyButton(
            key: Key('glossy_off'),
            label: 'Soon',
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('glossy_off')));
    await tester.pump();
    expect(taps, 1);
    expect(
      tester.widget<GlossyButton>(find.byKey(const Key('glossy_off'))).onPressed,
      isNull,
    );
  });
}
