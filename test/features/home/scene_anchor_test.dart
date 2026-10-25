import 'dart:ui';

import 'package:crumbo/features/home/domain/scene_anchor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('cover mapping keeps the SVG centre on the screen centre', () {
    const screen = Size(462, 1024);
    expect(sceneToScreenY(screen, 960, zoom: 1), closeTo(512, 0.01));
  });

  test('wide screens map Y with the cover scale', () {
    const screen = Size(800, 600);
    final scale = 800 / 1080;
    final top = (600 - 1920 * scale) / 2;
    expect(sceneToScreenY(screen, 0, zoom: 1), closeTo(top, 0.01));
  });

  test('owl feet land on the perch for phone, tablet and square', () {
    const screens = <Size>[
      Size(462, 1024),
      Size(800, 600),
      Size(1024, 768),
      Size(400, 400),
    ];
    for (final screen in screens) {
      const perch = 1290.0;
      const box = 400.0;
      const scale = 0.96;
      final top = owlBoxTop(
        screen: screen,
        perchY: perch,
        boxSize: box,
        owlScale: scale,
      );
      final foot = top + box / 2 + (owlFootRatio - 0.5) * box * scale;
      expect(foot, closeTo(sceneToScreenY(screen, perch), 0.01));
    }
  });
}
