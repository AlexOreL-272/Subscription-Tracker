import 'package:flutter/services.dart';

class NameFormatter extends TextInputFormatter {
  const NameFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String text = newValue.text.trim();

    if (text.isEmpty) {
      return TextEditingValue(text: text);
    }

    return TextEditingValue(
      text: '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}',
    );
  }
}
