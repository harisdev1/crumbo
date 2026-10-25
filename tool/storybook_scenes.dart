import 'dart:io';

/// Generates the polished, layered SVG scenes used by the home theme catalog.
///
/// The owl is rendered by Flutter above these files, so every scene keeps a
/// quiet landing area around x=540, y=1260 while adding detail at the edges.
void generateStorybookBackgrounds() {
  final directory = Directory('assets/backgrounds')
    ..createSync(recursive: true);
  for (final theme in _themes) {
    File(
      '${directory.path}/${theme.id}.svg',
    ).writeAsStringSync(_svg(theme.id, _scene(theme)));
    stdout.writeln('wrote ${theme.id}.svg');
  }
  final balloons = _theme('hot_air_balloons');
  File(
    '${directory.path}/hot_air_balloons_sky.svg',
  ).writeAsStringSync(_svg(balloons.id, _balloonLookoutSky(balloons)));
  stdout.writeln('done ${_themes.length} storybook scenes');
}

class _ThemeArt {
  const _ThemeArt(this.id, this.top, this.bottom, this.ground, this.accent);

  final String id;
  final String top;
  final String bottom;
  final String ground;
  final String accent;
}

const _themes = <_ThemeArt>[
  _ThemeArt('morning_glow', '#FFF7CE', '#FFD58A', '#79C98B', '#F4A261'),
  _ThemeArt('classic_calm', '#DDF4FF', '#9DD9F3', '#C99B72', '#5FA8D3'),
  _ThemeArt('sleepy_night', '#121B3E', '#384D82', '#26345C', '#FFD37A'),
  _ThemeArt('playful_bubbles', '#F6E9FF', '#C7EFFF', '#9BD7DD', '#D182D4'),
  _ThemeArt('cozy_room', '#FFF0D6', '#E9BE8C', '#A86F4C', '#E47B5F'),
  _ThemeArt('sunset_beach', '#FFC98F', '#F58D7A', '#70BED0', '#FFD36E'),
  _ThemeArt('under_the_sea', '#72DDE2', '#126B91', '#E8C77C', '#FF8C70'),
  _ThemeArt('candy_land', '#FFEAF5', '#F6B8D5', '#F6D58A', '#D56DB0'),
  _ThemeArt('snowy_hills', '#DDF2FF', '#A8CCE8', '#F5FAFF', '#7BA6CE'),
  _ThemeArt('autumn_forest', '#FFD6A0', '#D6784D', '#92714C', '#C9553D'),
  _ThemeArt('spring_garden', '#E7F8FF', '#BDE8C3', '#7CBF83', '#F08BAA'),
  _ThemeArt('rainbow_meadow', '#DDF5FF', '#C8E9AD', '#79C982', '#9B7ED9'),
  _ThemeArt('starry_space', '#171236', '#382C72', '#25214D', '#7DE0F2'),
  _ThemeArt('desert_dunes', '#FFE0A3', '#ECA46D', '#DBA85C', '#4FAF8F'),
  _ThemeArt('jungle_leaves', '#D9F4CB', '#62AD75', '#397C52', '#F0C75E'),
  _ThemeArt('cherry_blossom', '#FFE8F0', '#F3B7C8', '#8BB68A', '#E8719B'),
  _ThemeArt('sunny_picnic', '#E1F4FF', '#AEDCB4', '#6FBE79', '#E65B55'),
  _ThemeArt('ice_cream_dream', '#FFF0F8', '#C9E7F4', '#E9B98E', '#F18BB5'),
  _ThemeArt('mountain_lake', '#DDF3FF', '#87BBD9', '#57949B', '#6C88C4'),
  _ThemeArt('northern_lights', '#101D38', '#243D59', '#183D42', '#63E0B2'),
  _ThemeArt('rainy_day', '#D7E2EA', '#8299AA', '#8A6E59', '#E2A84A'),
  _ThemeArt('pumpkin_patch', '#FFD2A0', '#D97B55', '#759352', '#E86D32'),
  _ThemeArt('cloud_castle', '#DDF4FF', '#A7CDF2', '#E9D7B8', '#9B83D4'),
  _ThemeArt('tropical_island', '#D8F7FF', '#76D4D5', '#F0D28C', '#EA765E'),
  _ThemeArt('lavender_field', '#F0E8FF', '#C5B2DF', '#8973A5', '#B58CD2'),
  _ThemeArt('bamboo_grove', '#E5F5D8', '#8AC792', '#608A57', '#D9A44A'),
  _ThemeArt('cozy_library', '#F4DFC2', '#B67B58', '#80543F', '#D2A352'),
  _ThemeArt('camping_tent', '#142746', '#36506B', '#25533F', '#F39B52'),
  _ThemeArt('hot_air_balloons', '#FFE4B8', '#F5A97D', '#80B98A', '#D95757'),
  _ThemeArt('toy_box_playroom', '#FFF2D9', '#E8C8A4', '#B77D58', '#4CA7C9'),
];

String _svg(String id, String body) =>
    '''<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="1080" height="1920" viewBox="0 0 1080 1920">
  <defs>
    <linearGradient id="${id}_sky" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="${_theme(id).top}"/>
      <stop offset="1" stop-color="${_theme(id).bottom}"/>
    </linearGradient>
    <linearGradient id="${id}_shine" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#FFFFFF" stop-opacity=".45"/>
      <stop offset=".55" stop-color="#FFFFFF" stop-opacity=".05"/>
      <stop offset="1" stop-color="#1E2440" stop-opacity=".12"/>
    </linearGradient>
    <radialGradient id="${id}_glow">
      <stop offset="0" stop-color="#FFFFFF" stop-opacity=".72"/>
      <stop offset="1" stop-color="#FFFFFF" stop-opacity="0"/>
    </radialGradient>
    <pattern id="${id}_grain" width="46" height="46" patternUnits="userSpaceOnUse">
      <circle cx="8" cy="10" r="1.3" fill="#FFFFFF" opacity=".12"/>
      <circle cx="33" cy="29" r="1" fill="#24304A" opacity=".06"/>
      <path d="M4 36 Q13 31 22 36" fill="none" stroke="#FFFFFF" stroke-width="1" opacity=".07"/>
    </pattern>
  </defs>
$body
  <rect width="1080" height="1920" fill="url(#${id}_grain)" opacity=".55"/>
  <path d="M0 0 H1080 V110 Q820 70 540 105 T0 100 Z" fill="#FFFFFF" opacity=".06"/>
</svg>
''';

