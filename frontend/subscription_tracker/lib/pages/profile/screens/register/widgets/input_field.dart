import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class InputField extends StatefulWidget {
  final String label;
  final TextInputType? keyboardType;

  final bool obscureText;

  final ValueChanged<String> onSubmitted;
  final List<TextInputFormatter> formatters;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  const InputField({
    required this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    required this.onSubmitted,
    this.formatters = const [],
    this.validator,
    this.autovalidateMode,
    super.key,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,

      inputFormatters: widget.formatters,
      validator: widget.validator,

      textAlign: TextAlign.left,
      textAlignVertical: TextAlignVertical.center,

      obscureText: widget.obscureText,

      decoration: InputDecoration(
        hintText: widget.label,
        hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: WasubiColors.wasubiNeutral[400]!,
        ),

        labelText: widget.label,
        labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: WasubiColors.wasubiNeutral[400]!,
        ),
        floatingLabelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
        alignLabelWithHint: true,

        errorStyle: TextStyle(color: Color(0xFFFF5722)),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: WasubiColors.wasubiNeutral[400]!,
            width: 2.0,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: WasubiColors.wasubiNeutral[400]!,
            width: 2.0,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: const Color(0xFFFF5722), width: 2.0),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: WasubiColors.wasubiNeutral[400]!,
            width: 2.0,
          ),
        ),

        contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 0.0, 10.0),
        isDense: true,

        constraints: BoxConstraints(
          minHeight: 40.0,
          maxHeight: widget.validator == null ? 40.0 : 60.0,
        ),
      ),

      style: Theme.of(context).textTheme.titleSmall,

      autovalidateMode: widget.autovalidateMode,

      onFieldSubmitted: widget.onSubmitted,
      onTapOutside: (event) {
        widget.onSubmitted(_controller.text);
        _focusNode.unfocus();
      },
    );
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      widget.onSubmitted(_controller.text);
    }
  }
}
