import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/models/user_bloc/user_bloc.dart';
import 'package:subscription_tracker/models/user_bloc/user_event.dart';
import 'package:subscription_tracker/models/user_bloc/user_state.dart';
import 'package:subscription_tracker/pages/profile/screens/unauthorized/widgets/login_button.dart'
    as login;
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class _EmailField extends StatefulWidget {
  final ValueChanged<String> onSubmitted;

  const _EmailField({required this.onSubmitted});

  @override
  State<_EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<_EmailField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasError = false;

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

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      widget.onSubmitted(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final textColor = isDark ? UIBaseColors.textDark : UIBaseColors.textLight;

    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,

      validator: (email) {
        setState(() {
          _hasError = !(email != null && EmailValidator.validate(email));
        });

        if (email == null) {
          return 'Введите e-mail';
        }

        if (_hasError) {
          return 'Неверный формат e-mail';
        }

        return null;
      },

      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.alternate_email_rounded),
        prefixIconColor: textColor,

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

        errorStyle: TextStyle(color: Color(0xFFFF5722)),

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

        constraints: BoxConstraints(
          minHeight: 44.0,
          maxHeight: _hasError ? 64.0 : 44.0,
        ),
      ),

      style: Theme.of(context).textTheme.titleMedium,

      onFieldSubmitted: widget.onSubmitted,
      onTapOutside: (event) {
        widget.onSubmitted(_controller.text);
        _focusNode.unfocus();
      },
    );
  }
}

class _PasswordField extends StatefulWidget {
  final ValueChanged<String> onSubmitted;

  const _PasswordField({required this.onSubmitted});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _isPasswordVisible = false;
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

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      widget.onSubmitted(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final textColor = isDark ? UIBaseColors.textDark : UIBaseColors.textLight;

    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,

      obscureText: !_isPasswordVisible,
      keyboardType: TextInputType.visiblePassword,

      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline_rounded),
        prefixIconColor: textColor,

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

      onFieldSubmitted: widget.onSubmitted,
      onTapOutside: (event) {
        widget.onSubmitted(_controller.text);
        _focusNode.unfocus();
      },
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _submittedEmail = '';
  String _submittedPassword = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'Произошла ошибка',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.red,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
            ),
          );
        }
      },

      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return Form(
            key: _formKey,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,

              children: [
                // email input
                _EmailField(
                  onSubmitted: (value) {
                    _submittedEmail = value;
                  },
                ),

                const SizedBox(height: 12.0),

                // password input
                _PasswordField(
                  onSubmitted: (value) {
                    _submittedPassword = value;
                  },
                ),

                const SizedBox(height: 10.0),

                // login button
                login.FilledButton(
                  label:
                      state.authStatus == AuthStatus.pending
                          ? 'Входим...'
                          : 'Войти',

                  color: Theme.of(context).colorScheme.primary,
                  height: 44.0,

                  isLoading: state.authStatus == AuthStatus.pending,

                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<UserBloc>(context).add(
                        UserLogInEvent(_submittedEmail, _submittedPassword),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