_ThemeArt _theme(String id) => _themes.firstWhere((theme) => theme.id == id);

String _scene(_ThemeArt t) => switch (t.id) {
  'morning_glow' => _morning(t),
  'classic_calm' => _lounge(t),
  'sleepy_night' => _bedroom(t),
  'playful_bubbles' => _bathroom(t),
  'cozy_room' => _cozyRoom(t),
  'sunset_beach' => _beach(t),
  'under_the_sea' => _reef(t),
  'candy_land' => _candyCafe(t),
  'snowy_hills' => _snowVillage(t),
  'autumn_forest' => _autumn(t),
  'spring_garden' => _springGarden(t),
  'rainbow_meadow' => _rainbowGarden(t),
  'starry_space' => _observatory(t),
  'desert_dunes' => _desertCamp(t),
  'jungle_leaves' => _treeHouse(t),
  'cherry_blossom' => _cherryBridge(t),
  'sunny_picnic' => _picnic(t),
  'ice_cream_dream' => _iceCreamShop(t),
  'mountain_lake' => _mountainDock(t),
  'northern_lights' => _auroraCabin(t),
  'rainy_day' => _rainyNook(t),
  'pumpkin_patch' => _pumpkinFarm(t),
  'cloud_castle' => _cloudPalace(t),
  'tropical_island' => _tropicalDeck(t),
  'lavender_field' => _lavenderCottage(t),
  'bamboo_grove' => _teaGarden(t),
  'cozy_library' => _library(t),
  'camping_tent' => _camp(t),
  'hot_air_balloons' => _balloonLookout(t),
  'toy_box_playroom' => _playroom(t),
  _ => _outdoor(t),
};

String _sky(_ThemeArt t) =>
    '<rect width="1080" height="1920" fill="url(#${t.id}_sky)"/>';

String _outdoor(_ThemeArt t) =>
    '''
${_sky(t)}
${_cloud(155, 310, .8)}${_cloud(810, 240, .58)}
<path d="M0 1030 Q240 860 480 1010 T1080 930 V1920 H0Z" fill="${t.ground}" opacity=".42"/>
<path d="M0 1250 Q280 1110 570 1230 T1080 1170 V1920 H0Z" fill="${t.ground}"/>
<path d="M0 1530 Q300 1390 610 1510 T1080 1450 V1920 H0Z" fill="#FFFFFF" opacity=".12"/>
''';

String _room(_ThemeArt t, {String floor = '#9C6B4D'}) =>
    '''
${_sky(t)}
<rect y="1050" width="1080" height="870" fill="$floor"/>
<path d="M0 1050 H1080" stroke="#6D4938" stroke-width="34"/>
<path d="M0 1240 H1080 M0 1430 H1080 M0 1620 H1080 M0 1810 H1080"
      stroke="#FFFFFF" stroke-width="5" opacity=".1"/>
<path d="M180 1050 L120 1920 M460 1050 L440 1920 M740 1050 L780 1920 M960 1050 L1060 1920"
      stroke="#5E3D31" stroke-width="5" opacity=".26"/>
<path d="M0 1040 H1080" stroke="#FFF4E4" stroke-width="22" opacity=".86"/>
${_rug(t.accent)}
''';

String _cloud(double x, double y, double s) =>
    '''
<g transform="translate($x $y) scale($s)">
  <path d="M-120 24 C-126-22-88-52-48-40 C-28-90 46-96 70-42 C118-48 148-12 132 30
           C112 54-92 58-120 24Z" fill="#C7D2E2" opacity=".22"/>
  <path d="M-126 10 C-126-28-91-55-54-44 C-30-102 49-102 74-45
           C119-48 146-18 136 18 C124 48-105 52-126 10Z" fill="#FFFFFF" opacity=".88"/>
  <path d="M-82-12 C-48-50 21-60 74-24" fill="none" stroke="#FFFFFF" stroke-width="13" opacity=".6"/>
</g>''';

String _rug(String color) =>
    '''
<ellipse cx="540" cy="1510" rx="390" ry="165" fill="#4D3540" opacity=".18"/>
<ellipse cx="540" cy="1478" rx="380" ry="150" fill="$color"/>
<ellipse cx="540" cy="1478" rx="326" ry="112" fill="none" stroke="#FFFFFF" stroke-width="12" opacity=".3"/>
<path d="M250 1478 Q540 1360 830 1478 Q540 1595 250 1478Z" fill="#FFFFFF" opacity=".11"/>
''';

String _window({bool night = false, bool rain = false}) =>
    '''
<g>
  <rect x="90" y="220" width="340" height="500" rx="34" fill="#6E5045" opacity=".25"/>
  <rect x="105" y="205" width="340" height="500" rx="30" fill="#FFF8E8"/>
  <rect x="132" y="232" width="286" height="446" rx="18" fill="${night ? '#23365F' : '#8ED5F0'}"/>
  ${night ? '<circle cx="330" cy="330" r="52" fill="#FFE9A8"/><circle cx="351" cy="312" r="48" fill="#23365F"/>' : '<circle cx="329" cy="330" r="48" fill="#FFE59A" opacity=".8"/>'}
  <path d="M275 232 V678 M132 455 H418" stroke="#FFF8E8" stroke-width="18"/>
  ${rain ? '<path d="M170 270 l-24 64 M230 285 l-25 72 M350 255 l-22 64 M380 450 l-22 64 M175 500 l-20 58" stroke="#DDF5FF" stroke-width="8" stroke-linecap="round" opacity=".75"/>' : ''}
  <path d="M110 705 H440" stroke="#7D5948" stroke-width="30" stroke-linecap="round"/>
</g>''';

String _sofa(String main, String dark) =>
    '''
<g>
  <ellipse cx="540" cy="1420" rx="360" ry="72" fill="#3B2C3C" opacity=".22"/>
  <rect x="242" y="1000" width="596" height="390" rx="115" fill="$dark"/>
  <rect x="267" y="1028" width="546" height="300" rx="96" fill="$main"/>
  <rect x="196" y="1170" width="160" height="245" rx="74" fill="$dark"/>
  <rect x="724" y="1170" width="160" height="245" rx="74" fill="$dark"/>
  <rect x="285" y="1220" width="510" height="190" rx="70" fill="$main"/>
  <path d="M540 1040 V1218 M302 1228 Q540 1280 778 1228" fill="none" stroke="#FFFFFF" stroke-width="10" opacity=".18"/>
  <rect x="280" y="1370" width="42" height="90" rx="16" fill="#674A3B"/>
  <rect x="758" y="1370" width="42" height="90" rx="16" fill="#674A3B"/>
</g>''';

