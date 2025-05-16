import 'package:flutter/material.dart' show Color;

class SettingsState {
  final String language;
  final String currency;

  final Color color;
  final bool isDark;

  SettingsState({
    this.language = 'RU',
    this.currency = 'RUB',
    required this.color,
    this.isDark = false,
  });

  SettingsState.initial() : this(color: Color(0xFF6750A4));

  static SettingsState fromJson(Map<String, dynamic> json) {
    return SettingsState(
      language: json['language'] as String,
      currency: json['currency'] as String,
      color: Color(json['color'] as int),
      isDark: json['isDark'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'currency': currency,
      'color': color.toARGB32(),
      'isDark': isDark,
    };
  }

  SettingsState copyWith({
    String? language,
    String? currency,
    Color? color,
    bool? isDark,
  }) {
    return SettingsState(
      language: language ?? this.language,
      currency: currency ?? this.currency,
      color: color ?? this.color,
      isDark: isDark ?? this.isDark,
    );
  }
}
