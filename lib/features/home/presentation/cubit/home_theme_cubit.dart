import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/theme_preferences.dart';
import '../../domain/home_theme.dart';

class HomeThemeState {
  const HomeThemeState({
    this.themeId = HomeTheme.morningGlowId,
    this.previewThemeId,
  });

  final String themeId;
  final String? previewThemeId;

  String get activeThemeId => previewThemeId ?? themeId;

  HomeThemeState copyWith({
    String? themeId,
    String? previewThemeId,
    bool clearPreview = false,
  }) {
    return HomeThemeState(
      themeId: themeId ?? this.themeId,
      previewThemeId:
          clearPreview ? null : (previewThemeId ?? this.previewThemeId),
    );
  }
}

class HomeThemeCubit extends Cubit<HomeThemeState> {
  HomeThemeCubit({
    ThemePreferences? preferences,
    HomeThemeCatalog? catalog,
  })  : _preferences = preferences ?? SharedThemePreferences(),
        _catalog = catalog,
        super(const HomeThemeState());

  final ThemePreferences _preferences;
  HomeThemeCatalog? _catalog;

  HomeThemeCatalog? get catalogOrNull => _catalog;

  HomeTheme get activeTheme {
    final catalog = _catalog;
    if (catalog == null) return _fallback;
    return catalog.byId(state.activeThemeId);
  }

  static const _fallback = HomeTheme(
    id: HomeTheme.morningGlowId,
    name: 'Morning Glow',
    svg: 'assets/backgrounds/morning_glow.svg',
    stageColor: Color(0xFFFFF6E8),
    isDark: false,
  );

  Future<void> hydrate() async {
    _catalog ??= await HomeThemeCatalog.load();
    final saved = await _preferences.readThemeId();
    final id =
        saved == null ? _catalog!.defaultId : _catalog!.byId(saved).id;
    if (!isClosed) {
      emit(state.copyWith(themeId: id, clearPreview: true));
    }
  }

  void previewTheme(String themeId) {
    emit(state.copyWith(previewThemeId: themeId));
  }

  void clearThemePreview() {
    emit(state.copyWith(clearPreview: true));
  }

  Future<void> applyTheme(String themeId) async {
    final resolved = _catalog?.byId(themeId).id ?? themeId;
    emit(state.copyWith(themeId: resolved, clearPreview: true));
    await _preferences.writeThemeId(resolved);
  }
}