String _shelf(String wood) =>
    '''
<g>
  <rect x="760" y="300" width="250" height="650" rx="24" fill="#4F382F" opacity=".2"/>
  <rect x="740" y="280" width="250" height="650" rx="22" fill="$wood"/>
  <path d="M750 470 H980 M750 650 H980 M750 830 H980" stroke="#5B3D32" stroke-width="22"/>
  <g fill="#F0C45A"><rect x="776" y="350" width="34" height="100" rx="8"/><rect x="818" y="330" width="46" height="120" rx="8"/></g>
  <g fill="#77B9B4"><rect x="875" y="365" width="38" height="85" rx="8"/><rect x="920" y="345" width="34" height="105" rx="8"/></g>
  <g fill="#D97878"><rect x="780" y="540" width="44" height="90" rx="8"/><rect x="832" y="515" width="36" height="115" rx="8"/></g>
  <path d="M900 610 q35-75 70 0Z" fill="#83A85A"/>
</g>''';

String _lamp(double x, double y, String color) =>
    '''
<g transform="translate($x $y)">
  <ellipse cx="0" cy="8" rx="135" ry="155" fill="#FFE9A5" opacity=".16"/>
  <path d="M-68 0 Q0-70 68 0 L48 105 H-48Z" fill="$color"/>
  <path d="M-45 12 Q0-35 45 12" fill="none" stroke="#FFFFFF" stroke-width="10" opacity=".4"/>
  <rect x="-8" y="102" width="16" height="190" rx="8" fill="#6B5144"/>
  <ellipse cy="298" rx="76" ry="20" fill="#6B5144"/>
</g>''';

String _flowers(String colors, {int y = 1330}) =>
    '''
<g transform="translate(0 $y)">
  <path d="M0 90 Q250 5 510 80 T1080 55 V590 H0Z" fill="#57945C" opacity=".48"/>
  ${List.generate(12, (i) {
      final x = 55 + i * 89;
      final yy = 45 + (i % 3) * 28;
      final color = colors.split(',')[i % colors.split(',').length];
      return '<path d="M$x ${yy + 45} v-42" stroke="#3E7B4B" stroke-width="8"/><circle cx="$x" cy="$yy" r="17" fill="$color"/><circle cx="$x" cy="$yy" r="6" fill="#FFE388"/>';
    }).join()}
</g>''';

String _branch() => '''
<g>
  <path d="M-40 1375 Q220 1260 475 1312 Q720 1364 1120 1235" fill="none" stroke="#3F2A24" stroke-width="78" stroke-linecap="round"/>
  <path d="M-40 1356 Q220 1248 475 1298 Q720 1345 1120 1215" fill="none" stroke="#815035" stroke-width="61" stroke-linecap="round"/>
  <path d="M0 1344 Q255 1260 492 1305 M540 1314 Q790 1324 1065 1233" fill="none" stroke="#B77A4D" stroke-width="14" stroke-linecap="round" opacity=".75"/>
  <path d="M205 1280 Q135 1170 55 1150 M820 1292 Q900 1145 1020 1128" fill="none" stroke="#68422F" stroke-width="28" stroke-linecap="round"/>
  <g fill="#69AE5E">
    <ellipse cx="60" cy="1130" rx="84" ry="38" transform="rotate(18 60 1130)"/>
    <ellipse cx="145" cy="1178" rx="74" ry="32" transform="rotate(-22 145 1178)"/>
    <ellipse cx="930" cy="1135" rx="84" ry="38" transform="rotate(-18 930 1135)"/>
    <ellipse cx="1025" cy="1105" rx="78" ry="34" transform="rotate(21 1025 1105)"/>
    <ellipse cx="340" cy="1256" rx="56" ry="25" transform="rotate(-18 340 1256)"/>
  </g>
  <ellipse cx="540" cy="1315" rx="170" ry="30" fill="#281D20" opacity=".2"/>
</g>''';

String _morning(_ThemeArt t) =>
    '''
${_outdoor(t)}
<circle cx="875" cy="260" r="180" fill="url(#${t.id}_glow)"/>
<circle cx="875" cy="260" r="82" fill="#FFD36B"/>
${_cloud(155, 330, .72)}
<path d="M70 1080 Q180 850 285 1080" fill="#5D9A5E"/>
${_flowers('#F18FA8,#FFCC62,#A58BDE', y: 1420)}
${_branch()}
''';

String _lounge(_ThemeArt t) =>
    '''
${_room(t, floor: '#B88761')}
${_window()}
${_shelf('#8E664C')}
${_sofa('#73B6CF', '#4D8EA9')}
${_lamp(890, 980, '#F6C65D')}
<path d="M70 1020 q65-180 130 0" fill="#79A867"/><rect x="118" y="990" width="65" height="75" rx="12" fill="#D57A58"/>
''';

String _bedroom(_ThemeArt t) =>
    '''
${_room(t, floor: '#56486A')}
${_window(night: true)}
<circle cx="790" cy="380" r="175" fill="url(#${t.id}_glow)" opacity=".38"/>
<g><rect x="655" y="820" width="350" height="510" rx="62" fill="#7B71AA"/><rect x="682" y="855" width="296" height="200" rx="55" fill="#B7ACD8"/><path d="M645 1110 H1018 V1390 H645Z" fill="#6E659B"/><path d="M670 1128 Q830 1040 990 1130 V1355 H670Z" fill="#9A8FCA"/></g>
${_rug('#6B5CA5')}
${_lamp(150, 900, '#E5B6C9')}
<g fill="#FFF0AD"><circle cx="580" cy="270" r="8"/><circle cx="720" cy="180" r="5"/><circle cx="940" cy="560" r="7"/></g>
''';

