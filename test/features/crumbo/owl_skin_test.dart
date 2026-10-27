import 'dart:convert';
import 'dart:io';

import 'package:crumbo/features/crumbo/data/skin_preferences.dart';
import 'package:crumbo/features/crumbo/domain/owl_expression.dart';
import 'package:crumbo/features/crumbo/domain/owl_skin.dart';
import 'package:crumbo/features/crumbo/presentation/cubit/crumbo_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _bundledJson() =>
    jsonDecode(File('assets/data/owl_skins.json').readAsStringSync())
        as Map<String, dynamic>;

OwlSkinCatalog _bundledCatalog() {
  final map = _bundledJson();
  return OwlSkinCatalog(
    (map['skins'] as List)
        .map((e) => OwlSkin.fromJson(e as Map<String, dynamic>))
        .toList(),
    map['defaultId'] as String,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('bundled json has 20 unique themes, classic first and default', () {
    final catalog = _bundledCatalog();
    expect(catalog.skins.length, 20);
    expect(catalog.skins.map((s) => s.id).toSet().length, 20);
    expect(catalog.skins.first.id, OwlSkin.classicBrownId);
    expect(catalog.defaultSkin.id, OwlSkin.classicBrownId);
    expect(catalog.byId('missing').id, OwlSkin.classicBrownId);
    expect(catalog.numberOf(catalog.byId('blue_sky')), 2);
  });

  test('classic uses original pack + custom mood files', () {
    final classic = _bundledCatalog().defaultSkin;
    expect(classic.riveAssetFor(OwlExpression.think), 'assets/rive/owl.riv');
    expect(
      classic.riveAssetFor(OwlExpression.sleep),
      'assets/rive/owl_sleep.riv',
    );
    expect(
      classic.riveAssetFor(OwlExpression.listen),
      'assets/rive/owl_listen.riv',
    );
    expect(
      classic.riveAssetFor(OwlExpression.talk),
      'assets/rive/owl_talk.riv',
    );
    expect(
      classic.riveAssetFor(OwlExpression.bath),
      'assets/rive/owl_bath.riv',
    );
    expect(
      classic.riveAssetFor(OwlExpression.clean),
      'assets/rive/owl_clean.riv',
    );
  });

  test('other skins use recolored copies for every mood', () {
    final blue = _bundledCatalog().byId('blue_sky');
    expect(
      blue.riveAssetFor(OwlExpression.happy),
      'assets/rive/skins/owl_blue_sky.riv',
    );
    expect(
      blue.riveAssetFor(OwlExpression.think),
      'assets/rive/skins/owl_blue_sky.riv',
    );
    expect(
      blue.riveAssetFor(OwlExpression.sleep),
      'assets/rive/skins/owl_sleep_blue_sky.riv',
    );
    // listen/talk fall back to classic custom rivs until skin variants exist
    expect(
      blue.riveAssetFor(OwlExpression.listen),
      'assets/rive/owl_listen.riv',
    );
    expect(
      blue.riveAssetFor(OwlExpression.talk),
      'assets/rive/owl_talk.riv',
    );
  });

  test('every skin has its generated riv files and thumbnail', () {
    for (final skin in _bundledCatalog().skins) {
      expect(File(skin.thumbnailPath).existsSync(), isTrue,
          reason: skin.thumbnailPath);
      for (final e in [OwlExpression.think, OwlExpression.sleep]) {
        final path = skin.riveAssetFor(e);
        expect(File(path).existsSync(), isTrue, reason: path);
      }
    }
  });

  test('preview then apply persists; skin survives mood changes', () async {
    final prefs = MemorySkinPreferences();
    final cubit = CrumboCubit(
      skinPreferences: prefs,
      catalog: _bundledCatalog(),
    );

    cubit.previewSkin('blue_sky');
    expect(cubit.state.activeSkinId, 'blue_sky');
    expect(cubit.state.skinId, OwlSkin.classicBrownId);

    cubit.clearSkinPreview();
    expect(cubit.state.activeSkinId, OwlSkin.classicBrownId);

    await cubit.applySkin('night_sky');
    expect(cubit.state.skinId, 'night_sky');
    expect(cubit.state.previewSkinId, isNull);
    expect(await prefs.readSkinId(), 'night_sky');

    cubit.setExpression(OwlExpression.happy);
    expect(cubit.activeSkin.riveAssetFor(cubit.state.expression),
        'assets/rive/skins/owl_night_sky.riv');
    cubit.goIdle();
    expect(cubit.state.skinId, 'night_sky');

    await cubit.close();
  });

  test('hydrate restores saved skin', () async {
    final prefs = MemorySkinPreferences();
    await prefs.writeSkinId('mint_green');
    final cubit = CrumboCubit(
      skinPreferences: prefs,
      catalog: _bundledCatalog(),
    );
    await cubit.hydrate();
    expect(cubit.state.skinId, 'mint_green');
    await cubit.close();
  });
}
