import 'package:flutter_test/flutter_test.dart';

import '../../tool/owl_palette.dart';

const _classic = OwlTheme(
  body: 0xBE8C6C,
  accent: 0x76421C,
  belly: 0xF1E1BE,
  bow: 0x3F8DD2,
);

const _blue = OwlTheme(
  body: 0x7AB8E6,
  accent: 0x3D78B8,
  belly: 0xE4F2FC,
  bow: 0x3F7FD0,
);

void main() {
  test('pack colors map to owl roles', () {
    expect(classify(0xBE8C6C), OwlRole.body);
    expect(classify(0xA0684B), OwlRole.body);
    expect(classify(0x76421C), OwlRole.accent);
    expect(classify(0xD4AB8D), OwlRole.belly);
    expect(classify(0x237AC7), OwlRole.bow);
  });

  test('beak/feet orange, whites and blacks are kept', () {
    for (final rgb in [0xF3AA50, 0xDA7E2E, 0xFFFFFF, 0x000000, 0x373737]) {
      expect(classify(rgb), isNull, reason: rgb.toRadixString(16));
      expect(remapRgb(rgb, _blue), rgb);
    }
  });

  test('body shading keeps relative lightness on a new theme', () {
    final light = Hsl.fromRgb(remapRgb(0xBE8C6C, _blue));
    final shade = Hsl.fromRgb(remapRgb(0xA0684B, _blue));
    expect(light.h, closeTo(Hsl.fromRgb(0x7AB8E6).h, 2));
    expect(shade.l, lessThan(light.l));
  });

  test('classic theme roughly reproduces pack colors', () {
    final out = Hsl.fromRgb(remapRgb(0xBE8C6C, _classic));
    final src = Hsl.fromRgb(0xBE8C6C);
    expect(out.h, closeTo(src.h, 2));
    expect(out.l, closeTo(src.l, 0.02));
  });

  test('remapArgb keeps alpha', () {
    expect(remapArgb(0x80BE8C6C, _blue) & 0xFF000000, 0x80000000);
  });
}
