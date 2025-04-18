import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/models/user_bloc/user_bloc.dart';
import 'package:subscription_tracker/models/user_bloc/user_event.dart';
import 'package:subscription_tracker/models/user_bloc/user_state.dart';
import 'package:subscription_tracker/pages/profile/screens/register/scripts/name_formatter.dart';
import 'package:subscription_tracker/pages/profile/screens/register/widgets/input_field.dart';
import 'package:subscription_tracker/pages/profile/screens/unauthorized/widgets/login_button.dart'
    as register;

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  String _submittedSurname = '';
  String _submittedName = '';
  String _submittedMiddleName = '';
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

            canPop: true,
            onPopInvokedWithResult: (didPop, result) {
              // if (didPop) {
              //   Navigator.of(context).pop();
              // }
            },

            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,

                spacing: 12.0,

                children: [
                  // surname
                  InputField(
                    label: 'Фамилия',
                    formatters: [const NameFormatter()],
                    validator: (surname) {
                      if (surname == null || surname.isEmpty) {
                        return 'Введите фамилию';
                      }

                      return null;
                    },
                    onSubmitted: (surname) {
                      _submittedSurname = surname;
                    },
                  ),

                  // name
                  InputField(
                    label: 'Имя',
                    formatters: [const NameFormatter()],
                    validator: (name) {
                      if (name == null || name.isEmpty) {
                        return 'Введите имя';
                      }

                      return null;
                    },
                    onSubmitted: (name) {
                      _submittedName = name;
                    },
                  ),

                  // middle name
                  InputField(
                    label: 'Отчество',
                    formatters: [const NameFormatter()],
                    onSubmitted: (middleName) {
                      _submittedMiddleName = middleName;
                    },
                  ),

                  // email
                  InputField(
                    label: 'E-Mail',
                    validator: (email) {
                      if (email == null || !EmailValidator.validate(email)) {
                        return 'Неверный формат e-mail';
                      }

                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    onSubmitted: (email) {
                      _submittedEmail = email;
                    },
                  ),

                  // password
                  InputField(
                    label: 'Пароль',
                    obscureText: true,
                    onSubmitted: (password) {
                      setState(() {
                        _submittedPassword = password;
                      });
                    },
                  ),

                  // repeat password
                  InputField(
                    label: 'Повторите пароль',
                    validator: (password) {
                      if (password != _submittedPassword) {
                        return 'Пароли не совпадают';
                      }

                      return null;
                    },
                    autovalidateMode: AutovalidateMode.always,
                    obscureText: true,
                    onSubmitted: (password) {},
                  ),

                  // register button
                  register.FilledButton(
                    label: 'Зарегистрироваться',
                    color: Theme.of(context).colorScheme.primary,
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 36.0,

                    isLoading: state.authStatus == AuthStatus.pending,

                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<UserBloc>(context).add(
                          UserRegisterEvent(
                            _submittedSurname,
                            _submittedName,
                            _submittedMiddleName,
                            _submittedEmail,
                            _submittedPassword,
                          ),
                        );
                      }

                      // Maybe close the screen when the user is registered and logged in
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
