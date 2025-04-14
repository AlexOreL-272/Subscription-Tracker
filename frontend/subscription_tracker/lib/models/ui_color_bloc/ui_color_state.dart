import 'package:flutter/material.dart' show Color;

class UIColorState {
  final Color color;
  final bool isDark;

  UIColorState({required this.color, this.isDark = false});

  UIColorState.initial() : this(color: Color(0xFF6750A4));
}
