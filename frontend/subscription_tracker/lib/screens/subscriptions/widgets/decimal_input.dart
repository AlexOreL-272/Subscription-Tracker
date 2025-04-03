import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecimalInput extends StatefulWidget {
  final double? value;
  final String currency;
  final ValueChanged<String>? onChanged;
  final TextStyle? textStyle;

  const DecimalInput({
    this.value,
    required this.currency,
    this.textStyle,
    this.onChanged,
    super.key,
  });

  @override
  State<DecimalInput> createState() => _DecimalInputState();
}

class _DecimalInputState extends State<DecimalInput> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController(
      text: widget.value?.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,

      children: [
        SizedBox(
          width: 200.0,

          child: TextFormField(
            controller: _textController,

            textAlign: TextAlign.right,
            textAlignVertical: TextAlignVertical.center,

            keyboardType: TextInputType.numberWithOptions(decimal: true),

            inputFormatters: [CurrencyInputFormatter()],

            decoration: InputDecoration(
              hintText: '0.00',
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 1.0),
              isDense: true,
            ),

            style: widget.textStyle,

            onFieldSubmitted: (value) {
              value = _formatValue(value);

              _textController.text = value;
              widget.onChanged?.call(value);
            },

            onTapOutside: (_) {
              final value = _formatValue(_textController.text);

              _textController.text = value;
              widget.onChanged?.call(value);
            },
          ),
        ),

        const SizedBox(width: 4.0),

        Text(widget.currency, style: widget.textStyle),
      ],
    );
  }

  String _formatValue(String value) {
    if (value.isEmpty) return '';

    List<String> parts = value.split('.');

    if (parts.length == 1) {
      return '${parts[0]}.00';
    }

    String formattedPrefix = parts[0];
    String formattedSuffix = parts[1];

    if (parts[0].isEmpty) {
      formattedPrefix = '0';
    }

    if (parts[1].isEmpty) {
      formattedSuffix = '00';
    } else if (parts[1].length == 1) {
      formattedSuffix = '${parts[1]}0';
    }

    if (formattedPrefix.length > 1 && formattedPrefix[0] == '0') {
      formattedPrefix = formattedPrefix.replaceFirst('0', '');
    }

    return '$formattedPrefix.$formattedSuffix';
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    if (newValue.text.length < oldValue.text.length) return newValue;

    final regex = RegExp(r'^([1-9]\d*|0)(\.\d{0,2})?$');

    if (regex.hasMatch(newValue.text)) {
      return newValue;
    }

    if (newValue.text.endsWith('.') && !oldValue.text.contains('.')) {
      return newValue.copyWith(
        text: '${oldValue.text}.',
        selection: TextSelection.collapsed(
          offset: newValue.selection.extentOffset,
        ),
      );
    }

    return oldValue;
  }
}
