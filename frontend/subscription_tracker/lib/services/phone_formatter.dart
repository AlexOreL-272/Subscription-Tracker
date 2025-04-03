import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  bool _isRu = false;

  String _formattingPhone(String text) {
    text = text.replaceAll(RegExp(r'\D'), '');

    if (text.isNotEmpty) {
      String phone = '';
      if (['7', '8', '9'].contains(text[0])) {
        _isRu = true;

        if (text[0] == '9') {
          text = '7' + text;
        } else if (text[0] == '8') {
          text = '7' + text.substring(1);
        }

        String firstSymbols = '+7';
        phone = '$firstSymbols ';

        if (text.length > 1) {
          phone += '(${text.substring(1, text.length < 4 ? text.length : 4)}';
        }
        if (text.length >= 5) {
          phone += ') ${text.substring(4, text.length < 7 ? text.length : 7)}';
        }
        if (text.length >= 8) {
          phone += '-${text.substring(7, text.length < 9 ? text.length : 9)}';
        }
        if (text.length >= 10) {
          phone += '-${text.substring(9, text.length < 11 ? text.length : 11)}';
        }
        return phone;
      } else {
        _isRu = false;
        return '+$text';
      }
    }
    return '';
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String formattedText = _formattingPhone(newValue.text);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