String _bathroom(_ThemeArt t) =>
    '''
${_room(t, floor: '#8CCDD2')}
<path d="M0 0 H1080 V1040 H0Z" fill="#E9F7F7" opacity=".58"/>
<path d="M0 310 H1080 M0 610 H1080 M270 0 V1040 M540 0 V1040 M810 0 V1040" stroke="#FFFFFF" stroke-width="10" opacity=".35"/>
<ellipse cx="540" cy="1320" rx="390" ry="180" fill="#5C8EA0" opacity=".22"/>
<path d="M195 1110 Q540 1000 885 1110 L830 1450 Q540 1550 250 1450Z" fill="#FFFFFF"/>
<path d="M235 1120 Q540 1040 845 1120 Q540 1290 235 1120Z" fill="#83DAE4"/>
<g fill="#FFFFFF" opacity=".84"><circle cx="290" cy="1050" r="54"/><circle cx="380" cy="1080" r="72"/><circle cx="690" cy="1060" r="65"/><circle cx="790" cy="1090" r="48"/></g>
<g stroke="#B38BD1" stroke-width="8" fill="none"><circle cx="160" cy="650" r="58"/><circle cx="880" cy="500" r="76"/><circle cx="760" cy="710" r="34"/></g>
''';

String _cozyRoom(_ThemeArt t) =>
    '''
${_room(t, floor: '#9D694C')}
${_window()}
${_sofa('#D97B68', '#A8574F')}
<g><rect x="760" y="720" width="265" height="390" rx="24" fill="#6D4838"/><rect x="792" y="770" width="202" height="260" rx="90" fill="#2E2730"/><path d="M850 1010 Q790 915 870 845 Q885 930 925 875 Q980 965 920 1025Z" fill="#F08A46"/><path d="M865 1010 Q842 947 886 905 Q896 958 922 930 Q946 982 915 1020Z" fill="#FFD066"/></g>
${_lamp(130, 935, '#E8B95E')}
''';

String _beach(_ThemeArt t) =>
    '''
${_sky(t)}
<circle cx="860" cy="370" r="155" fill="url(#${t.id}_glow)"/><circle cx="860" cy="370" r="82" fill="#FFE07A"/>
<path d="M0 850 Q280 790 540 850 T1080 820 V1500 H0Z" fill="#6FC3D3"/>
<path d="M0 980 Q260 920 510 980 T1080 950" fill="none" stroke="#D8FAF8" stroke-width="24" opacity=".75"/>
<path d="M0 1170 Q310 1030 600 1140 T1080 1080 V1920 H0Z" fill="#F0D28A"/>
<path d="M0 1460 L1080 1360 V1920 H0Z" fill="#A96F4B"/><path d="M0 1495 L1080 1395" stroke="#E7BA7A" stroke-width="28"/>
<g transform="translate(120 1060)"><path d="M0 210 Q40 15 170-40" stroke="#76513B" stroke-width="35" fill="none"/><path d="M160-45 q-130-120-170-10 q110 0 170 10M165-45 q130-100 175 0 q-110-5-175 0" fill="#4DAA72"/></g>
''';

String _reef(_ThemeArt t) =>
    '''
${_sky(t)}
<path d="M0 290 Q270 240 540 295 T1080 280" fill="none" stroke="#D9FFFF" stroke-width="24" opacity=".4"/>
<path d="M0 350 Q280 310 580 355 T1080 340" fill="none" stroke="#FFFFFF" stroke-width="10" opacity=".22"/>
<path d="M0 1350 Q300 1230 550 1325 T1080 1260 V1920 H0Z" fill="#E7C47D"/>
<path d="M60 1360 q60-230 120 0 M130 1390 q80-300 160 0 M900 1390 q55-250 110 0" fill="none" stroke="#E86F69" stroke-width="28" stroke-linecap="round"/>
<g fill="#F3A45B"><path d="M90 1510 q80-170 160 0 q-80-75-160 0Z"/><path d="M800 1470 q95-190 190 0 q-95-80-190 0Z"/></g>
<g fill="#A681CF"><circle cx="190" cy="1240" r="30"/><circle cx="245" cy="1190" r="18"/><circle cx="890" cy="1170" r="38"/></g>
<path d="M0 1640 Q300 1530 600 1630 T1080 1580" fill="none" stroke="#C39B61" stroke-width="26" opacity=".55"/>
''';

String _candyCafe(_ThemeArt t) =>
    '''
${_room(t, floor: '#D8A879')}
<path d="M0 0 H1080 V1040 H0Z" fill="#FFF2F7" opacity=".7"/>
<path d="M0 240 H1080 M0 520 H1080 M0 800 H1080" stroke="#F6C8DA" stroke-width="16" opacity=".65"/>
<g><path d="M55 450 Q190 280 325 450 V940 H55Z" fill="#D978A6"/><path d="M75 455 Q190 325 305 455" fill="none" stroke="#FFF4FB" stroke-width="40"/><rect x="100" y="550" width="180" height="280" rx="30" fill="#FFE8F2"/><g fill="#F8B84E"><circle cx="145" cy="625" r="30"/><circle cx="235" cy="700" r="36"/></g></g>
<g><rect x="745" y="390" width="250" height="520" rx="32" fill="#79B9C4"/><path d="M755 520 H985 M755 680 H985" stroke="#E9FFFF" stroke-width="18"/><g fill="#F3A4BF"><circle cx="810" cy="470" r="38"/><circle cx="910" cy="610" r="42"/><circle cx="825" cy="770" r="35"/></g></g>
<ellipse cx="540" cy="1370" rx="290" ry="80" fill="#5D4050" opacity=".16"/><rect x="310" y="1180" width="460" height="180" rx="70" fill="#F5D074"/><path d="M380 1190 v-130 M700 1190 v-130" stroke="#8A6551" stroke-width="28"/>
''';

String _snowVillage(_ThemeArt t) =>
    '''
${_sky(t)}
${_cloud(180, 300, .68)}
<path d="M0 1000 L230 620 L420 1000 L650 520 L980 1010 L1080 910 V1500 H0Z" fill="#7598B8"/>
<path d="M120 820 L230 620 L340 820 L265 790 L225 735 L188 795Z M510 750 L650 520 L790 750 L700 710 L650 630 L610 710Z" fill="#F8FCFF"/>
<path d="M0 1210 Q290 1050 560 1160 T1080 1110 V1920 H0Z" fill="#EDF7FF"/>
<g transform="translate(70 970)"><rect width="260" height="270" fill="#B46F5B"/><path d="M-30 20 L130-115 L290 20Z" fill="#744B46"/><path d="M-42 10 Q130-45 302 10" stroke="#F8FCFF" stroke-width="45" fill="none"/><rect x="95" y="130" width="70" height="140" fill="#68433C"/><rect x="25" y="70" width="55" height="55" fill="#FFEAA2"/></g>
<g transform="translate(810 1040) scale(.72)"><rect width="260" height="270" fill="#6E91B2"/><path d="M-30 20 L130-115 L290 20Z" fill="#4C607A"/><path d="M-42 10 Q130-45 302 10" stroke="#FFFFFF" stroke-width="45" fill="none"/></g>
<ellipse cx="540" cy="1370" rx="235" ry="45" fill="#89AAC4" opacity=".25"/>
''';

