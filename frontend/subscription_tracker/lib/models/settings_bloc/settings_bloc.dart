import 'dart:convert' as convert;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:subscription_tracker/models/settings_bloc/settings_event.dart';
import 'package:subscription_tracker/models/settings_bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  static const _boxName = 'uiColorBox';
  static const uiThemeKey = 'uiTheme';

  late final Box<String> _box;

  static const _compactionThreshold = 1000;
  int _saveOperations = 0;

  SettingsBloc() : super(SettingsState.initial()) {
    on<InitializeUIEvent>(_initialize);
    on<UpdateLanguageEvent>(_updateLanguage);
    on<UpdateCurrencyEvent>(_updateCurrency);
    on<UpdateUIColorEvent>(_updateColor);
    on<UpdateUIDarkModeEvent>(_updateDarkMode);

    add(InitializeUIEvent());
  }

  Future<void> _initialize(
    InitializeUIEvent event,
    Emitter<SettingsState> emit,
  ) async {
    _box = await Hive.openBox<String>(_boxName);
    final uiThemeString = _box.get(uiThemeKey);

    if (uiThemeString != null) {
      final uiTheme = SettingsState.fromJson(convert.jsonDecode(uiThemeString));

      emit(uiTheme);
    }
  }

  Future<void> _updateColor(
    UpdateUIColorEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedState = SettingsState(
      language: state.language,
      currency: state.currency,
      color: event.color,
      isDark: state.isDark,
    );

    await _box.put(uiThemeKey, convert.jsonEncode(updatedState));

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    emit(updatedState);
  }

  Future<void> _updateDarkMode(
    UpdateUIDarkModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedState = SettingsState(
      language: state.language,
      currency: state.currency,
      color: state.color,
      isDark: event.isDark,
    );

    await _box.put(uiThemeKey, convert.jsonEncode(updatedState));

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    emit(updatedState);
  }

  Future<void> _updateLanguage(
    UpdateLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedState = SettingsState(
      language: event.language,
      currency: state.currency,
      color: state.color,
      isDark: state.isDark,
    );

    await _box.put(uiThemeKey, convert.jsonEncode(updatedState));

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    emit(updatedState);
  }

  Future<void> _updateCurrency(
    UpdateCurrencyEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedState = SettingsState(
      language: state.language,
      currency: event.currency,
      color: state.color,
      isDark: state.isDark,
    );

    await _box.put(uiThemeKey, convert.jsonEncode(updatedState));

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    emit(updatedState);
  }
}
