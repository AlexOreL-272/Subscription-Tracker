import 'package:flutter/material.dart';

const textTheme = TextTheme(
  bodySmall: TextStyle(
    fontFamily: "Graphik LCG",
    color: Colors.grey,
    fontWeight: FontWeight.w100,
    fontSize: 16.0,
    height: 19.2 / 16.0,
  ),

  bodyMedium: TextStyle(
    fontFamily: "Graphik LCG",
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 14.0,
  ),

  bodyLarge: TextStyle(
    fontFamily: "Graphik LCG",
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 32.0,
    height: 38.4 / 32.0,
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
