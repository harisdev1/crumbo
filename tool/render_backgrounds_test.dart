// Renders every background SVG into one contact sheet for visual review.
// Run: flutter test tool/render_backgrounds_test.dart
// Output: build/bg_check/contact_sheet.png
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

const _cellW = 216.0;
const _cellH = 384.0;
const _cols = 6;

void main() {
  testWidgets('render background contact sheet', (tester) async {
    await tester.runAsync(() async {
      final json = jsonDecode(
        File('assets/data/home_themes.json').readAsStringSync(),
      ) as Map<String, dynamic>;
      final themes = (json['themes'] as List).cast<Map<String, dynamic>>();
      final rows = (themes.length / _cols).ceil();

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, _cellW * _cols, 10000),
        Paint()..color = const Color(0xFF222222),
      );

      for (var i = 0; i < themes.length; i++) {
        final svg = File(themes[i]['svg'] as String).readAsStringSync();
        final info = await vg.loadPicture(SvgStringLoader(svg), null);
        final dx = (i % _cols) * _cellW;
        final dy = (i ~/ _cols) * _cellH;
        canvas.save();
        canvas.translate(dx + 4, dy + 4);
        canvas.scale((_cellW - 8) / info.size.width,
            (_cellH - 8) / info.size.height);
        canvas.drawPicture(info.picture);
        canvas.restore();
        info.picture.dispose();
      }

      final image = await recorder.endRecording().toImage(
            (_cellW * _cols).toInt(),
            (_cellH * rows).toInt(),
          );
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      Directory('build/bg_check').createSync(recursive: true);
      File('build/bg_check/contact_sheet.png')
          .writeAsBytesSync(png!.buffer.asUint8List());
    });
  });
}
