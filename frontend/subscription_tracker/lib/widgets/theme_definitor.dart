import 'package:flutter/material.dart';

const textTheme = TextTheme(
  headlineLarge: TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.bold,
    fontSize: 32.0,
  ),

  titleLarge: TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 18.0,
  ),

  titleMedium: TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
  ),

  titleSmall: TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
  ),

  labelMedium: TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
  ),

  bodyMedium: TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
  ),
);

extension WasubiColors on Colors {
  static const MaterialColor wasubiPurple =
      MaterialColor(_wasubiPurpleValue, <int, Color>{
        100: Color(0xFFF4F1FC),
        150: Color(0xFFE8DFFA),
        200: Color(0xFFD8CBF6),
        250: Color(0xFFCAB8F2),
        300: Color(0xFFB9A3EA),
        350: Color(0xFFAB91EC),
        400: Color(0xFF9D7EE6),
        450: Color(0xFF8E6AE4),
        500: Color(_wasubiPurpleValue),
        550: Color(0xFF6D3EDC),
        600: Color(0xFF5B27D4),
        650: Color(0xFF5122BC),
        700: Color(0xFF461EA3),
        750: Color(0xFF3B198A),
        800: Color(0xFF2E146E),
        850: Color(0xFF261059),
        900: Color(0xFF1D0C40),
      });

  static const int _wasubiPurpleValue = 0xFF7F54E4;

  static const MaterialColor wasubiNeutral =
      MaterialColor(_wasubiNeutralValue, <int, Color>{
        100: Color(_wasubiNeutralValue),
        150: Color(0xFFF8F9FB),
        200: Color(0xFFF3F4F8),
        250: Color(0xFFEBECF0),
        300: Color(0xFFE1E2E7),
        350: Color(0xFFCFD2DB),
        400: Color(0xFFBFC2CB),
        450: Color(0xFFA6ADB7),
        500: Color(0xFF90949F),
        550: Color(0xFF6E7788),
        600: Color(0xFF565E6B),
        650: Color(0xFF424856),
        700: Color(0xFF33383F),
        750: Color(0xFF262A33),
        800: Color(0xFF1E212A),
        850: Color(0xFF181B22),
        900: Color(0xFF191A1E),
      });

  static const int _wasubiNeutralValue = 0xFFFAFAFC;
}

enum ColorSeed {
  baseColor('M3 Baseline', Color(0xff6750a4)),
  indigo('Indigo', Colors.indigo), // 0xFF3F51B5
  blue('Blue', Colors.blue), // 0xFF2196F3
  teal('Teal', Colors.teal), // 0xFF009688
  green('Green', Colors.green), // 0xFF4CAF50
  yellow('Yellow', Colors.yellow), // 0xFFFFEB3B
  orange('Orange', Colors.orange), // 0xFFFF9800
  deepOrange('Deep Orange', Colors.deepOrange), //0xFFFF5722
  pink('Pink', Colors.pink), // 0xFFE91E63
  brightBlue('Bright Blue', Color(0xFF0000FF)),
  brightGreen('Bright Green', Color(0xFF00FF00)),
  brightRed('Bright Red', Color(0xFFFF0000));

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}

class UIBaseColors {
  final Color background;
  final Color container;
  final Color border;
  final Color shadow;
  final Color text;
  final Color secondaryText;

  const UIBaseColors({
    required this.background,
    required this.container,
    required this.border,
    required this.shadow,
    required this.text,
    required this.secondaryText,
  });

  UIBaseColors.light()
    : background = backgroundLight,
      container = containerLight,
      border = borderLight,
      shadow = shadowLight,
      text = textLight,
      secondaryText = secondaryTextLight;

  UIBaseColors.dark()
    : background = backgroundDark,
      container = containerDark,
      border = borderDark,
      shadow = shadowDark,
      text = textDark,
      secondaryText = secondaryTextDark;

  static const Color backgroundLight = Colors.white;
  static const Color backgroundDark = Color(0xFF121212);

  static const Color containerLight = Color(0xFFF8F9FA);
  static const Color containerDark = Color(0xFF282828);

  static final Color borderLight = Colors.grey[200]!;
  static final Color borderDark = Colors.white.withAlpha(20);

  static final Color shadowLight = Colors.black.withAlpha(10);
  static final Color shadowDark = Colors.white.withAlpha(10);

  static const Color textLight = Colors.black;
  static const Color textDark = Colors.white;

  static final Color secondaryTextLight = WasubiColors.wasubiNeutral[700]!;
  static final Color secondaryTextDark = Colors.white.withAlpha(210);
}

enum UIColorSeed {
  baseColor('Base', Color(0xFF6750A4)),
  indigo('Indigo', Colors.indigo), // 0xFF3F51B5
  blue('Blue', Colors.blue), // 0xFF2196F3
  teal('Teal', Colors.teal), // 0xFF009688
  green('Green', Colors.green), // 0xFF4CAF50
  yellow('Yellow', Colors.yellow), // 0xFFFFEB3B
  orange('Orange', Colors.orange), // 0xFFFF9800
  deepOrange('Deep Orange', Colors.deepOrange), //0xFFFF5722
  pink('Pink', Colors.pink); // 0xFFE91E63

  const UIColorSeed(this.label, this.color);
  final String label;
  final Color color;
}