String _autumn(_ThemeArt t) =>
    '''
${_outdoor(t)}
<g transform="translate(90 700)"><path d="M75 650 Q85 240 130 0 Q170 300 160 650" fill="#6D4935"/><g fill="#D8613F"><circle cx="20" cy="50" r="105"/><circle cx="150" cy="5" r="130"/><circle cx="260" cy="90" r="105"/></g><g fill="#F2A13F"><circle cx="80" cy="-40" r="75"/><circle cx="225" cy="15" r="85"/></g></g>
<g transform="translate(820 760) scale(.8)"><path d="M75 650 Q85 240 130 0 Q170 300 160 650" fill="#69442F"/><g fill="#C8523E"><circle cx="20" cy="50" r="105"/><circle cx="150" cy="5" r="130"/><circle cx="260" cy="90" r="105"/></g></g>
${_branch()}
''';

String _springGarden(_ThemeArt t) =>
    '''
${_outdoor(t)}
${_cloud(165, 300, .65)}
<g transform="translate(95 690)"><path d="M0 500 V80 H260 V500 M-30 80 Q130-80 290 80Z" fill="none" stroke="#F6F0DF" stroke-width="34"/><path d="M30 170 H230 M30 290 H230" stroke="#F6F0DF" stroke-width="18"/></g>
<g transform="translate(820 650)"><path d="M0 620 Q45 260 120 0 Q195 260 240 620" fill="#7A573D"/><g fill="#F6A8BC"><circle cx="30" cy="80" r="90"/><circle cx="135" cy="15" r="120"/><circle cx="235" cy="95" r="95"/></g></g>
${_flowers('#F08BAA,#F9C95C,#9E8BD7,#FFFFFF', y: 1260)}
<ellipse cx="540" cy="1350" rx="225" ry="42" fill="#385D44" opacity=".17"/>
''';

String _rainbowGarden(_ThemeArt t) =>
    '''
${_outdoor(t)}
<g fill="none" stroke-linecap="round" opacity=".82">
<path d="M90 940 Q540 300 990 940" stroke="#EB6B73" stroke-width="70"/>
<path d="M140 940 Q540 390 940 940" stroke="#F5AD52" stroke-width="64"/>
<path d="M195 940 Q540 480 885 940" stroke="#F6DA65" stroke-width="58"/>
<path d="M245 940 Q540 570 835 940" stroke="#69BE79" stroke-width="52"/>
<path d="M295 940 Q540 660 785 940" stroke="#67A9D8" stroke-width="46"/>
</g>
${_cloud(120, 930, .72)}${_cloud(910, 930, .72)}
${_flowers('#F078A4,#F4CB57,#8D78CF,#FFFFFF', y: 1250)}
<path d="M320 1350 Q540 1250 760 1350" fill="none" stroke="#E9D39A" stroke-width="70" stroke-linecap="round"/>
''';

String _observatory(_ThemeArt t) =>
    '''
${_sky(t)}
<circle cx="820" cy="300" r="170" fill="url(#${t.id}_glow)" opacity=".32"/>
<g fill="#FFFFFF"><circle cx="130" cy="260" r="5"/><circle cx="250" cy="430" r="8"/><circle cx="510" cy="205" r="5"/><circle cx="710" cy="520" r="7"/><circle cx="930" cy="620" r="5"/></g>
<path d="M0 1290 Q260 1100 540 1240 T1080 1160 V1920 H0Z" fill="#28224C"/>
<g transform="translate(730 770) rotate(-16)"><rect x="0" y="0" width="250" height="110" rx="55" fill="#6D78A6"/><circle cx="225" cy="55" r="72" fill="#8EDCF0"/><rect x="95" y="100" width="45" height="330" fill="#4A4968"/><path d="M40 440 L115 290 L190 440" fill="none" stroke="#4A4968" stroke-width="26"/></g>
<g><path d="M0 1370 Q540 1250 1080 1370 V1920 H0Z" fill="#1D193E"/><path d="M320 1370 A220 220 0 0 1 760 1370Z" fill="#6B6396"/><path d="M355 1370 A185 185 0 0 1 725 1370Z" fill="#28224C"/></g>
<ellipse cx="540" cy="1390" rx="220" ry="35" fill="#090818" opacity=".3"/>
''';

String _desertCamp(_ThemeArt t) =>
    '''
${_sky(t)}
<circle cx="840" cy="300" r="130" fill="#FFE08B"/><circle cx="840" cy="300" r="220" fill="url(#${t.id}_glow)"/>
<path d="M0 930 Q260 760 560 940 T1080 850 V1920 H0Z" fill="#E3B768"/>
<path d="M0 1220 Q330 1020 650 1190 T1080 1100 V1920 H0Z" fill="#CD9456"/>
<g transform="translate(90 850)"><path d="M0 500 L230 40 L470 500Z" fill="#E88155"/><path d="M230 40 L230 500 H470Z" fill="#C95F49"/><path d="M195 500 L230 250 L270 500Z" fill="#4E3C48"/><path d="M-20 515 H500" stroke="#8A5A42" stroke-width="26"/></g>
<g transform="translate(850 810)"><path d="M0 520 V60" stroke="#3C836C" stroke-width="58" stroke-linecap="round"/><path d="M0 230 Q-120 230-120 115 M0 330 Q120 330 120 190" fill="none" stroke="#3C836C" stroke-width="48" stroke-linecap="round"/></g>
<ellipse cx="540" cy="1350" rx="220" ry="38" fill="#8C5F48" opacity=".2"/>
''';

String _treeHouse(_ThemeArt t) =>
    '''
${_sky(t)}
<g fill="#3E8056" opacity=".45"><circle cx="80" cy="270" r="260"/><circle cx="980" cy="250" r="280"/><circle cx="520" cy="80" r="240"/></g>
<path d="M0 1100 Q300 920 570 1080 T1080 1010 V1920 H0Z" fill="#4E9662"/>
<g transform="translate(40 460)"><path d="M120 1000 Q150 430 260 0 Q350 470 330 1000" fill="#72523B"/><path d="M-30 370 H450 V760 H-30Z" fill="#A8784F"/><path d="M-70 380 L210 150 L490 380Z" fill="#5D493B"/><rect x="145" y="500" width="130" height="260" rx="18" fill="#47372F"/><path d="M450 500 H900" stroke="#815A40" stroke-width="30"/><path d="M490 515 V760 M570 515 V760 M650 515 V760 M730 515 V760 M810 515 V760 M890 515 V760" stroke="#E2C68D" stroke-width="12"/></g>
<g fill="#78B85C"><ellipse cx="800" cy="520" rx="210" ry="110"/><ellipse cx="970" cy="720" rx="180" ry="100"/></g>
<ellipse cx="540" cy="1360" rx="225" ry="42" fill="#274D35" opacity=".2"/>
''';

