import 'package:flutter/material.dart' show Color;

abstract class SettingsEvent {}

class UpdateUIColorEvent extends SettingsEvent {
  final Color color;

  UpdateUIColorEvent(this.color);
}

class UpdateUIDarkModeEvent extends SettingsEvent {
  final bool isDark;

  UpdateUIDarkModeEvent(this.isDark);
}

class UpdateLanguageEvent extends SettingsEvent {
  final String language;

  UpdateLanguageEvent(this.language);
}

class UpdateCurrencyEvent extends SettingsEvent {
  final String currency;

  UpdateCurrencyEvent(this.currency);
}

class InitializeUIEvent extends SettingsEvent {}
