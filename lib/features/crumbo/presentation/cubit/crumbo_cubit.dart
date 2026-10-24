import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/skin_preferences.dart';
import '../../domain/owl_expression.dart';
import '../../domain/owl_skin.dart';

class CrumboCharacterState {
  const CrumboCharacterState({
    this.expression = OwlExpression.idle,
    this.skinId = OwlSkin.classicBrownId,
    this.previewSkinId,
  });

  final OwlExpression expression;
  final String skinId;

  /// Temporary pick in Skins sheet (null = show applied [skinId]).
  final String? previewSkinId;

  String get artboardName => expression.artboardName;

  String get activeSkinId => previewSkinId ?? skinId;

  CrumboCharacterState copyWith({
    OwlExpression? expression,
    String? skinId,
    String? previewSkinId,
    bool clearPreview = false,
  }) {
    return CrumboCharacterState(
      expression: expression ?? this.expression,
      skinId: skinId ?? this.skinId,
      previewSkinId:
          clearPreview ? null : (previewSkinId ?? this.previewSkinId),
    );
  }
}

/// Drives owl marketplace artboards + skin theme.
///
/// After a short action, returns to [OwlExpression.idle] automatically.
/// Sleep holds until tap / Idle. Talk is not in this pack (mic later).
class CrumboCubit extends Cubit<CrumboCharacterState> {
  CrumboCubit({
    SkinPreferences? skinPreferences,
    OwlSkinCatalog? catalog,
  })  : _skinPreferences = skinPreferences ?? SharedSkinPreferences(),
        _catalog = catalog,
        super(const CrumboCharacterState());

  static const _autoIdleDelay = Duration(milliseconds: 2800);

  final SkinPreferences _skinPreferences;
  OwlSkinCatalog? _catalog;
  Timer? _autoIdleTimer;

  OwlSkinCatalog? get catalogOrNull => _catalog;

  OwlSkin get activeSkin {
    final catalog = _catalog;
    if (catalog == null) return _fallbackClassic;
    return catalog.byId(state.activeSkinId);
  }

  static const _fallbackClassic = OwlSkin(
    id: OwlSkin.classicBrownId,
    name: 'Classic Brown',
    cardBg: Color(0xFFF8EBDD),
    body: Color(0xFFBE8C6C),
    accent: Color(0xFF76421C),
    belly: Color(0xFFF1E1BE),
    bow: Color(0xFF3F8DD2),
  );

  Future<void> hydrate() async {
    _catalog ??= await OwlSkinCatalog.load();
    final saved = await _skinPreferences.readSkinId();
    final id = saved == null ? _catalog!.defaultId : _catalog!.byId(saved).id;
    if (!isClosed) {
      emit(state.copyWith(skinId: id, clearPreview: true));
    }
  }

  @override
  Future<void> close() {
    _autoIdleTimer?.cancel();
    return super.close();
  }

  void setExpression(OwlExpression expression) {
    _autoIdleTimer?.cancel();
    emit(state.copyWith(expression: expression));
    _scheduleAutoIdleIfNeeded(expression);
  }

  void goIdle() {
    _autoIdleTimer?.cancel();
    emit(state.copyWith(expression: OwlExpression.idle));
  }

  void setSleep() => setExpression(OwlExpression.sleep);

  void setDance() => setExpression(OwlExpression.dance);

  void toggleEat() {
    if (state.expression == OwlExpression.eat) {
      goIdle();
    } else {
      setExpression(OwlExpression.eat);
    }
  }

  /// Brief wave, then auto-idle.
  void poke() => setExpression(OwlExpression.poke);

  /// Tap: wake from sleep, otherwise poke/wave (then idle).
  void onCharacterTapped() {
    if (state.expression == OwlExpression.sleep) {
      goIdle();
    } else {
      poke();
    }
  }

  void previewSkin(String skinId) {
    emit(state.copyWith(previewSkinId: skinId));
  }

  void clearSkinPreview() {
    emit(state.copyWith(clearPreview: true));
  }

  Future<void> applySkin(String skinId) async {
    final resolved = _catalog?.byId(skinId).id ?? skinId;
    emit(state.copyWith(skinId: resolved, clearPreview: true));
    await _skinPreferences.writeSkinId(resolved);
  }

  void _scheduleAutoIdleIfNeeded(OwlExpression expression) {
    if (expression.holdsUntilDismissed) return;

    _autoIdleTimer = Timer(_autoIdleDelay, () {
      if (!isClosed && state.expression == expression) {
        emit(state.copyWith(expression: OwlExpression.idle));
      }
    });
  }
}
