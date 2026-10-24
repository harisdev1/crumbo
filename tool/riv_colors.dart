import 'dart:typed_data';

/// Minimal .riv binary walker: finds every color field (4-byte uint32) and
/// byte-blob field so they can be rewritten without a full Rive parser.
class RivColorField {
  RivColorField(this.offset, this.typeKey, this.propertyKey, this.argb);

  final int offset;
  final int typeKey;
  final int propertyKey;
  final int argb;
}

class RivBytesField {
  RivBytesField(this.start, this.end, this.dataStart, this.typeKey);

  /// Range of the varuint length + payload.
  final int start;
  final int end;
  final int dataStart;
  final int typeKey;
}

class RivScan {
  RivScan(this.colors, this.blobs);

  final List<RivColorField> colors;
  final List<RivBytesField> blobs;
}

class _Reader {
  _Reader(this.bytes) : data = ByteData.sublistView(bytes);

  final Uint8List bytes;
  final ByteData data;
  int pos = 0;

  bool get done => pos >= bytes.length;

  int varuint() {
    var result = 0;
    var shift = 0;
    while (true) {
      final b = bytes[pos++];
      result |= (b & 0x7f) << shift;
      if (b & 0x80 == 0) return result;
      shift += 7;
    }
  }

  int uint32() {
    final v = data.getUint32(pos, Endian.little);
    pos += 4;
    return v;
  }
}

/// Field types (0 uint, 1 string/bytes, 2 float32, 3 color) for core
/// property keys used by the owl files; the header table only lists extras.
const _coreFieldTypes = '4:1,5:0,7:2,8:2,13:2,14:2,15:2,16:2,17:2,18:2,20:2,'
    '21:2,23:0,24:2,25:2,26:2,32:0,33:2,34:2,35:2,37:3,38:3,39:2,40:0,41:0,'
    '42:2,47:2,48:0,49:0,51:0,53:0,55:1,56:0,57:0,58:2,59:0,60:0,61:0,62:0,'
    '63:2,64:2,65:2,66:2,67:0,68:0,69:0,70:2,79:2,80:2,81:2,82:2,83:2,84:2,'
    '85:2,86:2,87:2,88:3,89:2,90:2,91:2,92:0,95:0,96:2,97:2,98:2,99:2,100:2,'
    '101:2,102:0,103:0,104:2,105:2,106:2,107:2,108:2,109:2,110:0,111:0,112:0,'
    '113:0,114:2,115:2,116:2,117:0,119:0,120:0,121:0,122:0,128:0,129:0,138:1,'
    '149:0,151:0,173:0,174:0,175:0,196:0,197:0,198:0,203:1,206:0,207:2,208:2,'
    '212:1,236:0,296:0,364:0,494:0,498:2,499:2,557:1,566:0,583:0,604:0,608:0,'
    '613:0,614:0,615:0,616:0,617:0,618:0,619:0,620:0,625:0,626:0,632:0,656:0,'
    '706:2';

Map<int, int> _parseCoreTypes() {
  final map = <int, int>{};
  for (final pair in _coreFieldTypes.split(',')) {
    final parts = pair.split(':');
    map[int.parse(parts[0])] = int.parse(parts[1]);
  }
  return map;
}

RivScan scanRiv(Uint8List bytes) {
  final r = _Reader(bytes);
  final magic = String.fromCharCodes(bytes.sublist(0, 4));
  if (magic != 'RIVE') throw FormatException('Not a riv file');
  r.pos = 4;
  r.varuint(); // major
  r.varuint(); // minor
  r.varuint(); // file id

  final keys = <int>[];
  while (true) {
    final k = r.varuint();
    if (k == 0) break;
    keys.add(k);
  }
  final fieldTypes = _parseCoreTypes();
  var current = 0;
  var bit = 8;
  for (final k in keys) {
    if (bit == 8) {
      current = r.uint32();
      bit = 0;
    }
    fieldTypes[k] = (current >> bit) & 3;
    bit += 2;
  }

  final colors = <RivColorField>[];
  final blobs = <RivBytesField>[];
  while (!r.done) {
    final typeKey = r.varuint();
    while (true) {
      final key = r.varuint();
      if (key == 0) break;
      final type = fieldTypes[key];
      if (type == null) {
        throw FormatException('Unknown property key $key at ${r.pos}');
      }
      switch (type) {
        case 0:
          r.varuint();
        case 1:
          final start = r.pos;
          final len = r.varuint();
          final dataStart = r.pos;
          r.pos += len;
          blobs.add(RivBytesField(start, r.pos, dataStart, typeKey));
        case 2:
          r.pos += 4;
        case 3:
          final offset = r.pos;
          colors.add(RivColorField(offset, typeKey, key, r.uint32()));
      }
    }
  }
  return RivScan(colors, blobs);
}

Uint8List encodeVaruint(int value) {
  final out = <int>[];
  var v = value;
  do {
    var b = v & 0x7f;
    v >>= 7;
    if (v != 0) b |= 0x80;
    out.add(b);
  } while (v != 0);
  return Uint8List.fromList(out);
}
