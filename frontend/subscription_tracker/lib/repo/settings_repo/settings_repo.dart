import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:subscription_tracker/bloc/settings_bloc/settings_state.dart';

class SettingsRepo {
  static const _boxName = 'uiColorBox';
  static const uiThemeKey = 'uiTheme';

  late final Box<String> _box;

  static const _compactionThreshold = 1000;
  int _saveOperations = 0;

  late SettingsState _state;

  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
    final uiThemeString = _box.get(uiThemeKey);

    if (uiThemeString != null) {
      _state = SettingsState.fromJson(convert.jsonDecode(uiThemeString));
    } else {
      _state = SettingsState.initial();
    }
  }

  Future<void> close() async {
    await _box.compact();
    await _box.close();
  }

  Future<void> update({
    String? language,
    String? currency,
    Color? color,
    bool? isDark,
  }) async {
    _state = _state.copyWith(
      language: language,
      currency: currency,
      color: color,
      isDark: isDark,
    );

    await _box.put(uiThemeKey, convert.jsonEncode(_state));

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }
  }

  SettingsState get settings => _state;
}
