import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/bloc/settings_bloc/settings_event.dart';
import 'package:subscription_tracker/bloc/settings_bloc/settings_state.dart';
import 'package:subscription_tracker/repo/settings_repo/settings_repo.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepo settingsRepo;

  SettingsBloc({required this.settingsRepo}) : super(SettingsState.initial()) {
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
    emit(settingsRepo.settings);
  }

  Future<void> _updateColor(
    UpdateUIColorEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await settingsRepo.update(color: event.color);
    emit(settingsRepo.settings);
  }

  Future<void> _updateDarkMode(
    UpdateUIDarkModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await settingsRepo.update(isDark: event.isDark);
    emit(settingsRepo.settings);
  }

  Future<void> _updateLanguage(
    UpdateLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await settingsRepo.update(language: event.language);
    emit(settingsRepo.settings);
  }

  Future<void> _updateCurrency(
    UpdateCurrencyEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await settingsRepo.update(currency: event.currency);
    emit(settingsRepo.settings);
  }

  @override
  Future<void> close() async {
    await settingsRepo.close();
    return super.close();
  }
}
