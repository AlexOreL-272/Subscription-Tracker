import 'package:flutter/material.dart' show Color;

class UIColorState {
  final Color color;
  final bool isDark;

  UIColorState({required this.color, this.isDark = false});

  UIColorState.initial() : this(color: Color(0xFF6750A4));

  static UIColorState fromJson(Map<String, dynamic> json) {
    return UIColorState(
      color: Color(json['color'] as int),
      isDark: json['isDark'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'color': color.toARGB32(), 'isDark': isDark};
  }
}
