import 'package:flutter/material.dart';
import 'package:subscription_tracker/pages/profile/screens/register/widgets/register_form.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final uiColor = isDark ? UIBaseColors.dark() : UIBaseColors.light();

    return Scaffold(
      backgroundColor: uiColor.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,

        title: Text(
          AppLocalizations.of(context)!.registerScreenTitle,
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
              AppLocalizations.of(context)!.cancelDialogOption,
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
