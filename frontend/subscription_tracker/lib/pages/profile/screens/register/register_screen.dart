import 'package:flutter/material.dart';
import 'package:subscription_tracker/pages/profile/screens/register/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.brightness == Brightness.dark
              ? Color(0xFF121212)
              : Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,

        title: Text(
          'Регистрация',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),

        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),

          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },

            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
            ),

            child: Text(
              'Отмена',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),

      body: const RegisterForm(),
    );
  }
}
