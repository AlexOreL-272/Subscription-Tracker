import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_bloc.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_event.dart';
import 'package:subscription_tracker/pages/profile/screens/register/register_screen.dart';
import 'package:subscription_tracker/pages/profile/screens/unauthorized/widgets/login_button.dart';
import 'package:subscription_tracker/pages/profile/screens/unauthorized/widgets/login_form.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          const SizedBox(height: 72.0),

          // header text
          Align(
            alignment: Alignment.center,

            child: Text(
              'Добро пожаловать!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),

          const SizedBox(height: 8.0),

          // title text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),

            child: Align(
              alignment: Alignment.center,

              child: Text(
                'Войдите в аккаунт, чтобы синхронизировать данные между устройствами',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 16.0),

          // google login button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),

            child: OutlinedLoginButton(
              label: 'Войти через Google',
              icon: Icons.g_translate_outlined,
              color: Color(0xFFECA519),
              onPressed: () async {
                BlocProvider.of<UserBloc>(context).add(UserGoogleAuthEvent());
              },
            ),
          ),

          const SizedBox(height: 12.0),

          // yandex login button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),

            child: OutlinedLoginButton(
              label: 'Войти через Yandex',
              icon: Icons.currency_yen_sharp,
              color: Color(0xFFDE3B40),
              onPressed: () {
                print('Login via Yandex');
              },
            ),
          ),

          const SizedBox(height: 48.0),

          // divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade400,
                    height: 1,
                    endIndent: 8.0,
                  ),
                ),

                Text(
                  'Или',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade400,
                  ),
                ),

                Expanded(
                  child: Divider(
                    color: Colors.grey.shade400,
                    height: 1,
                    indent: 8.0,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 48.0),

          // login form
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),

            child: const LoginForm(),
          ),

          const SizedBox(height: 8.0),

          // register row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Text(
                  'Нет аккаунта?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: WasubiColors.wasubiNeutral[600]!,
                  ),
                ),

                SizedBox(
                  height: 36.0,

                  child: TextButton(
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          isDismissible: false,
                          useSafeArea: true,

                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                          ),

                          clipBehavior: Clip.hardEdge,

                          builder: (context) {
                            return RegisterScreen();
                          },
                        );
                      });
                    },

                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      splashFactory: NoSplash.splashFactory,
                    ),

                    child: Text(
                      'Зарегистрироваться',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
