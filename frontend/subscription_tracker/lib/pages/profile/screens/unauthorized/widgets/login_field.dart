import 'package:flutter/material.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class EmailField extends StatefulWidget {
  final ValueChanged<String> onSubmitted;

  const EmailField({required this.onSubmitted, super.key});

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,

      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.alternate_email_rounded),
        prefixIconColor: Colors.black,

        hintText: 'E-Mail',
        hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: WasubiColors.wasubiNeutral[400]!,
        ),

        labelText: 'E-Mail',
        labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: WasubiColors.wasubiNeutral[400]!,
        ),
        floatingLabelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
        alignLabelWithHint: true,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: WasubiColors.wasubiNeutral[400]!,
            width: 2.0,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: WasubiColors.wasubiNeutral[400]!,
            width: 2.0,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: const Color(0xFFFF5722), width: 2.0),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: WasubiColors.wasubiNeutral[400]!,
            width: 2.0,
          ),
        ),

        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
        isDense: true,

        constraints: BoxConstraints(minHeight: 44.0, maxHeight: 44.0),
      ),

      style: Theme.of(context).textTheme.titleMedium,

      onSubmitted: widget.onSubmitted,
      onTapOutside: (event) {
        widget.onSubmitted(_controller.text);
        FocusScope.of(context).unfocus();
      },
    );
  }
}

class PasswordField extends StatefulWidget {
  final ValueChanged<String> onSubmitted;

  const PasswordField({required this.onSubmitted, super.key});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isPasswordVisible = false;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,

      obscureText: !_isPasswordVisible,
      keyboardType: TextInputType.visiblePassword,

      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline_rounded),
        prefixIconColor: Colors.black,

        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },

          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
          ),
        ),

        hintText: 'Пароль',
        hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: WasubiColors.wasubiNeutral[400]!,
        ),

        labelText: 'Пароль',
        labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: WasubiColors.wasubiNeutral[400]!,
        ),
        floatingLabelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
        alignLabelWithHint: true,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: WasubiColors.wasubiNeutral[400]!,
            width: 2.0,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: WasubiColors.wasubiNeutral[400]!,
            width: 2.0,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: const Color(0xFFFF5722), width: 2.0),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
            color: WasubiColors.wasubiNeutral[400]!,
            width: 2.0,
          ),
        ),

        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
        isDense: true,

        constraints: BoxConstraints(minHeight: 44.0, maxHeight: 44.0),
      ),

      style: Theme.of(context).textTheme.titleMedium,

      onSubmitted: widget.onSubmitted,
      onTapOutside: (event) {
        widget.onSubmitted(_controller.text);
        FocusScope.of(context).unfocus();
      },
    );
  }
}
