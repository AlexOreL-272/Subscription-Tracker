import 'dart:convert' as convert;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:subscription_tracker/models/ui_color_bloc/ui_color_event.dart';
import 'package:subscription_tracker/models/ui_color_bloc/ui_color_state.dart';

class UIColorBloc extends Bloc<UIColorEvent, UIColorState> {
  static const _boxName = 'uiColorBox';
  static const uiThemeKey = 'uiTheme';

  late final Box<String> _box;

  static const _compactionThreshold = 1000;
  int _saveOperations = 0;

  UIColorBloc() : super(UIColorState.initial()) {
    on<InitializeUIEvent>(_initialize);
    on<UpdateUIColorEvent>(_updateColor);
    on<UpdateUIDarkModeEvent>(_updateDarkMode);

    add(InitializeUIEvent());
  }

  Future<void> _initialize(
    InitializeUIEvent event,
    Emitter<UIColorState> emit,
  ) async {
    _box = await Hive.openBox<String>(_boxName);
    final uiThemeString = _box.get(uiThemeKey);

    if (uiThemeString != null) {
      final uiTheme = UIColorState.fromJson(convert.jsonDecode(uiThemeString));

      emit(uiTheme);
    }
  }

  Future<void> _updateColor(
    UpdateUIColorEvent event,
    Emitter<UIColorState> emit,
  ) async {
    await _box.put(
      uiThemeKey,
      convert.jsonEncode(
        UIColorState(color: event.color, isDark: state.isDark),
      ),
    );

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    emit(UIColorState(color: event.color, isDark: state.isDark));
  }

  Future<void> _updateDarkMode(
    UpdateUIDarkModeEvent event,
    Emitter<UIColorState> emit,
  ) async {
    await _box.put(
      uiThemeKey,
      convert.jsonEncode(
        UIColorState(color: state.color, isDark: event.isDark),
      ),
    );

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    emit(UIColorState(color: state.color, isDark: event.isDark));
  }
}
