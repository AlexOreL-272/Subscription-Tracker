import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/models/ui_color_bloc/ui_color_event.dart';
import 'package:subscription_tracker/models/ui_color_bloc/ui_color_state.dart';

class UIColorBloc extends Bloc<UIColorEvent, UIColorState> {
  UIColorBloc() : super(UIColorState.initial()) {
    on<UpdateUIColorEvent>(_updateColor);
    on<UpdateUIDarkModeEvent>(_updateDarkMode);
  }

  Future<void> _updateColor(
    UpdateUIColorEvent event,
    Emitter<UIColorState> emit,
  ) async {
    emit(UIColorState(color: event.color));
  }

  Future<void> _updateDarkMode(
    UpdateUIDarkModeEvent event,
    Emitter<UIColorState> emit,
  ) async {
    emit(UIColorState(color: state.color, isDark: event.isDark));
  }
}
