// Crops 960px idle renders (build/skin_thumbs, from Rive MCP batch render of
// artboard "11") into square owl thumbnails for the Skins sheet.
// Run: flutter test tool/crop_skin_thumbs_test.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

const _src = 'build/skin_thumbs';
const _out = 'assets/images/skins';
const _crop = ui.Rect.fromLTWH(245, 205, 550, 550);
const _size = 360.0;

void main() {
  testWidgets('crop skin thumbnails', (tester) async {
    await tester.runAsync(() async {
      Directory(_out).createSync(recursive: true);
      for (final file in Directory(_src).listSync().whereType<File>()) {
        final name = file.uri.pathSegments.last;
        if (!name.endsWith('.png')) continue;
        final base = name.replaceAll('.png', '');
        final id = base == 'owl' ? 'classic_brown' : base.substring(4);

        final codec = await ui.instantiateImageCodec(file.readAsBytesSync());
        final image = (await codec.getNextFrame()).image;
        final recorder = ui.PictureRecorder();
        ui.Canvas(recorder).drawImageRect(
          image,
          _crop,
          const ui.Rect.fromLTWH(0, 0, _size, _size),
          ui.Paint()..filterQuality = ui.FilterQuality.high,
        );
        final cropped =
            await recorder.endRecording().toImage(_size.toInt(), _size.toInt());
        final png = await cropped.toByteData(format: ui.ImageByteFormat.png);
        File('$_out/$id.png').writeAsBytesSync(png!.buffer.asUint8List());
      }
    });
  });
}