String _cherryBridge(_ThemeArt t) =>
    '''
${_sky(t)}
<path d="M0 1080 Q300 920 560 1060 T1080 980 V1920 H0Z" fill="#91B891"/>
<path d="M0 1420 Q290 1280 570 1400 T1080 1340 V1920 H0Z" fill="#73A8AD"/>
<g transform="translate(40 430)"><path d="M120 880 Q120 380 230 0 Q320 370 310 880" fill="#795144"/><path d="M220 300 Q480 180 700 0" fill="none" stroke="#795144" stroke-width="42"/><g fill="#F19AB3"><circle cx="180" cy="40" r="115"/><circle cx="330" cy="10" r="135"/><circle cx="490" cy="70" r="110"/><circle cx="660" cy="15" r="95"/></g></g>
<path d="M100 1390 Q540 1120 980 1390" fill="none" stroke="#754A3C" stroke-width="75"/><path d="M110 1360 Q540 1110 970 1360" fill="none" stroke="#D58B69" stroke-width="54"/>
<path d="M135 1320 V1430 M220 1260 V1390 M860 1260 V1390 M945 1320 V1430" stroke="#70483A" stroke-width="16"/>
''';

String _picnic(_ThemeArt t) =>
    '''
${_outdoor(t)}
${_cloud(180, 290, .66)}
<g transform="translate(75 780)"><path d="M110 560 Q120 220 190 0 Q265 220 265 560" fill="#76523B"/><g fill="#69A95D"><circle cx="60" cy="60" r="115"/><circle cx="190" cy="0" r="145"/><circle cx="325" cy="85" r="115"/></g></g>
<path d="M300 1390 L730 1330 L840 1600 L230 1645Z" fill="#F5EFE0"/><path d="M300 1390 L730 1330 M350 1383 L285 1638 M470 1366 L420 1625 M590 1350 L555 1615 M710 1334 L690 1604 M250 1450 L785 1390 M238 1540 L815 1480" stroke="#DF665D" stroke-width="24" opacity=".85"/>
<g transform="translate(820 1270)"><path d="M0 210 Q80-40 160 210" fill="none" stroke="#8C5E3F" stroke-width="20"/><rect y="120" width="165" height="145" rx="25" fill="#B97A4F"/><path d="M0 175 H165 M55 120 V265 M110 120 V265" stroke="#E1B87C" stroke-width="10"/></g>
''';

String _iceCreamShop(_ThemeArt t) =>
    '''
${_room(t, floor: '#C99D7C')}
<path d="M0 0 H1080 V1040 H0Z" fill="#FFF6F7" opacity=".64"/>
<path d="M0 290 H1080 M0 580 H1080 M0 870 H1080" stroke="#D9EFF4" stroke-width="12"/>
<g transform="translate(75 300)"><rect width="330" height="620" rx="35" fill="#70B7C9"/><rect x="30" y="80" width="270" height="380" rx="24" fill="#EAFBFF"/><path d="M40 470 H290" stroke="#4B899E" stroke-width="28"/><g><circle cx="95" cy="420" r="52" fill="#F6A5BE"/><circle cx="170" cy="420" r="52" fill="#A8D7A0"/><circle cx="245" cy="420" r="52" fill="#F2C16A"/></g></g>
<g transform="translate(790 270)"><path d="M0 300 L95 540 L190 300Z" fill="#D59B63"/><circle cx="45" cy="255" r="82" fill="#F3A4BC"/><circle cx="140" cy="255" r="82" fill="#9DCFE5"/><circle cx="92" cy="180" r="84" fill="#F4D06F"/><path d="M15 330 H175" stroke="#FFFFFF" stroke-width="14" opacity=".42"/></g>
<ellipse cx="600" cy="1400" rx="260" ry="65" fill="#5A4050" opacity=".15"/><rect x="390" y="1200" width="420" height="190" rx="60" fill="#F0AFC4"/>
''';

String _mountainDock(_ThemeArt t) =>
    '''
${_sky(t)}
<path d="M0 920 L210 530 L390 870 L610 390 L910 900 L1080 680 V1250 H0Z" fill="#6C88A7"/>
<path d="M100 730 L210 530 L320 730 L250 700 L210 645 L175 700Z M470 635 L610 390 L755 640 L665 590 L610 500 L565 590Z" fill="#EFF7FA"/>
<path d="M0 1050 Q270 980 540 1045 T1080 1020 V1920 H0Z" fill="#67A7B5"/>
<path d="M0 1190 Q270 1140 540 1190 T1080 1165" fill="none" stroke="#D7F6F5" stroke-width="14" opacity=".52"/>
<path d="M280 1260 L800 1260 L940 1920 H130Z" fill="#9A6E4A"/><path d="M290 1310 H790 M250 1410 H825 M210 1520 H855 M170 1640 H890" stroke="#D1A06A" stroke-width="20"/>
<path d="M280 1260 V1700 M800 1260 V1700" stroke="#624733" stroke-width="24"/>
''';

String _auroraCabin(_ThemeArt t) =>
    '''
${_sky(t)}
<g fill="none" stroke-linecap="round" opacity=".55"><path d="M-80 430 Q260 80 540 390 T1160 180" stroke="#58E3AF" stroke-width="95"/><path d="M-80 550 Q300 190 600 500 T1160 290" stroke="#62BDE3" stroke-width="72"/><path d="M0 640 Q380 340 680 620 T1080 450" stroke="#A17AD6" stroke-width="48"/></g>
<g fill="#FFFFFF"><circle cx="100" cy="180" r="5"/><circle cx="310" cy="270" r="7"/><circle cx="770" cy="180" r="5"/><circle cx="940" cy="330" r="6"/></g>
<path d="M0 1210 Q300 1050 580 1180 T1080 1100 V1920 H0Z" fill="#1D493F"/>
<g transform="translate(70 850)"><rect width="330" height="350" rx="16" fill="#76513C"/><path d="M-50 30 L165-160 L380 30Z" fill="#3F3540"/><path d="M-70 25 Q165-45 400 25" stroke="#EAF7F8" stroke-width="48" fill="none"/><rect x="120" y="160" width="90" height="190" fill="#4D372E"/><rect x="35" y="80" width="68" height="75" fill="#FFD978"/></g>
<ellipse cx="540" cy="1350" rx="235" ry="42" fill="#0C2522" opacity=".26"/>
''';

