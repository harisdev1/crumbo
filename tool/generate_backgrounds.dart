// Generates 30 kid-friendly SVG home backgrounds (1080x1920).
// Run: dart run tool/generate_backgrounds.dart
import 'dart:io';

void main() {
  final dir = Directory('assets/backgrounds')..createSync(recursive: true);
  for (final entry in _themes.entries) {
    File('${dir.path}/${entry.key}.svg').writeAsStringSync(entry.value);
    stdout.writeln('wrote ${entry.key}.svg');
  }
  stdout.writeln('done ${_themes.length}');
}

String _svg(String body) => '''<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="1080" height="1920" viewBox="0 0 1080 1920">
$body
</svg>
''';

String _sky(String id, String c1, String c2, [String? c3]) {
  final stops = c3 == null
      ? '''
    <stop offset="0%" stop-color="$c1"/>
    <stop offset="100%" stop-color="$c2"/>'''
      : '''
    <stop offset="0%" stop-color="$c1"/>
    <stop offset="55%" stop-color="$c2"/>
    <stop offset="100%" stop-color="$c3"/>''';
  return '''
  <defs>
    <linearGradient id="$id" x1="0" y1="0" x2="0" y2="1">
$stops
    </linearGradient>
  </defs>
  <rect width="1080" height="1920" fill="url(#$id)"/>''';
}

String _cloud(double cx, double cy, double s, String color, [double o = 0.85]) =>
    '''
  <g opacity="$o">
    <ellipse cx="$cx" cy="$cy" rx="${s * 1.1}" ry="${s * 0.55}" fill="$color"/>
    <ellipse cx="${cx - s * 0.55}" cy="${cy + s * 0.08}" rx="${s * 0.7}" ry="${s * 0.45}" fill="$color"/>
    <ellipse cx="${cx + s * 0.55}" cy="${cy + s * 0.05}" rx="${s * 0.75}" ry="${s * 0.48}" fill="$color"/>
    <ellipse cx="$cx" cy="${cy - s * 0.28}" rx="${s * 0.55}" ry="${s * 0.4}" fill="$color"/>
  </g>''';

String _sun(double cx, double cy, double r, {String glow = '#FFF59D', String core = '#FFE082'}) =>
    '''
  <circle cx="$cx" cy="$cy" r="${r * 1.9}" fill="$glow" opacity="0.45"/>
  <circle cx="$cx" cy="$cy" r="${r * 1.35}" fill="$glow" opacity="0.55"/>
  <circle cx="$cx" cy="$cy" r="$r" fill="$core"/>''';

String _moon(double cx, double cy, double r) => '''
  <circle cx="$cx" cy="$cy" r="${r * 1.4}" fill="#E8F0FF" opacity="0.2"/>
  <circle cx="$cx" cy="$cy" r="$r" fill="#F5F7FF"/>
  <circle cx="${cx + r * 0.35}" cy="${cy - r * 0.15}" r="${r * 0.78}" fill="#1A2748"/>''';

String _hill(String d, String color, [double o = 1]) =>
    '  <path d="$d" fill="$color" opacity="$o"/>';

String _stars(String color) {
  final buf = StringBuffer();
  final pts = [
    [120, 180], [260, 90], [420, 150], [580, 70], [740, 130], [900, 100],
    [180, 320], [500, 250], [820, 280], [960, 220], [60, 420], [340, 380],
    [680, 360], [880, 400], [200, 520], [450, 480], [720, 500],
  ];
  for (final p in pts) {
    final r = 2.5 + (p[0] % 5);
    buf.writeln(
        '  <circle cx="${p[0]}" cy="${p[1]}" r="$r" fill="$color" opacity="0.9"/>');
  }
  return buf.toString();
}

