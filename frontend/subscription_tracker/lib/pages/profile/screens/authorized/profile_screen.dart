import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_bloc.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_event.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_state.dart';
import 'package:subscription_tracker/pages/subscriptions/common/scripts/scripts.dart';
import 'package:subscription_tracker/widgets/divided_list.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final textColor = isDark ? UIBaseColors.textDark : UIBaseColors.textLight;

    final noData = AppLocalizations.of(context)!.noData;

    return BlocBuilder<UserBloc, UserState>(
      buildWhen: (previous, current) {
        return current.authStatus == AuthStatus.authorized;
      },

      builder: (context, state) {
        final fullName = state.fullName ?? noData;
        final splitted = fullName.split(' ');

        final name = splitted.first;
        final middleName = splitted.length > 1 ? splitted.last : noData;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 16.0),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey[300]!),
                    ),

                    child: SizedBox(
                      width: 84.0,
                      height: 84.0,

                      child: Center(
                        child: Text(
                          getInitials(state.fullName ?? 'No Name'),
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: UIBaseColors.textLight,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16.0),

                  Expanded(
                    child: Text(
                      BlocProvider.of<UserBloc>(context).state.fullName ??
                          'No Name',

                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),

              // main info
              Text(
                AppLocalizations.of(context)!.profileYourData,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // main info
              DividedNamedList(
                children: [
                  NamedEntry(
                    name: AppLocalizations.of(context)!.profileSurnameLabel,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        state.surname ?? noData,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),

                  NamedEntry(
                    name: AppLocalizations.of(context)!.profileNameLabel,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(name, style: TextStyle(color: textColor)),
                    ),
                  ),

                  NamedEntry(
                    name: AppLocalizations.of(context)!.profileMiddleNameLabel,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        middleName,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),

                  NamedEntry(
                    name: AppLocalizations.of(context)!.profileEmailLabel,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        state.email ?? noData,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),

              // logout
              Text(
                AppLocalizations.of(context)!.profileAccountManagement,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // logout
              DividedNamedList(
                children: [
                  NamedEntry(
                    name: AppLocalizations.of(context)!.profileLogoutLabel,

                    child: TextButton.icon(
                      onPressed: () {
                        BlocProvider.of<UserBloc>(
                          context,
                        ).add(UserLogOutEvent());
                      },

                      icon: const Icon(Icons.logout),

                      label: Text(
                        AppLocalizations.of(context)!.profileLogoutButtonLabel,

                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