String _rainyNook(_ThemeArt t) =>
    '''
${_room(t, floor: '#766255')}
${_window(rain: true)}
${_sofa('#8095A4', '#5C7180')}
${_lamp(890, 920, '#E6B955')}
<g transform="translate(740 360)"><rect width="250" height="420" rx="26" fill="#6F5849"/><path d="M20 130 H230 M20 260 H230" stroke="#9D826C" stroke-width="18"/><g fill="#C88A6D"><rect x="45" y="40" width="35" height="75" rx="6"/><rect x="90" y="30" width="45" height="85" rx="6"/></g></g>
<ellipse cx="540" cy="1350" rx="235" ry="45" fill="#32434B" opacity=".2"/>
''';

String _pumpkinFarm(_ThemeArt t) =>
    '''
${_outdoor(t)}
<g transform="translate(70 760)"><path d="M0 530 H940 V620 H0Z" fill="#8A5A3E"/><path d="M0 420 H940 M60 350 V620 M250 350 V620 M440 350 V620 M630 350 V620 M820 350 V620" stroke="#9A6647" stroke-width="30"/></g>
<g>${List.generate(8, (i) {
      final x = 85 + i * 135;
      final y = 1280 + (i % 2) * 90;
      return '<g transform="translate($x $y)"><ellipse rx="60" ry="50" fill="#D95F2E"/><ellipse rx="32" ry="50" fill="#F18A3D"/><path d="M0-48 q0-30 24-38" stroke="#4F713E" stroke-width="12" fill="none"/></g>';
    }).join()}</g>
<path d="M280 1390 Q540 1300 800 1390" fill="none" stroke="#D7B16B" stroke-width="70" stroke-linecap="round"/>
''';

String _cloudPalace(_ThemeArt t) =>
    '''
${_sky(t)}
${_cloud(160, 410, .82)}${_cloud(875, 500, .7)}
<g transform="translate(160 400)"><path d="M0 780 H760 V1180 H0Z" fill="#ECE7F6"/><path d="M40 780 V300 H190 V780 M305 780 V150 H455 V780 M570 780 V300 H720 V780" fill="#F8F4FF"/><path d="M20 300 L115 200 L210 300 M285 150 L380 40 L475 150 M550 300 L645 200 L740 300" fill="#B69BD9"/><g fill="#8CAED3"><path d="M78 450 q37-80 74 0v130H78Z"/><path d="M343 350 q37-80 74 0v130H343Z"/><path d="M608 450 q37-80 74 0v130H608Z"/></g></g>
<g transform="translate(0 1140)">${_cloud(180, 100, 1.2)}${_cloud(540, 70, 1.45)}${_cloud(900, 105, 1.25)}</g>
<path d="M260 1370 Q540 1240 820 1370" fill="none" stroke="#EBD7B3" stroke-width="82" stroke-linecap="round"/>
''';

String _tropicalDeck(_ThemeArt t) =>
    '''
${_sky(t)}
<circle cx="850" cy="290" r="92" fill="#FFD76A"/><circle cx="850" cy="290" r="180" fill="url(#${t.id}_glow)"/>
<path d="M0 820 Q280 770 540 825 T1080 800 V1460 H0Z" fill="#55C5D0"/>
<path d="M0 930 Q270 885 540 930 T1080 910" fill="none" stroke="#D7FFFF" stroke-width="20" opacity=".7"/>
<path d="M0 1200 Q300 1060 620 1190 T1080 1110 V1920 H0Z" fill="#EACD86"/>
<g transform="translate(80 700)"><path d="M40 650 Q100 250 190 0" fill="none" stroke="#7B563D" stroke-width="45"/><g fill="#4CAA6C"><path d="M180 20 q-170-130-210-20 q130 20 210 20Z"/><path d="M180 20 q180-120 225-5 q-130 15-225 5Z"/><path d="M180 20 q20-180 110-160 q-30 105-110 160Z"/></g></g>
<path d="M120 1390 L960 1325 L1080 1920 H0Z" fill="#A66E4A"/><path d="M105 1450 L975 1385 M75 1560 L1000 1490 M45 1680 L1025 1605" stroke="#D9A36B" stroke-width="24"/>
''';

String _lavenderCottage(_ThemeArt t) =>
    '''
${_outdoor(t)}
<g transform="translate(50 690)"><rect width="340" height="440" rx="20" fill="#F3E9DD"/><path d="M-45 20 L170-170 L385 20Z" fill="#886F9E"/><rect x="115" y="225" width="105" height="215" fill="#745B57"/><rect x="35" y="95" width="70" height="95" fill="#9FD3DF"/><rect x="245" y="95" width="70" height="95" fill="#9FD3DF"/></g>
<g>${List.generate(18, (i) {
      final x = 30 + i * 62;
      final y = 1260 + (i % 4) * 70;
      return '<path d="M$x ${y + 130} q15-80 0-150 q-15 75 0 150" stroke="#675687" stroke-width="10" fill="none"/><g fill="#A47CC3"><circle cx="${x - 8}" cy="${y + 15}" r="12"/><circle cx="${x + 8}" cy="${y + 38}" r="12"/><circle cx="${x - 8}" cy="${y + 60}" r="12"/></g>';
    }).join()}</g>
<path d="M300 1390 Q540 1280 780 1390" fill="none" stroke="#D7BE91" stroke-width="76" stroke-linecap="round"/>
''';

