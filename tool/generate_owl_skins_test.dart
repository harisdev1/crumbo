// Generates recolored copies of the real pack owl for every skin.
// Run: flutter test tool/generate_owl_skins_test.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

import 'owl_palette.dart';
import 'riv_colors.dart';

const _packPath = 'assets/rive/owl.riv';
const _sleepPath = 'assets/rive/owl_sleep.riv';
const _outDir = 'assets/rive/skins';

/// FileAssetContents typeKey (embedded image bytes).
const _fileAssetContentsType = 106;

void main() {
  testWidgets('generate owl skin rivs', (tester) async {
    await tester.runAsync(() async {
      final json = jsonDecode(
        File('assets/data/owl_skins.json').readAsStringSync(),
      ) as Map<String, dynamic>;
      final skins = (json['skins'] as List).cast<Map<String, dynamic>>();
      Directory(_outDir).createSync(recursive: true);

      final pack = File(_packPath).readAsBytesSync();
      final sleep = File(_sleepPath).readAsBytesSync();
      final packScan = scanRiv(pack);
      final sleepScan = scanRiv(sleep);
      final sleepPng = sleepScan.blobs
          .firstWhere((b) => b.typeKey == _fileAssetContentsType);
      final sleepPixels = await _decodePng(
        sleep.sublist(sleepPng.dataStart, sleepPng.end),
      );

      for (final skin in skins) {
        final id = skin['id'] as String;
        if (id == json['defaultId']) continue;
        final theme = OwlTheme(
          body: parseHex(skin['body'] as String),
          accent: parseHex(skin['accent'] as String),
          belly: parseHex(skin['belly'] as String),
          bow: parseHex(skin['bow'] as String),
        );

        File('$_outDir/owl_$id.riv')
            .writeAsBytesSync(_recolorColors(pack, packScan, theme));

        final png = await _recolorPng(sleepPixels, theme);
        final sleepOut = _recolorColors(sleep, sleepScan, theme);
        File('$_outDir/owl_sleep_$id.riv').writeAsBytesSync(
          _replaceBlob(sleepOut, sleepPng, png),
        );
      }
    });
  });
}

Uint8List _recolorColors(Uint8List src, RivScan scan, OwlTheme theme) {
  final out = Uint8List.fromList(src);
  final data = ByteData.sublistView(out);
  for (final c in scan.colors) {
    data.setUint32(c.offset, remapArgb(c.argb, theme), Endian.little);
  }
  return out;
}

Uint8List _replaceBlob(Uint8List src, RivBytesField blob, Uint8List payload) {
  final builder = BytesBuilder(copy: false)
    ..add(src.sublist(0, blob.start))
    ..add(encodeVaruint(payload.length))
    ..add(payload)
    ..add(src.sublist(blob.end));
  return builder.toBytes();
}

class _Pixels {
  _Pixels(this.width, this.height, this.rgba);

  final int width;
  final int height;
  final Uint8List rgba;
}

Future<_Pixels> _decodePng(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  final image = frame.image;
  final data = await image.toByteData(format: ui.ImageByteFormat.rawStraightRgba);
  return _Pixels(image.width, image.height, data!.buffer.asUint8List());
}

Future<Uint8List> _recolorPng(_Pixels src, OwlTheme theme) async {
  final rgba = Uint8List.fromList(src.rgba);
  final cache = <int, int>{};
  for (var i = 0; i < rgba.length; i += 4) {
    if (rgba[i + 3] == 0) continue;
    final rgb = (rgba[i] << 16) | (rgba[i + 1] << 8) | rgba[i + 2];
    final mapped = cache.putIfAbsent(rgb, () => remapRgb(rgb, theme));
    rgba[i] = (mapped >> 16) & 0xff;
    rgba[i + 1] = (mapped >> 8) & 0xff;
    rgba[i + 2] = mapped & 0xff;
  }
  final buffer = await ui.ImmutableBuffer.fromUint8List(rgba);
  final descriptor = ui.ImageDescriptor.raw(
    buffer,
    width: src.width,
    height: src.height,
    pixelFormat: ui.PixelFormat.rgba8888,
  );
  final codec = await descriptor.instantiateCodec();
  final frame = await codec.getNextFrame();
  final png = await frame.image.toByteData(format: ui.ImageByteFormat.png);
  return png!.buffer.asUint8List();
}