final _themes = <String, String>{
  'morning_glow': _svg('''
${_sky('mg', '#FFF6D8', '#FFE8B0', '#FFD8A0')}
${_sun(860, 260, 90)}
${_cloud(180, 280, 70, '#FFFFFF', 0.75)}
${_cloud(480, 180, 55, '#FFFFFF', 0.65)}
${_hill('M0 1280 Q220 1120 480 1220 T1080 1180 L1080 1920 L0 1920 Z', '#A8D98A', 0.7)}
${_hill('M0 1480 Q300 1320 560 1420 T1080 1380 L1080 1920 L0 1920 Z', '#7EC98A')}
  <path d="M-20 1330 Q260 1270 560 1300 Q820 1325 1100 1250" fill="none" stroke="#8B5A2B" stroke-width="44" stroke-linecap="round"/>
  <path d="M-20 1330 Q260 1270 560 1300 Q820 1325 1100 1250" fill="none" stroke="#A8743E" stroke-width="16" stroke-linecap="round" opacity="0.6"/>
  <path d="M760 1312 Q840 1220 930 1200" fill="none" stroke="#8B5A2B" stroke-width="18" stroke-linecap="round"/>
  <path d="M220 1290 Q170 1210 110 1190" fill="none" stroke="#8B5A2B" stroke-width="16" stroke-linecap="round"/>
  <ellipse cx="950" cy="1185" rx="70" ry="30" fill="#7EC850" transform="rotate(-25 950 1185)"/>
  <ellipse cx="885" cy="1175" rx="55" ry="24" fill="#8FD460" transform="rotate(20 885 1175)"/>
  <ellipse cx="1010" cy="1225" rx="60" ry="26" fill="#6BB84A" transform="rotate(10 1010 1225)"/>
  <ellipse cx="95" cy="1175" rx="62" ry="26" fill="#7EC850" transform="rotate(25 95 1175)"/>
  <ellipse cx="150" cy="1165" rx="50" ry="22" fill="#8FD460" transform="rotate(-15 150 1165)"/>
  <ellipse cx="380" cy="1265" rx="48" ry="20" fill="#7EC850" transform="rotate(-30 380 1265)"/>
  <ellipse cx="640" cy="1340" rx="46" ry="20" fill="#6BB84A" transform="rotate(25 640 1340)"/>
  <circle cx="300" cy="420" r="10" fill="#FFFFFF" opacity="0.7"/>
  <circle cx="700" cy="520" r="7" fill="#FFFFFF" opacity="0.6"/>
'''),
  'classic_calm': _svg('''
${_sky('cc', '#7EC8FF', '#B8E4FF', '#FFF0D0')}
${_sun(880, 220, 70)}
${_cloud(160, 240, 80, '#FFFFFF')}
${_cloud(520, 160, 60, '#FFFFFF', 0.8)}
${_cloud(300, 360, 50, '#FFFFFF', 0.7)}
${_hill('M0 1200 Q270 1050 540 1150 T1080 1100 L1080 1920 L0 1920 Z', '#B8E8C8', 0.85)}
${_hill('M0 1450 Q320 1280 600 1400 T1080 1350 L1080 1920 L0 1920 Z', '#8FD4A8')}
  <circle cx="120" cy="820" r="28" fill="#FFB4D6" opacity="0.45"/>
  <circle cx="960" cy="900" r="34" fill="#A8F0C8" opacity="0.4"/>
'''),
  'sleepy_night': _svg('''
${_sky('sn', '#0F1A38', '#1A2A55', '#2A3A68')}
${_stars('#F5F7FF')}
${_moon(820, 280, 85)}
${_cloud(200, 520, 90, '#D8E0F8', 0.35)}
${_cloud(700, 600, 70, '#D8E0F8', 0.28)}
${_hill('M0 1400 Q300 1280 600 1380 T1080 1320 L1080 1920 L0 1920 Z', '#1A2848')}
${_hill('M0 1600 Q280 1500 540 1580 T1080 1540 L1080 1920 L0 1920 Z', '#121E38')}
  <ellipse cx="540" cy="1480" rx="280" ry="70" fill="#F5F7FF" opacity="0.9"/>
  <ellipse cx="420" cy="1460" rx="120" ry="55" fill="#FFFFFF"/>
  <ellipse cx="640" cy="1465" rx="130" ry="58" fill="#FFFFFF"/>
  <ellipse cx="540" cy="1430" rx="100" ry="45" fill="#FFFFFF"/>
  <text x="700" y="1380" font-size="48" fill="#C8D4FF" opacity="0.7" font-family="sans-serif">Zzz</text>
'''),
  'playful_bubbles': _svg('''
${_sky('pb', '#E8D0FF', '#F8C8E8', '#FFE0F0')}
${_cloud(200, 220, 65, '#FFFFFF', 0.7)}
${_cloud(780, 180, 55, '#FFFFFF', 0.6)}
  <circle cx="160" cy="500" r="55" fill="#FFFFFF" opacity="0.35" stroke="#F0A0D0" stroke-width="3"/>
  <circle cx="320" cy="380" r="35" fill="#FFFFFF" opacity="0.4" stroke="#C8A0F0" stroke-width="2"/>
  <circle cx="880" cy="420" r="70" fill="#FFFFFF" opacity="0.3" stroke="#F0B0E0" stroke-width="3"/>
  <circle cx="700" cy="560" r="42" fill="#FFFFFF" opacity="0.35" stroke="#D0B0FF" stroke-width="2"/>
  <circle cx="480" cy="300" r="28" fill="#FFFFFF" opacity="0.45" stroke="#FFB0D0" stroke-width="2"/>
  <circle cx="120" cy="800" r="48" fill="#FFFFFF" opacity="0.3" stroke="#E0A0F0" stroke-width="2"/>
  <circle cx="940" cy="720" r="38" fill="#FFFFFF" opacity="0.35" stroke="#F0C0E0" stroke-width="2"/>
  <circle cx="560" cy="680" r="60" fill="#FFFFFF" opacity="0.28" stroke="#D8A8FF" stroke-width="3"/>
  <circle cx="260" cy="1100" r="45" fill="#FFFFFF" opacity="0.3" stroke="#FFB8D8" stroke-width="2"/>
  <circle cx="820" cy="1050" r="52" fill="#FFFFFF" opacity="0.32" stroke="#C8B0F8" stroke-width="2"/>
${_hill('M0 1500 Q300 1380 560 1480 T1080 1420 L1080 1920 L0 1920 Z', '#F0B8E0', 0.55)}
${_hill('M0 1680 Q280 1580 540 1660 T1080 1620 L1080 1920 L0 1920 Z', '#E8A0D0', 0.7)}
  <path d="M200 900 C210 880 230 880 240 900 C230 920 210 920 200 900 Z" fill="#FF8AB0" opacity="0.7"/>
  <path d="M900 850 C910 830 930 830 940 850 C930 870 910 870 900 850 Z" fill="#D080F0" opacity="0.65"/>
'''),
  'cozy_room': _svg('''
${_sky('cr', '#FFE8C8', '#FFD8A8', '#F0C890')}
  <rect x="0" y="1100" width="1080" height="820" fill="#C89868"/>
  <rect x="0" y="1100" width="1080" height="40" fill="#A87848"/>
  <rect x="80" y="200" width="380" height="520" rx="16" fill="#8EC8E8" stroke="#FFFFFF" stroke-width="14"/>
  <line x1="270" y1="200" x2="270" y2="720" stroke="#FFFFFF" stroke-width="10"/>
  <line x1="80" y1="460" x2="460" y2="460" stroke="#FFFFFF" stroke-width="10"/>
  <rect x="620" y="280" width="360" height="480" rx="12" fill="#8B5A2B"/>
  <rect x="645" y="310" width="140" height="90" rx="6" fill="#E87070"/>
  <rect x="805" y="310" width="150" height="90" rx="6" fill="#70B0E8"/>
  <rect x="645" y="420" width="150" height="90" rx="6" fill="#F0C050"/>
  <rect x="815" y="420" width="140" height="90" rx="6" fill="#80D080"/>
  <rect x="645" y="530" width="140" height="90" rx="6" fill="#C890E0"/>
  <rect x="805" y="530" width="150" height="90" rx="6" fill="#F09060"/>
  <rect x="645" y="640" width="310" height="90" rx="6" fill="#70C8C0"/>
  <ellipse cx="200" cy="1000" rx="70" ry="30" fill="#6BAA5A"/>
  <rect x="175" y="880" width="50" height="120" fill="#8B6A40"/>
  <ellipse cx="200" cy="860" rx="80" ry="55" fill="#5A9850"/>
  <ellipse cx="150" cy="900" rx="45" ry="35" fill="#6BB05A"/>
  <ellipse cx="250" cy="895" rx="50" ry="38" fill="#70B860"/>
  <rect x="0" y="1680" width="1080" height="240" fill="#A07040"/>
  <rect x="0" y="1680" width="1080" height="18" fill="#8A5830"/>
'''),
  'sunset_beach': _svg('''
${_sky('sb', '#FF8A60', '#FFB080', '#FFE0B0')}
${_sun(540, 620, 110, glow: '#FFCC80', core: '#FFD54F')}
${_cloud(180, 280, 60, '#FFE0C8', 0.55)}
${_cloud(860, 240, 50, '#FFE8D0', 0.5)}
${_hill('M0 1100 Q300 1020 540 1080 T1080 1040 L1080 1300 L0 1300 Z', '#F0C090')}
  <rect x="0" y="1280" width="1080" height="640" fill="#4FC3F7"/>
  <path d="M0 1280 Q180 1240 360 1280 T720 1260 T1080 1290 L1080 1380 Q800 1320 540 1360 T0 1340 Z" fill="#81D4FA"/>
  <ellipse cx="200" cy="1500" rx="80" ry="18" fill="#FFFFFF" opacity="0.35"/>
  <ellipse cx="700" cy="1580" rx="100" ry="20" fill="#FFFFFF" opacity="0.3"/>
  <path d="M120 1180 L140 1000 L160 1180 Z" fill="#5D4037"/>
  <ellipse cx="140" cy="980" rx="70" ry="40" fill="#43A047"/>
  <ellipse cx="100" cy="1000" rx="40" ry="28" fill="#66BB6A"/>
  <ellipse cx="180" cy="995" rx="45" ry="30" fill="#4CAF50"/>
'''),
  'under_the_sea': _svg('''
${_sky('us', '#0277BD', '#0288D1', '#4FC3F7')}
  <ellipse cx="200" cy="400" rx="40" ry="18" fill="#81D4FA" opacity="0.4"/>
  <ellipse cx="500" cy="280" rx="55" ry="22" fill="#81D4FA" opacity="0.35"/>
  <ellipse cx="800" cy="450" rx="35" ry="15" fill="#B3E5FC" opacity="0.4"/>
  <ellipse cx="350" cy="600" rx="45" ry="18" fill="#81D4FA" opacity="0.3"/>
  <ellipse cx="900" cy="700" rx="50" ry="20" fill="#B3E5FC" opacity="0.35"/>
  <circle cx="160" cy="900" r="12" fill="#FFF59D" opacity="0.7"/>
  <circle cx="420" cy="1100" r="8" fill="#FFFFFF" opacity="0.5"/>
  <circle cx="780" cy="980" r="10" fill="#FFF59D" opacity="0.6"/>
  <circle cx="600" cy="1300" r="7" fill="#FFFFFF" opacity="0.45"/>
  <path d="M80 1600 Q100 1400 120 1600 Q140 1450 160 1600 Q180 1420 200 1600 Z" fill="#26A69A"/>
  <path d="M240 1650 Q255 1480 270 1650 Q285 1500 300 1650 Z" fill="#00897B"/>
  <path d="M880 1580 Q900 1380 920 1580 Q940 1420 960 1580 Q980 1400 1000 1580 Z" fill="#26A69A"/>
  <ellipse cx="540" cy="1500" rx="90" ry="50" fill="#FF8A65" opacity="0.85"/>
  <circle cx="500" cy="1480" r="12" fill="#5D4037"/>
  <circle cx="580" cy="1480" r="12" fill="#5D4037"/>
${_hill('M0 1700 Q300 1620 540 1680 T1080 1640 L1080 1920 L0 1920 Z', '#FFCC80')}
${_hill('M0 1800 Q280 1740 560 1780 T1080 1760 L1080 1920 L0 1920 Z', '#FFE0B2')}
'''),
  'candy_land': _svg('''
${_sky('cl', '#FFE0F0', '#FFD0E8', '#E8D0FF')}
${_cloud(200, 200, 60, '#FFFFFF', 0.8)}
${_cloud(750, 160, 50, '#FFFFFF', 0.7)}
  <rect x="140" y="900" width="70" height="400" rx="20" fill="#FF80AB"/>
  <ellipse cx="175" cy="880" rx="55" ry="40" fill="#F48FB1"/>
  <rect x="820" y="950" width="60" height="350" rx="18" fill="#80CBC4"/>
  <ellipse cx="850" cy="930" rx="50" ry="35" fill="#4DB6AC"/>
  <circle cx="400" cy="1200" r="90" fill="#FFECB3"/>
  <circle cx="400" cy="1200" r="55" fill="#FFE082"/>
  <circle cx="650" cy="1150" r="70" fill="#E1BEE7"/>
  <circle cx="650" cy="1150" r="40" fill="#CE93D8"/>
${_hill('M0 1450 Q280 1320 540 1420 T1080 1360 L1080 1920 L0 1920 Z', '#F8BBD0', 0.8)}
${_hill('M0 1650 Q300 1550 560 1630 T1080 1580 L1080 1920 L0 1920 Z', '#F48FB1')}
  <circle cx="180" cy="500" r="22" fill="#FF8A80" opacity="0.7"/>
  <circle cx="900" cy="420" r="28" fill="#80D8FF" opacity="0.65"/>
  <circle cx="520" cy="350" r="18" fill="#CCFF90" opacity="0.7"/>
'''),
  'snowy_hills': _svg('''
${_sky('sh', '#B0C4DE', '#D8E8F8', '#F0F6FF')}
${_cloud(200, 260, 70, '#FFFFFF', 0.9)}
${_cloud(600, 180, 55, '#FFFFFF', 0.85)}
${_cloud(900, 300, 60, '#FFFFFF', 0.8)}
  <circle cx="160" cy="500" r="4" fill="#FFFFFF"/>
  <circle cx="300" cy="420" r="3" fill="#FFFFFF"/>
  <circle cx="500" cy="480" r="5" fill="#FFFFFF"/>
  <circle cx="720" cy="400" r="3" fill="#FFFFFF"/>
  <circle cx="880" cy="520" r="4" fill="#FFFFFF"/>
  <circle cx="420" cy="600" r="3" fill="#FFFFFF"/>
  <circle cx="640" cy="560" r="4" fill="#FFFFFF"/>
${_hill('M0 1100 Q250 920 500 1050 T1080 980 L1080 1920 L0 1920 Z', '#E8F0F8')}
${_hill('M0 1400 Q300 1220 560 1360 T1080 1280 L1080 1920 L0 1920 Z', '#F5F9FF')}
  <path d="M200 1300 L230 1100 L260 1300 Z" fill="#5D4037"/>
  <path d="M180 1180 L230 1050 L280 1180 Z" fill="#FFFFFF"/>
  <path d="M190 1120 L230 1020 L270 1120 Z" fill="#F0F4F8"/>
  <path d="M800 1350 L840 1120 L880 1350 Z" fill="#5D4037"/>
  <path d="M770 1220 L840 1080 L910 1220 Z" fill="#FFFFFF"/>
'''),
  'autumn_forest': _svg('''
${_sky('af', '#FFCC80', '#FFE0B2', '#FFF3E0')}
${_sun(200, 280, 55, glow: '#FFECB3', core: '#FFD54F')}
${_cloud(700, 220, 55, '#FFE0C0', 0.6)}
${_hill('M0 1200 Q280 1080 540 1180 T1080 1120 L1080 1920 L0 1920 Z', '#A5D6A7', 0.7)}
${_hill('M0 1450 Q300 1320 560 1420 T1080 1380 L1080 1920 L0 1920 Z', '#81C784')}
  <path d="M150 1500 L170 1100 L190 1500 Z" fill="#6D4C41"/>
  <ellipse cx="170" cy="1080" rx="90" ry="70" fill="#EF6C00"/>
  <ellipse cx="120" cy="1120" rx="50" ry="40" fill="#FF8F00"/>
  <ellipse cx="220" cy="1110" rx="55" ry="42" fill="#E65100"/>
  <path d="M850 1520 L875 1120 L900 1520 Z" fill="#6D4C41"/>
  <ellipse cx="875" cy="1100" rx="100" ry="75" fill="#D84315"/>
  <ellipse cx="820" cy="1140" rx="55" ry="42" fill="#FF7043"/>
  <ellipse cx="930" cy="1130" rx="60" ry="45" fill="#BF360C"/>
  <ellipse cx="400" cy="1380" rx="18" ry="10" fill="#EF6C00" opacity="0.8"/>
  <ellipse cx="600" cy="1280" rx="14" ry="8" fill="#FF8F00" opacity="0.75"/>
  <ellipse cx="500" cy="1480" rx="16" ry="9" fill="#D84315" opacity="0.7"/>
'''),
  'spring_garden': _svg('''
${_sky('sg', '#81D4FA', '#B3E5FC', '#E8F5E9')}
${_sun(860, 200, 65)}
${_cloud(200, 240, 55, '#FFFFFF', 0.8)}
${_hill('M0 1250 Q280 1120 540 1220 T1080 1160 L1080 1920 L0 1920 Z', '#A5D6A7')}
${_hill('M0 1500 Q300 1380 560 1480 T1080 1420 L1080 1920 L0 1920 Z', '#81C784')}
  <circle cx="160" cy="1400" r="28" fill="#F48FB1"/>
  <circle cx="200" cy="1380" r="22" fill="#F06292"/>
  <circle cx="180" cy="1420" r="18" fill="#EC407A"/>
  <rect x="172" y="1420" width="16" height="50" fill="#66BB6A"/>
  <circle cx="400" cy="1350" r="26" fill="#CE93D8"/>
  <circle cx="430" cy="1335" r="20" fill="#BA68C8"/>
  <rect x="410" y="1370" width="14" height="45" fill="#66BB6A"/>
  <circle cx="700" cy="1380" r="30" fill="#FFCC80"/>
  <circle cx="730" cy="1360" r="22" fill="#FFB74D"/>
  <rect x="712" y="1400" width="16" height="50" fill="#66BB6A"/>
  <circle cx="900" cy="1420" r="24" fill="#90CAF9"/>
  <circle cx="925" cy="1405" r="18" fill="#64B5F6"/>
  <rect x="910" y="1440" width="14" height="40" fill="#66BB6A"/>
  <circle cx="550" cy="1550" r="20" fill="#EF9A9A"/>
  <rect x="542" y="1565" width="12" height="35" fill="#66BB6A"/>
'''),
  'rainbow_meadow': _svg('''
${_sky('rm', '#BBDEFB', '#E3F2FD', '#FFF8E1')}
  <path d="M-40 900 A580 580 0 0 1 1120 900" fill="none" stroke="#EF5350" stroke-width="28" opacity="0.7"/>
  <path d="M0 920 A540 540 0 0 1 1080 920" fill="none" stroke="#FFA726" stroke-width="28" opacity="0.7"/>
  <path d="M40 940 A500 500 0 0 1 1040 940" fill="none" stroke="#FFEE58" stroke-width="28" opacity="0.7"/>
  <path d="M80 960 A460 460 0 0 1 1000 960" fill="none" stroke="#66BB6A" stroke-width="28" opacity="0.7"/>
  <path d="M120 980 A420 420 0 0 1 960 980" fill="none" stroke="#42A5F5" stroke-width="28" opacity="0.7"/>
  <path d="M160 1000 A380 380 0 0 1 920 1000" fill="none" stroke="#AB47BC" stroke-width="28" opacity="0.7"/>
${_hill('M0 1300 Q300 1180 560 1280 T1080 1220 L1080 1920 L0 1920 Z', '#A5D6A7')}
${_hill('M0 1550 Q280 1450 540 1530 T1080 1480 L1080 1920 L0 1920 Z', '#81C784')}
  <circle cx="200" cy="1450" r="14" fill="#F48FB1"/>
  <circle cx="350" cy="1400" r="12" fill="#CE93D8"/>
  <circle cx="500" cy="1480" r="13" fill="#FFE082"/>
  <circle cx="700" cy="1420" r="14" fill="#90CAF9"/>
  <circle cx="880" cy="1460" r="12" fill="#FFAB91"/>
'''),
  'starry_space': _svg('''
${_sky('ss', '#0A0A28', '#1A1040', '#2A1860')}
${_stars('#FFFFFF')}
  <circle cx="200" cy="400" r="60" fill="#7E57C2" opacity="0.85"/>
  <circle cx="185" cy="385" r="12" fill="#B39DDB" opacity="0.5"/>
  <circle cx="820" cy="500" r="45" fill="#42A5F5" opacity="0.8"/>
  <ellipse cx="820" cy="500" rx="70" ry="12" fill="#90CAF9" opacity="0.4" transform="rotate(-20 820 500)"/>
  <circle cx="500" cy="300" r="25" fill="#EF5350" opacity="0.75"/>
  <circle cx="900" cy="250" r="8" fill="#FFE082"/>
  <circle cx="150" cy="700" r="6" fill="#80DEEA"/>
  <circle cx="600" cy="600" r="5" fill="#F48FB1"/>
${_hill('M0 1500 Q300 1400 560 1480 T1080 1420 L1080 1920 L0 1920 Z', '#12102A')}
${_hill('M0 1680 Q280 1600 540 1660 T1080 1620 L1080 1920 L0 1920 Z', '#0A0818')}
  <ellipse cx="300" cy="1580" rx="40" ry="18" fill="#5C6BC0" opacity="0.5"/>
  <ellipse cx="750" cy="1620" rx="50" ry="20" fill="#7E57C2" opacity="0.4"/>
'''),
  'desert_dunes': _svg('''
${_sky('dd', '#FFB74D', '#FFCC80', '#FFE0B2')}
${_sun(200, 280, 80, glow: '#FFE082', core: '#FFCA28')}
${_hill('M0 1000 Q200 880 400 980 Q600 1080 800 960 Q950 880 1080 960 L1080 1920 L0 1920 Z', '#FFCC80')}
${_hill('M0 1300 Q250 1180 500 1280 Q750 1400 1080 1260 L1080 1920 L0 1920 Z', '#FFB74D')}
${_hill('M0 1600 Q300 1500 560 1580 T1080 1520 L1080 1920 L0 1920 Z', '#FFA726')}
  <g transform="translate(860,1180)">
    <rect x="-28" y="-260" width="56" height="300" rx="28" fill="#66BB6A"/>
    <path d="M-28 -120 Q-90 -120 -90 -180 L-90 -220" fill="none" stroke="#66BB6A" stroke-width="40" stroke-linecap="round"/>
    <path d="M28 -80 Q90 -80 90 -150 L90 -190" fill="none" stroke="#66BB6A" stroke-width="40" stroke-linecap="round"/>
    <rect x="-8" y="-250" width="10" height="280" rx="5" fill="#81C784" opacity="0.7"/>
    <circle cx="0" cy="-270" r="18" fill="#F48FB1"/>
  </g>
  <g transform="translate(180,1420) scale(0.7)">
    <rect x="-28" y="-260" width="56" height="300" rx="28" fill="#4CAF50"/>
    <path d="M-28 -120 Q-90 -120 -90 -180 L-90 -220" fill="none" stroke="#4CAF50" stroke-width="40" stroke-linecap="round"/>
    <path d="M28 -80 Q90 -80 90 -150 L90 -190" fill="none" stroke="#4CAF50" stroke-width="40" stroke-linecap="round"/>
  </g>
  <ellipse cx="540" cy="1700" rx="60" ry="20" fill="#E0954A" opacity="0.6"/>
'''),
  'jungle_leaves': _svg('''
${_sky('jl', '#81C784', '#A5D6A7', '#C8E6C9')}
  <ellipse cx="-40" cy="200" rx="220" ry="140" fill="#2E7D32" opacity="0.85"/>
  <ellipse cx="1120" cy="180" rx="240" ry="150" fill="#388E3C" opacity="0.8"/>
  <ellipse cx="100" cy="400" rx="180" ry="100" fill="#43A047" opacity="0.75"/>
  <ellipse cx="980" cy="450" rx="200" ry="110" fill="#2E7D32" opacity="0.7"/>
  <ellipse cx="540" cy="120" rx="280" ry="90" fill="#1B5E20" opacity="0.65"/>
${_hill('M0 1300 Q300 1180 560 1280 T1080 1220 L1080 1920 L0 1920 Z', '#66BB6A')}
${_hill('M0 1550 Q280 1450 540 1530 T1080 1480 L1080 1920 L0 1920 Z', '#4CAF50')}
  <circle cx="200" cy="1400" r="20" fill="#EF5350"/>
  <circle cx="800" cy="1350" r="18" fill="#FFCA28"/>
  <circle cx="500" cy="1450" r="16" fill="#AB47BC"/>
  <path d="M150 1600 Q160 1450 170 1600" fill="none" stroke="#1B5E20" stroke-width="8"/>
  <ellipse cx="160" cy="1480" rx="50" ry="25" fill="#2E7D32" transform="rotate(-30 160 1480)"/>
  <path d="M900 1620 Q915 1460 930 1620" fill="none" stroke="#1B5E20" stroke-width="8"/>
  <ellipse cx="915" cy="1500" rx="55" ry="28" fill="#388E3C" transform="rotate(25 915 1500)"/>
'''),
  'cherry_blossom': _svg('''
${_sky('cb', '#FCE4EC', '#F8BBD0', '#FFF0F5')}
${_cloud(300, 220, 50, '#FFFFFF', 0.7)}
${_cloud(800, 180, 45, '#FFFFFF', 0.65)}
  <path d="M200 1600 Q280 900 400 600 Q480 450 520 400" fill="none" stroke="#5D4037" stroke-width="28" stroke-linecap="round"/>
  <path d="M400 800 Q520 700 620 750" fill="none" stroke="#6D4C41" stroke-width="16" stroke-linecap="round"/>
  <path d="M380 1000 Q250 950 180 1000" fill="none" stroke="#6D4C41" stroke-width="14" stroke-linecap="round"/>
  <circle cx="520" cy="380" r="22" fill="#F48FB1"/>
  <circle cx="560" cy="420" r="18" fill="#F06292"/>
  <circle cx="480" cy="430" r="20" fill="#EC407A"/>
  <circle cx="600" cy="360" r="16" fill="#F8BBD0"/>
  <circle cx="620" cy="720" r="18" fill="#F48FB1"/>
  <circle cx="660" cy="760" r="15" fill="#F06292"/>
  <circle cx="200" cy="980" r="16" fill="#F8BBD0"/>
  <circle cx="160" cy="1020" r="14" fill="#F48FB1"/>
  <circle cx="300" cy="500" r="10" fill="#F48FB1" opacity="0.7"/>
  <circle cx="700" cy="550" r="8" fill="#F06292" opacity="0.65"/>
  <circle cx="450" cy="700" r="9" fill="#F8BBD0" opacity="0.7"/>
${_hill('M0 1450 Q300 1350 560 1430 T1080 1380 L1080 1920 L0 1920 Z', '#C8E6C9')}
${_hill('M0 1650 Q280 1560 540 1630 T1080 1580 L1080 1920 L0 1920 Z', '#A5D6A7')}
'''),
  'sunny_picnic': _svg('''
${_sky('sp', '#4FC3F7', '#81D4FA', '#FFF9C4')}
${_sun(180, 240, 75)}
${_cloud(600, 200, 55, '#FFFFFF', 0.8)}
${_cloud(900, 280, 45, '#FFFFFF', 0.7)}
${_hill('M0 1200 Q300 1080 560 1180 T1080 1120 L1080 1920 L0 1920 Z', '#AED581')}
${_hill('M0 1450 Q280 1350 540 1430 T1080 1380 L1080 1920 L0 1920 Z', '#9CCC65')}
  <ellipse cx="540" cy="1500" rx="220" ry="80" fill="#EF5350"/>
  <ellipse cx="540" cy="1500" rx="180" ry="60" fill="#FFEBEE"/>
  <rect x="460" y="1470" width="50" height="35" rx="6" fill="#FFCA28"/>
  <rect x="540" y="1465" width="55" height="40" rx="6" fill="#66BB6A"/>
  <circle cx="640" cy="1490" r="22" fill="#42A5F5"/>
  <circle cx="200" cy="1350" r="16" fill="#F48FB1"/>
  <circle cx="850" cy="1400" r="14" fill="#CE93D8"/>
'''),
  'ice_cream_dream': _svg('''
${_sky('ic', '#F8BBD0', '#E1BEE7', '#BBDEFB')}
${_cloud(200, 240, 55, '#FFFFFF', 0.75)}
${_cloud(800, 200, 50, '#FFFFFF', 0.7)}
  <path d="M280 1400 L340 1100 L400 1400 Z" fill="#FFE0B2"/>
  <ellipse cx="340" cy="1080" rx="70" ry="55" fill="#F48FB1"/>
  <ellipse cx="340" cy="1020" rx="55" ry="45" fill="#CE93D8"/>
  <ellipse cx="340" cy="970" rx="40" ry="35" fill="#80DEEA"/>
  <circle cx="340" cy="930" r="12" fill="#EF5350"/>
  <path d="M700 1450 L770 1120 L840 1450 Z" fill="#FFE0B2"/>
  <ellipse cx="770" cy="1100" rx="75" ry="58" fill="#FFCC80"/>
  <ellipse cx="770" cy="1040" rx="58" ry="48" fill="#A5D6A7"/>
  <ellipse cx="770" cy="990" rx="42" ry="36" fill="#F48FB1"/>
${_hill('M0 1550 Q300 1450 560 1530 T1080 1480 L1080 1920 L0 1920 Z', '#F8BBD0', 0.7)}
${_hill('M0 1720 Q280 1640 540 1700 T1080 1660 L1080 1920 L0 1920 Z', '#F48FB1', 0.8)}
  <circle cx="150" cy="500" r="20" fill="#80DEEA" opacity="0.6"/>
  <circle cx="920" cy="450" r="24" fill="#CE93D8" opacity="0.55"/>
'''),
  'mountain_lake': _svg('''
${_sky('ml', '#90CAF9', '#BBDEFB', '#E3F2FD')}
${_sun(880, 220, 55)}
${_cloud(200, 200, 50, '#FFFFFF', 0.75)}
  <path d="M0 900 L220 500 L440 900 Z" fill="#78909C"/>
  <path d="M180 900 L450 380 L720 900 Z" fill="#607D8B"/>
  <path d="M600 900 L850 520 L1080 900 Z" fill="#78909C"/>
  <path d="M200 560 L220 500 L260 560 Z" fill="#ECEFF1"/>
  <path d="M420 480 L450 380 L500 480 Z" fill="#FAFAFA"/>
  <path d="M820 580 L850 520 L890 580 Z" fill="#ECEFF1"/>
  <rect x="0" y="900" width="1080" height="400" fill="#4FC3F7" opacity="0.75"/>
  <ellipse cx="540" cy="1050" rx="200" ry="30" fill="#81D4FA" opacity="0.35"/>
${_hill('M0 1450 Q300 1380 560 1440 T1080 1400 L1080 1920 L0 1920 Z', '#A5D6A7')}
${_hill('M0 1650 Q280 1580 540 1640 T1080 1600 L1080 1920 L0 1920 Z', '#81C784')}
'''),
  'northern_lights': _svg('''
${_sky('nl', '#0A1628', '#122038', '#1A3050')}
${_stars('#E8F0FF')}
  <path d="M0 400 Q200 200 400 380 Q600 560 800 300 Q950 150 1080 280 L1080 700 Q800 500 540 620 Q280 740 0 560 Z" fill="#69F0AE" opacity="0.35"/>
  <path d="M0 500 Q250 300 500 480 Q750 660 1080 400 L1080 750 Q700 600 400 680 Q150 760 0 620 Z" fill="#40C4FF" opacity="0.3"/>
  <path d="M0 580 Q300 420 600 560 Q850 680 1080 500 L1080 800 Q700 700 350 760 Q100 800 0 700 Z" fill="#E040FB" opacity="0.22"/>
${_moon(200, 220, 50)}
${_hill('M0 1400 Q300 1280 560 1380 T1080 1320 L1080 1920 L0 1920 Z', '#0E1A30')}
${_hill('M0 1620 Q280 1540 540 1600 T1080 1560 L1080 1920 L0 1920 Z', '#081018')}
  <path d="M150 1450 L170 1200 L190 1450 Z" fill="#1A2838"/>
  <path d="M850 1480 L880 1180 L910 1480 Z" fill="#1A2838"/>
'''),
  'rainy_day': _svg('''
${_sky('rd', '#78909C', '#90A4AE', '#B0BEC5')}
${_cloud(200, 280, 90, '#607D8B', 0.85)}
${_cloud(500, 200, 100, '#546E7A', 0.8)}
${_cloud(820, 260, 85, '#607D8B', 0.85)}
${_cloud(350, 360, 70, '#78909C', 0.7)}
  <line x1="150" y1="450" x2="130" y2="550" stroke="#B3E5FC" stroke-width="3" opacity="0.6"/>
  <line x1="220" y1="480" x2="200" y2="580" stroke="#B3E5FC" stroke-width="3" opacity="0.55"/>
  <line x1="400" y1="420" x2="380" y2="530" stroke="#B3E5FC" stroke-width="3" opacity="0.6"/>
  <line x1="480" y1="450" x2="460" y2="560" stroke="#B3E5FC" stroke-width="3" opacity="0.5"/>
  <line x1="600" y1="400" x2="580" y2="510" stroke="#B3E5FC" stroke-width="3" opacity="0.6"/>
  <line x1="750" y1="440" x2="730" y2="550" stroke="#B3E5FC" stroke-width="3" opacity="0.55"/>
  <line x1="880" y1="460" x2="860" y2="570" stroke="#B3E5FC" stroke-width="3" opacity="0.6"/>
  <line x1="320" y1="600" x2="300" y2="700" stroke="#B3E5FC" stroke-width="2" opacity="0.45"/>
  <line x1="700" y1="580" x2="680" y2="680" stroke="#B3E5FC" stroke-width="2" opacity="0.45"/>
${_hill('M0 1350 Q300 1250 560 1330 T1080 1280 L1080 1920 L0 1920 Z', '#78909C')}
${_hill('M0 1580 Q280 1500 540 1560 T1080 1520 L1080 1920 L0 1920 Z', '#607D8B')}
  <g transform="translate(860,1420)">
    <path d="M-120 0 Q-120 -120 0 -120 Q120 -120 120 0 Q90 -25 60 0 Q30 -25 0 0 Q-30 -25 -60 0 Q-90 -25 -120 0 Z" fill="#FFCA28"/>
    <path d="M0 -120 Q-40 -60 -60 0 M0 -120 Q40 -60 60 0" fill="none" stroke="#F9A825" stroke-width="5"/>
    <line x1="0" y1="-120" x2="0" y2="-145" stroke="#5D4037" stroke-width="8" stroke-linecap="round"/>
    <path d="M0 0 L0 110 Q0 135 -22 135" fill="none" stroke="#5D4037" stroke-width="9" stroke-linecap="round"/>
  </g>
  <ellipse cx="300" cy="1700" rx="140" ry="26" fill="#90CAF9" opacity="0.55"/>
  <ellipse cx="760" cy="1780" rx="110" ry="22" fill="#90CAF9" opacity="0.5"/>
  <ellipse cx="300" cy="1700" rx="80" ry="12" fill="none" stroke="#E3F2FD" stroke-width="3" opacity="0.7"/>
'''),
  'pumpkin_patch': _svg('''
${_sky('pp', '#FF8A65', '#FFAB91', '#FFE0B2')}
${_sun(200, 260, 60, glow: '#FFCC80', core: '#FFB74D')}
${_cloud(700, 200, 50, '#FFE0C0', 0.55)}
${_hill('M0 1200 Q300 1100 560 1180 T1080 1120 L1080 1920 L0 1920 Z', '#AED581')}
${_hill('M0 1450 Q280 1360 540 1440 T1080 1380 L1080 1920 L0 1920 Z', '#9CCC65')}
  <ellipse cx="220" cy="1480" rx="80" ry="65" fill="#EF6C00"/>
  <ellipse cx="220" cy="1460" rx="70" ry="50" fill="#FB8C00"/>
  <rect x="210" y="1400" width="20" height="30" rx="4" fill="#5D4037"/>
  <ellipse cx="450" cy="1520" rx="95" ry="75" fill="#E65100"/>
  <ellipse cx="450" cy="1500" rx="82" ry="58" fill="#EF6C00"/>
  <rect x="438" y="1430" width="24" height="35" rx="4" fill="#5D4037"/>
  <ellipse cx="720" cy="1490" rx="70" ry="55" fill="#FF8F00"/>
  <ellipse cx="720" cy="1475" rx="60" ry="42" fill="#FFA726"/>
  <rect x="710" y="1430" width="18" height="28" rx="3" fill="#5D4037"/>
  <ellipse cx="900" cy="1540" rx="55" ry="45" fill="#EF6C00"/>
  <rect x="892" y="1490" width="16" height="25" rx="3" fill="#5D4037"/>
  <path d="M100 1400 L120 1200 L140 1400 Z" fill="#5D4037"/>
  <ellipse cx="120" cy="1180" rx="55" ry="40" fill="#EF6C00" opacity="0.8"/>
'''),
  'cloud_castle': _svg('''
${_sky('cc2', '#90CAF9', '#BBDEFB', '#E3F2FD')}
${_sun(880, 200, 55)}
${_cloud(160, 900, 120, '#FFFFFF', 0.95)}
${_cloud(540, 950, 140, '#FFFFFF', 0.9)}
${_cloud(900, 920, 110, '#FFFFFF', 0.95)}
  <rect x="380" y="520" width="320" height="280" rx="12" fill="#ECEFF1"/>
  <rect x="360" y="480" width="80" height="60" rx="6" fill="#CFD8DC"/>
  <rect x="640" y="480" width="80" height="60" rx="6" fill="#CFD8DC"/>
  <polygon points="500,400 420,480 580,480" fill="#B0BEC5"/>
  <rect x="480" y="560" width="50" height="70" rx="4" fill="#81D4FA"/>
  <rect x="560" y="560" width="50" height="70" rx="4" fill="#81D4FA"/>
  <rect x="500" y="680" width="70" height="120" rx="4" fill="#90A4AE"/>
  <circle cx="420" cy="450" r="18" fill="#F48FB1" opacity="0.7"/>
  <circle cx="660" cy="450" r="18" fill="#F48FB1" opacity="0.7"/>
${_cloud(200, 300, 55, '#FFFFFF', 0.7)}
${_cloud(700, 250, 45, '#FFFFFF', 0.65)}
${_hill('M0 1400 Q300 1320 560 1380 T1080 1340 L1080 1920 L0 1920 Z', '#A5D6A7', 0.6)}
${_hill('M0 1650 Q280 1580 540 1640 T1080 1600 L1080 1920 L0 1920 Z', '#81C784', 0.75)}
'''),
  'tropical_island': _svg('''
${_sky('ti', '#4FC3F7', '#81D4FA', '#B3E5FC')}
${_sun(180, 220, 70)}
${_cloud(700, 180, 50, '#FFFFFF', 0.75)}
  <rect x="0" y="1100" width="1080" height="820" fill="#29B6F6"/>
  <ellipse cx="540" cy="1200" rx="380" ry="120" fill="#FFCC80"/>
  <ellipse cx="540" cy="1180" rx="320" ry="90" fill="#FFE0B2"/>
  <path d="M480 1180 L500 800 L520 1180 Z" fill="#6D4C41"/>
  <ellipse cx="500" cy="780" rx="120" ry="50" fill="#43A047" transform="rotate(-20 500 780)"/>
  <ellipse cx="500" cy="800" rx="110" ry="45" fill="#66BB6A" transform="rotate(30 500 800)"/>
  <ellipse cx="500" cy="760" rx="100" ry="42" fill="#2E7D32" transform="rotate(5 500 760)"/>
  <ellipse cx="200" cy="1400" rx="70" ry="18" fill="#FFFFFF" opacity="0.35"/>
  <ellipse cx="850" cy="1500" rx="90" ry="20" fill="#FFFFFF" opacity="0.3"/>
  <circle cx="700" cy="1300" r="25" fill="#FF8A65" opacity="0.7"/>
'''),
  'lavender_field': _svg('''
${_sky('lf', '#CE93D8', '#E1BEE7', '#F3E5F5')}
${_sun(200, 240, 55, glow: '#E1BEE7', core: '#FFE082')}
${_cloud(700, 200, 50, '#FFFFFF', 0.7)}
${_hill('M0 1100 Q300 1000 560 1080 T1080 1020 L1080 1920 L0 1920 Z', '#B39DDB')}
${_hill('M0 1400 Q280 1300 540 1380 T1080 1320 L1080 1920 L0 1920 Z', '#9575CD')}
  <g opacity="0.85">
    <ellipse cx="120" cy="1200" rx="18" ry="40" fill="#7E57C2"/>
    <ellipse cx="200" cy="1180" rx="16" ry="38" fill="#7E57C2"/>
    <ellipse cx="280" cy="1210" rx="18" ry="42" fill="#673AB7"/>
    <ellipse cx="400" cy="1160" rx="17" ry="40" fill="#7E57C2"/>
    <ellipse cx="500" cy="1190" rx="18" ry="44" fill="#673AB7"/>
    <ellipse cx="620" cy="1170" rx="16" ry="38" fill="#7E57C2"/>
    <ellipse cx="740" cy="1200" rx="18" ry="42" fill="#673AB7"/>
    <ellipse cx="860" cy="1180" rx="17" ry="40" fill="#7E57C2"/>
    <ellipse cx="960" cy="1210" rx="16" ry="38" fill="#673AB7"/>
    <ellipse cx="160" cy="1450" rx="18" ry="42" fill="#5E35B1"/>
    <ellipse cx="320" cy="1480" rx="17" ry="40" fill="#7E57C2"/>
    <ellipse cx="480" cy="1460" rx="18" ry="44" fill="#5E35B1"/>
    <ellipse cx="640" cy="1490" rx="16" ry="38" fill="#7E57C2"/>
    <ellipse cx="800" cy="1470" rx="18" ry="42" fill="#5E35B1"/>
    <ellipse cx="940" cy="1500" rx="17" ry="40" fill="#7E57C2"/>
  </g>
'''),
  'bamboo_grove': _svg('''
${_sky('bg', '#C8E6C9', '#DCEDC8', '#F1F8E9')}
${_cloud(800, 200, 45, '#FFFFFF', 0.65)}
  <rect x="80" y="400" width="36" height="1200" rx="8" fill="#8BC34A"/>
  <rect x="80" y="600" width="36" height="8" fill="#689F38"/>
  <rect x="80" y="850" width="36" height="8" fill="#689F38"/>
  <rect x="80" y="1100" width="36" height="8" fill="#689F38"/>
  <rect x="220" y="300" width="42" height="1300" rx="8" fill="#9CCC65"/>
  <rect x="220" y="500" width="42" height="8" fill="#7CB342"/>
  <rect x="220" y="780" width="42" height="8" fill="#7CB342"/>
  <rect x="220" y="1050" width="42" height="8" fill="#7CB342"/>
  <rect x="400" y="450" width="32" height="1150" rx="8" fill="#8BC34A"/>
  <rect x="400" y="650" width="32" height="8" fill="#689F38"/>
  <rect x="400" y="950" width="32" height="8" fill="#689F38"/>
  <rect x="700" y="280" width="40" height="1320" rx="8" fill="#9CCC65"/>
  <rect x="700" y="480" width="40" height="8" fill="#7CB342"/>
  <rect x="700" y="750" width="40" height="8" fill="#7CB342"/>
  <rect x="700" y="1020" width="40" height="8" fill="#7CB342"/>
  <rect x="880" y="380" width="38" height="1220" rx="8" fill="#8BC34A"/>
  <rect x="880" y="580" width="38" height="8" fill="#689F38"/>
  <rect x="880" y="880" width="38" height="8" fill="#689F38"/>
  <rect x="980" y="500" width="28" height="1100" rx="6" fill="#AED581"/>
  <ellipse cx="100" cy="420" rx="40" ry="18" fill="#689F38" transform="rotate(-40 100 420)"/>
  <ellipse cx="250" cy="320" rx="45" ry="20" fill="#7CB342" transform="rotate(35 250 320)"/>
  <ellipse cx="730" cy="300" rx="50" ry="22" fill="#689F38" transform="rotate(-25 730 300)"/>
${_hill('M0 1600 Q300 1520 560 1580 T1080 1540 L1080 1920 L0 1920 Z', '#AED581')}
'''),
  'cozy_library': _svg('''
${_sky('clib', '#FFE0B2', '#FFCC80', '#FFB74D')}
  <rect x="0" y="0" width="1080" height="1920" fill="#EFEBE9"/>
  <rect x="40" y="100" width="1000" height="900" rx="8" fill="#5D4037"/>
  <rect x="70" y="130" width="200" height="120" rx="6" fill="#EF5350"/>
  <rect x="290" y="130" width="180" height="120" rx="6" fill="#42A5F5"/>
  <rect x="490" y="130" width="220" height="120" rx="6" fill="#66BB6A"/>
  <rect x="730" y="130" width="160" height="120" rx="6" fill="#FFA726"/>
  <rect x="910" y="130" width="100" height="120" rx="6" fill="#AB47BC"/>
  <rect x="70" y="280" width="160" height="120" rx="6" fill="#26A69A"/>
  <rect x="250" y="280" width="210" height="120" rx="6" fill="#EC407A"/>
  <rect x="480" y="280" width="170" height="120" rx="6" fill="#7E57C2"/>
  <rect x="670" y="280" width="200" height="120" rx="6" fill="#FFCA28"/>
  <rect x="890" y="280" width="120" height="120" rx="6" fill="#5C6BC0"/>
  <rect x="70" y="430" width="220" height="120" rx="6" fill="#8D6E63"/>
  <rect x="310" y="430" width="150" height="120" rx="6" fill="#EF5350"/>
  <rect x="480" y="430" width="190" height="120" rx="6" fill="#29B6F6"/>
  <rect x="690" y="430" width="160" height="120" rx="6" fill="#9CCC65"/>
  <rect x="870" y="430" width="140" height="120" rx="6" fill="#FF7043"/>
  <rect x="70" y="580" width="180" height="120" rx="6" fill="#FFA726"/>
  <rect x="270" y="580" width="200" height="120" rx="6" fill="#7E57C2"/>
  <rect x="490" y="580" width="160" height="120" rx="6" fill="#26C6DA"/>
  <rect x="670" y="580" width="210" height="120" rx="6" fill="#EC407A"/>
  <rect x="900" y="580" width="110" height="120" rx="6" fill="#8D6E63"/>
  <rect x="70" y="730" width="250" height="120" rx="6" fill="#5C6BC0"/>
  <rect x="340" y="730" width="170" height="120" rx="6" fill="#66BB6A"/>
  <rect x="530" y="730" width="200" height="120" rx="6" fill="#FFCA28"/>
  <rect x="750" y="730" width="150" height="120" rx="6" fill="#EF5350"/>
  <rect x="920" y="730" width="90" height="120" rx="6" fill="#AB47BC"/>
  <rect x="70" y="880" width="190" height="90" rx="6" fill="#29B6F6"/>
  <rect x="280" y="880" width="220" height="90" rx="6" fill="#FF7043"/>
  <rect x="520" y="880" width="160" height="90" rx="6" fill="#7E57C2"/>
  <rect x="700" y="880" width="180" height="90" rx="6" fill="#66BB6A"/>
  <rect x="900" y="880" width="110" height="90" rx="6" fill="#FFA726"/>
  <rect x="0" y="1100" width="1080" height="820" fill="#A1887F"/>
  <rect x="0" y="1100" width="1080" height="30" fill="#8D6E63"/>
  <ellipse cx="200" cy="1300" rx="80" ry="30" fill="#6D4C41"/>
  <path d="M140 1300 Q170 1150 200 1300 Q230 1150 260 1300 Z" fill="#FF8A65" opacity="0.7"/>
'''),
  'camping_tent': _svg('''
${_sky('ct', '#1A237E', '#283593', '#3949AB')}
${_stars('#FFF9C4')}
${_moon(880, 220, 60)}
${_hill('M0 1200 Q300 1100 560 1180 T1080 1120 L1080 1920 L0 1920 Z', '#1B5E20')}
${_hill('M0 1450 Q280 1360 540 1440 T1080 1380 L1080 1920 L0 1920 Z', '#2E7D32')}
  <polygon points="300,1500 540,950 780,1500" fill="#E53935"/>
  <polygon points="540,950 540,1500 780,1500" fill="#C62828"/>
  <polygon points="480,1500 540,1200 600,1500" fill="#1A237E" opacity="0.7"/>
  <circle cx="200" cy="1400" r="35" fill="#FF8F00" opacity="0.8"/>
  <circle cx="200" cy="1400" r="20" fill="#FFCA28"/>
  <path d="M185 1420 Q200 1480 215 1420" fill="#FF5722" opacity="0.6"/>
  <rect x="150" y="1550" width="50" height="12" rx="3" fill="#5D4037"/>
'''),
  'hot_air_balloons': _svg('''
${_sky('hab', '#FFCC80', '#FFE0B2', '#FFF3E0')}
${_sun(900, 250, 60)}
${_cloud(200, 300, 55, '#FFFFFF', 0.7)}
${_cloud(600, 200, 45, '#FFFFFF', 0.65)}
  <ellipse cx="280" cy="500" rx="90" ry="110" fill="#EF5350"/>
  <ellipse cx="280" cy="500" rx="70" ry="90" fill="#FF7043"/>
  <rect x="255" y="620" width="50" height="35" rx="4" fill="#8D6E63"/>
  <line x1="230" y1="560" x2="255" y2="620" stroke="#5D4037" stroke-width="3"/>
  <line x1="330" y1="560" x2="305" y2="620" stroke="#5D4037" stroke-width="3"/>
  <ellipse cx="700" cy="420" rx="75" ry="95" fill="#42A5F5"/>
  <ellipse cx="700" cy="420" rx="55" ry="75" fill="#64B5F6"/>
  <rect x="678" y="525" width="44" height="30" rx="4" fill="#8D6E63"/>
  <line x1="655" y1="470" x2="678" y2="525" stroke="#5D4037" stroke-width="3"/>
  <line x1="745" y1="470" x2="722" y2="525" stroke="#5D4037" stroke-width="3"/>
  <ellipse cx="500" cy="650" rx="60" ry="75" fill="#AB47BC"/>
  <ellipse cx="500" cy="650" rx="45" ry="58" fill="#CE93D8"/>
  <rect x="482" y="735" width="36" height="26" rx="3" fill="#8D6E63"/>
${_hill('M0 1300 Q300 1200 560 1280 T1080 1220 L1080 1920 L0 1920 Z', '#A5D6A7')}
${_hill('M0 1550 Q280 1460 540 1540 T1080 1480 L1080 1920 L0 1920 Z', '#81C784')}
'''),
  'toy_box_playroom': _svg('''
${_sky('tb', '#FFF3E0', '#FFE0B2', '#FFCC80')}
  <rect x="0" y="1200" width="1080" height="720" fill="#FFCC80"/>
  <rect x="0" y="1200" width="1080" height="40" fill="#FFB74D"/>
  <rect x="80" y="900" width="280" height="200" rx="16" fill="#EF5350"/>
  <rect x="100" y="920" width="240" height="50" rx="8" fill="#FFCDD2"/>
  <circle cx="150" cy="1050" r="25" fill="#FFCA28"/>
  <circle cx="220" cy="1050" r="25" fill="#42A5F5"/>
  <circle cx="290" cy="1050" r="25" fill="#66BB6A"/>
  <rect x="700" y="850" width="260" height="250" rx="12" fill="#7E57C2"/>
  <rect x="720" y="870" width="220" height="60" rx="8" fill="#B39DDB"/>
  <rect x="740" y="960" width="80" height="100" rx="6" fill="#FF7043"/>
  <rect x="850" y="960" width="80" height="100" rx="6" fill="#26C6DA"/>
  <circle cx="500" cy="1100" r="55" fill="#FFA726"/>
  <circle cx="500" cy="1100" r="35" fill="#FFE082"/>
  <rect x="480" y="1145" width="40" height="50" fill="#8D6E63"/>
  <circle cx="200" cy="400" r="30" fill="#F48FB1" opacity="0.5"/>
  <circle cx="850" cy="350" r="35" fill="#80DEEA" opacity="0.5"/>
  <circle cx="500" cy="280" r="25" fill="#C5E1A5" opacity="0.5"/>
  <rect x="400" y="1400" width="120" height="80" rx="10" fill="#42A5F5"/>
  <circle cx="700" cy="1500" r="40" fill="#EF5350"/>
  <polygon points="300,1550 340,1450 380,1550" fill="#66BB6A"/>
'''),
};
