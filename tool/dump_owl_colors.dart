import 'dart:io';
import 'dart:math';

import 'riv_colors.dart';

void main(List<String> args) {
  final path = args.isEmpty ? 'assets/rive/owl.riv' : args.first;
  final scan = scanRiv(File(path).readAsBytesSync());
  final counts = <int, int>{};
  for (final c in scan.colors) {
    counts[c.argb & 0xFFFFFF] = (counts[c.argb & 0xFFFFFF] ?? 0) + 1;
  }
  final sorted = counts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  stdout.writeln('colors=${scan.colors.length} unique=${counts.length} '
      'blobs=${scan.blobs.length}');
  for (final e in sorted) {
    final rgb = e.key;
    final h = _hsl(rgb);
    stdout.writeln('#${rgb.toRadixString(16).padLeft(6, '0')} x${e.value} '
        'h=${h[0].round()} s=${h[1].toStringAsFixed(2)} '
        'l=${h[2].toStringAsFixed(2)}');
  }
}

List<double> _hsl(int rgb) {
  final r = ((rgb >> 16) & 0xff) / 255;
  final g = ((rgb >> 8) & 0xff) / 255;
  final b = (rgb & 0xff) / 255;
  final mx = max(r, max(g, b));
  final mn = min(r, min(g, b));
  final l = (mx + mn) / 2;
  if (mx == mn) return [0, 0, l];
  final d = mx - mn;
  final s = l > 0.5 ? d / (2 - mx - mn) : d / (mx + mn);
  double h;
  if (mx == r) {
    h = ((g - b) / d) % 6;
  } else if (mx == g) {
    h = (b - r) / d + 2;
  } else {
    h = (r - g) / d + 4;
  }
  return [h * 60 < 0 ? h * 60 + 360 : h * 60, s, l];
}
