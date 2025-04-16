import 'package:flutter/material.dart' show Color;

abstract class UIColorEvent {}

class UpdateUIColorEvent extends UIColorEvent {
  final Color color;

  UpdateUIColorEvent(this.color);
}

class UpdateUIDarkModeEvent extends UIColorEvent {
  final bool isDark;

  UpdateUIDarkModeEvent(this.isDark);
}

class InitializeUIEvent extends UIColorEvent {}
