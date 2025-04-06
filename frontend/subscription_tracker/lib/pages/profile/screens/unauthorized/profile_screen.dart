import 'package:flutter/material.dart';
import 'package:subscription_tracker/pages/profile/screens/unauthorized/widgets/login_button.dart';
import 'package:subscription_tracker/pages/profile/screens/unauthorized/widgets/login_field.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
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
              print('Login via Google');
              // await launchUrl(
              //   Uri.parse('http://alexorel.ru/auth?provider=google'),
              // );
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
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade400),
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

        // email input
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),

          child: EmailField(
            onSubmitted: (value) {
              print(value);
            },
          ),
        ),

        const SizedBox(height: 12.0),

        // password input
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),

          child: PasswordField(
            onSubmitted: (value) {
              print(value);
            },
          ),
        ),

        const SizedBox(height: 12.0),

        // login button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),

          child: FilledLoginButton(
            label: 'Войти',
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              print('Login');
            },
          ),
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
                    print('Register');
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
    );
  }
}