String _teaGarden(_ThemeArt t) =>
    '''
${_sky(t)}
<path d="M0 1170 Q300 1010 580 1140 T1080 1060 V1920 H0Z" fill="#719A69"/>
<g>${[90, 245, 830, 980].map((x) => '<g transform="translate($x 260)"><rect width="58" height="1050" rx="28" fill="#4D8B58"/><path d="M4 420 H54 M4 720 H54" stroke="#D2E6A5" stroke-width="14"/><path d="M25 280 q-120-90-160 10 q95 35 160-10 M35 530 q130-95 175 5 q-100 35-175-5" fill="#65A568"/></g>').join()}</g>
<g transform="translate(300 1180)"><ellipse cx="240" cy="155" rx="270" ry="65" fill="#6A4A38" opacity=".22"/><rect x="70" y="0" width="340" height="120" rx="55" fill="#C99961"/><rect x="115" y="100" width="42" height="230" fill="#80604A"/><rect x="322" y="100" width="42" height="230" fill="#80604A"/><path d="M180 10 q60-95 120 0 q-60 55-120 0Z" fill="#EFF4E2"/><circle cx="240" cy="-5" r="18" fill="#6A8C68"/></g>
''';

String _library(_ThemeArt t) =>
    '''
${_room(t, floor: '#7D5543')}
<path d="M0 0 H1080 V1040 H0Z" fill="#C28B62" opacity=".42"/>
${_shelf('#74503F')}
<g transform="translate(35 240)">${_shelf('#815B46')}</g>
${_sofa('#B9845D', '#855941')}
${_lamp(850, 970, '#E7B955')}
<g transform="translate(60 1040)"><rect width="230" height="280" rx="18" fill="#5D4136"/><path d="M22 70 H208 M22 150 H208 M22 230 H208" stroke="#80604A" stroke-width="14"/><g fill="#D0A45A"><rect x="45" y="15" width="30" height="45"/><rect x="90" y="5" width="35" height="55"/></g></g>
''';

String _camp(_ThemeArt t) =>
    '''
${_sky(t)}
<g fill="#FFF3B0"><circle cx="120" cy="220" r="5"/><circle cx="280" cy="340" r="7"/><circle cx="540" cy="180" r="5"/><circle cx="820" cy="270" r="7"/><circle cx="950" cy="430" r="5"/></g>
<circle cx="860" cy="260" r="80" fill="#FFE9A8"/><circle cx="892" cy="240" r="75" fill="${t.top}"/>
<path d="M0 1100 Q290 920 560 1060 T1080 980 V1920 H0Z" fill="#214C3A"/>
<g transform="translate(80 900)"><path d="M0 450 L250-20 L510 450Z" fill="#E56B52"/><path d="M250-20 V450 H510Z" fill="#B94D48"/><path d="M205 450 L250 190 L300 450Z" fill="#2D3045"/><path d="M-25 470 H535" stroke="#142E2A" stroke-width="28"/></g>
<g transform="translate(810 1240)"><path d="M-85 145 Q-45 60-15 0 Q0 90 35 35 Q95 105 55 160Z" fill="#F08B45"/><path d="M-35 145 Q-10 90 10 62 Q20 115 43 95 Q60 130 40 160Z" fill="#FFD461"/><path d="M-105 170 L95 170 M-80 200 L70 140" stroke="#76503B" stroke-width="22" stroke-linecap="round"/></g>
<ellipse cx="540" cy="1370" rx="225" ry="42" fill="#0D2923" opacity=".25"/>
''';

String _balloonLookout(_ThemeArt t) =>
    '''
${_balloonLookoutSky(t)}
${_balloon(250, 450, 1.15, '#D45156', '#F47A65')}
${_balloon(795, 390, .92, '#428EC9', '#78BDEA')}
${_balloon(520, 650, .66, '#8F62B3', '#C18BDD')}
''';

String _balloonLookoutSky(_ThemeArt t) =>
    '''
${_sky(t)}
<circle cx="900" cy="250" r="85" fill="#FFD675"/><circle cx="900" cy="250" r="170" fill="url(#${t.id}_glow)"/>
${_cloud(165, 330, .65)}
<path d="M0 1120 Q290 960 560 1080 T1080 1020 V1920 H0Z" fill="#8DBD8E"/>
<path d="M0 1430 Q300 1290 600 1410 T1080 1350 V1920 H0Z" fill="#68A477"/>
<path d="M290 1380 Q540 1260 790 1380" fill="none" stroke="#E2C184" stroke-width="76" stroke-linecap="round"/>
''';

String _balloon(double x, double y, double s, String dark, String light) =>
    '''
<g transform="translate($x $y) scale($s)">
  <path d="M0-145 C92-145 125-65 100 28 C82 90 38 124 0 138 C-38 124-82 90-100 28 C-125-65-92-145 0-145Z" fill="$dark"/>
  <path d="M0-140 C40-115 48 52 0 132 C-48 52-40-115 0-140Z" fill="$light"/>
  <path d="M-56-110 Q-78-42-48 58" fill="none" stroke="#FFFFFF" stroke-width="18" opacity=".26"/>
  <path d="M-22 136 L-30 195 M22 136 L30 195" stroke="#5C463D" stroke-width="5"/>
  <rect x="-38" y="188" width="76" height="50" rx="8" fill="#8A644F"/>
  <path d="M-30 200 H30 M-18 190 V236 M0 190 V236 M18 190 V236" stroke="#C99A6C" stroke-width="5"/>
</g>''';

String _playroom(_ThemeArt t) =>
    '''
${_room(t, floor: '#B77D58')}
<path d="M0 0 H1080 V1040 H0Z" fill="#FFF7E7" opacity=".66"/>
${_window()}
<g transform="translate(720 330)"><rect width="300" height="650" rx="30" fill="#66A9BE"/><path d="M20 200 H280 M20 400 H280 M20 580 H280" stroke="#E9F5F2" stroke-width="20"/><g fill="#F1C657"><circle cx="85" cy="115" r="55"/><rect x="175" y="55" width="80" height="100" rx="16"/></g><g fill="#E87372"><path d="M45 330 l55-90 l55 90Z"/><rect x="185" y="260" width="72" height="85" rx="15"/></g></g>
<g transform="translate(50 1150)"><rect width="330" height="230" rx="45" fill="#D9625C"/><path d="M30 55 H300" stroke="#F29B77" stroke-width="30"/><g fill="#F0C34F"><rect x="55" y="-70" width="80" height="90" rx="12"/><circle cx="220" cy="-30" r="55"/></g></g>
<path d="M360 1410 Q540 1300 720 1410" fill="none" stroke="#62A9C5" stroke-width="100" stroke-linecap="round"/>
<g transform="translate(790 1280)"><circle cx="80" cy="100" r="86" fill="#E5B853"/><circle cx="50" cy="78" r="13" fill="#55433E"/><circle cx="110" cy="78" r="13" fill="#55433E"/><path d="M45 120 Q80 150 115 120" fill="none" stroke="#55433E" stroke-width="8"/></g>
''';
