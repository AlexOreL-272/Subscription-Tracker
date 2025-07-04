import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_bloc.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_state.dart';
import 'package:subscription_tracker/pages/profile/screens/settings/settings.screen.dart';
import 'package:subscription_tracker/pages/profile/screens/unauthorized/profile_screen.dart'
    as unauthorized;
import 'package:subscription_tracker/pages/profile/screens/authorized/profile_screen.dart'
    as authorized;
import 'package:subscription_tracker/widgets/theme_definitor.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final backgroundColor =
        isDark ? UIBaseColors.backgroundDark : UIBaseColors.backgroundLight;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,

        title: Text(
          AppLocalizations.of(context)!.profilePageTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),

        centerTitle: true,

        actionsIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined),

            onPressed: () {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),

                clipBehavior: Clip.hardEdge,

                builder: (bottomSheetCtx) {
                  return BlocProvider.value(
                    value: BlocProvider.of<UserBloc>(context),

                    child: SettingsScreen(),
                  );
                },
              );
            },
          ),
        ],
      ),

      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          switch (state.authStatus) {
            case AuthStatus.unauthorized:
              return const unauthorized.ProfileScreen();
            case AuthStatus.authorized:
              return const authorized.ProfileScreen();
            default:
              return const unauthorized.ProfileScreen();
          }
        },
      ),
    );
  }
}
