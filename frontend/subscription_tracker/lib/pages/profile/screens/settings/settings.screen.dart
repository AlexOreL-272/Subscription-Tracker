import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/bloc/settings_bloc/settings_bloc.dart';
import 'package:subscription_tracker/bloc/settings_bloc/settings_event.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_bloc.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_event.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_state.dart';
import 'package:subscription_tracker/pages/profile/screens/settings/widgets/color_picker.dart';
import 'package:subscription_tracker/pages/profile/screens/settings/widgets/delete_button.dart';
import 'package:subscription_tracker/services/shared_data.dart';
import 'package:subscription_tracker/widgets/currency_selector.dart';
import 'package:subscription_tracker/widgets/divided_list.dart';
import 'package:subscription_tracker/widgets/named_switch.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final uiColor = isDark ? UIBaseColors.dark() : UIBaseColors.light();

    return Scaffold(
      backgroundColor: uiColor.background,

      appBar: AppBar(
        backgroundColor: uiColor.background,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          AppLocalizations.of(context)!.settingsScreenTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Main settings
              Text(
                AppLocalizations.of(context)!.settingsMainSectionTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Main settings
              DividedNamedList(
                children: [
                  // Language
                  NamedEntry(
                    name:
                        AppLocalizations.of(
                          context,
                        )!.settingsLanguageSectionTitle,

                    child: TextToggleSwitch(
                      options: ['Русский', 'English'],

                      initialIndex:
                          BlocProvider.of<SettingsBloc>(
                                    context,
                                  ).state.language ==
                                  'ru'
                              ? 0
                              : 1,

                      onChanged: (value) {
                        final locale = value == 0 ? 'ru' : 'en';

                        BlocProvider.of<SettingsBloc>(
                          context,
                        ).add(UpdateLanguageEvent(locale));
                      },

                      height: NamedEntry.contentHeight,

                      inactiveColor: WasubiColors.wasubiNeutral[400]!,
                      indicatorColor:
                          Theme.of(context).colorScheme.primaryFixedDim,
                    ),
                  ),

                  // Theme mode
                  NamedEntry(
                    name:
                        AppLocalizations.of(context)!.settingsThemeSectionTitle,

                    child: TextToggleSwitch(
                      initialIndex:
                          BlocProvider.of<SettingsBloc>(context).state.isDark
                              ? 1
                              : 0,

                      options: [
                        AppLocalizations.of(context)!.settingsLightThemeLabel,
                        AppLocalizations.of(context)!.settingsDarkThemeLabel,
                      ],
                      onChanged: (value) {
                        BlocProvider.of<SettingsBloc>(
                          context,
                        ).add(UpdateUIDarkModeEvent(value == 1));
                      },

                      height: NamedEntry.contentHeight,

                      inactiveColor: WasubiColors.wasubiNeutral[400]!,
                      indicatorColor:
                          Theme.of(context).colorScheme.primaryFixedDim,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12.0),

              // Currency selector
              DividedNamedList(
                children: [
                  NamedEntry(
                    name:
                        AppLocalizations.of(
                          context,
                        )!.settingsCurrencySectionTitle,

                    child: CurrencySelector(
                      currency:
                          BlocProvider.of<SettingsBloc>(context).state.currency,

                      colorScheme: ColorScheme.fromSeed(
                        seedColor:
                            BlocProvider.of<SettingsBloc>(context).state.color,

                        dynamicSchemeVariant:
                            isDark
                                ? DynamicSchemeVariant.tonalSpot
                                : DynamicSchemeVariant.vibrant,
                      ),

                      onChanged: (value) {
                        if (value.isEmpty ||
                            value ==
                                BlocProvider.of<SettingsBloc>(
                                  context,
                                ).state.currency) {
                          return;
                        }

                        BlocProvider.of<SettingsBloc>(
                          context,
                        ).add(UpdateCurrencyEvent(value));
                      },
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),

                child: Text(
                  AppLocalizations.of(
                    context,
                  )!.settingsCurrencySectionDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: uiColor.secondaryText,
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // UI color mode
              Text(
                AppLocalizations.of(context)!.settingsUISectionTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              UIColorPicker(
                color: BlocProvider.of<SettingsBloc>(context).state.color,
                onChanged: (color) {
                  BlocProvider.of<SettingsBloc>(
                    context,
                  ).add(UpdateUIColorEvent(color));
                },
              ),

              const SizedBox(height: 16.0),

              // Dev info
              Text(
                AppLocalizations.of(context)!.settingsContactInfoSectionTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Dev contact info
              DividedNamedList(
                children: [
                  NamedEntry(
                    name: AppLocalizations.of(context)!.settingsEmailLabel,

                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(SharedData.devEmail),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),

                child: Text(
                  AppLocalizations.of(context)!.settingsSupportDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: uiColor.secondaryText,
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // danger zone
              ExpandableDividedNamedList(
                label:
                    AppLocalizations.of(
                      context,
                    )!.settingsDangerZoneSectionTitle,

                trackColor:
                    isDark ? Theme.of(context).colorScheme.primary : null,

                children: [
                  NamedEntry(
                    name:
                        AppLocalizations.of(
                          context,
                        )!.settingsDeleteAllDataLabel,

                    child: DeleteButton(
                      onPressed: () {
                        print('Delete all data');
                      },
                    ),
                  ),

                  if (BlocProvider.of<UserBloc>(context).state.authStatus ==
                      AuthStatus.authorized) ...{
                    NamedEntry(
                      name:
                          AppLocalizations.of(
                            context,
                          )!.settingsDeleteAccountLabel,

                      child: DeleteButton(
                        onPressed: () async {
                          final isDeleted = await showDialog(
                            context: context,
                            builder: (context) {
                              return _DeleteDialog();
                            },
                          );

                          if (!isDeleted) {
                            return;
                          }

                          BlocProvider.of<UserBloc>(
                            context,
                          ).add(UserLogOutEvent());

                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  },
                ],
              ),

              const SizedBox(height: 32.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),

                child: Text(
                  AppLocalizations.of(context)!.settingsAnnotation,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: uiColor.secondaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteDialog extends StatelessWidget {
  const _DeleteDialog();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
        isDark ? UIBaseColors.backgroundDark : UIBaseColors.backgroundLight;

    return AlertDialog(
      title: const Text('Удалить аккаунт'),
      content: Text(
        'Вы уверены, что хотите удалить Ваш аккаунт? Сохраненные подписки останутся на Вашем устройстве',
      ),

      backgroundColor: backgroundColor,

      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Отмена'),
        ),

        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },

          child: const Text('Удалить'),
        ),
      ],
    );
  }
}
