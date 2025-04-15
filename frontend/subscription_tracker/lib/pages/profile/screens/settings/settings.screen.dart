import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/models/ui_color_bloc/ui_color_bloc.dart';
import 'package:subscription_tracker/models/ui_color_bloc/ui_color_event.dart';
import 'package:subscription_tracker/models/user_bloc/user_bloc.dart';
import 'package:subscription_tracker/models/user_bloc/user_state.dart';
import 'package:subscription_tracker/pages/profile/screens/settings/widgets/color_picker.dart';
import 'package:subscription_tracker/pages/profile/screens/settings/widgets/delete_button.dart';
import 'package:subscription_tracker/services/shared_data.dart';
import 'package:subscription_tracker/widgets/currency_selector.dart';
import 'package:subscription_tracker/widgets/divided_list.dart';
import 'package:subscription_tracker/widgets/named_switch.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.brightness == Brightness.dark
              ? Color(0xFF121212)
              : Colors.white,

      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.brightness == Brightness.dark
                ? Color(0xFF121212)
                : Colors.white,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text('Настройки', style: Theme.of(context).textTheme.titleLarge),

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
                'Основные',
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
                    name: 'Язык',

                    child: TextToggleSwitch(
                      options: ['Русский', 'English'],
                      onChanged: (value) {
                        print('Language changed to $value');
                      },

                      height: NamedEntry.contentHeight,

                      inactiveColor: WasubiColors.wasubiNeutral[400]!,
                      indicatorColor:
                          Theme.of(context).colorScheme.primaryFixedDim,
                    ),
                  ),

                  // Theme mode
                  NamedEntry(
                    name: 'Тема',

                    child: TextToggleSwitch(
                      options: ['Светлая', 'Темная'],
                      onChanged: (value) {
                        BlocProvider.of<UIColorBloc>(
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
                    name: 'Валюта',

                    child: CurrencySelector(
                      currency: 'RUB',
                      onChanged: (value) {
                        print('Currency changed to $value');
                      },
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),

                child: Text(
                  'В этой валюте будет отображаться статистика по подпискам',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: WasubiColors.wasubiNeutral[600]!,
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // UI color mode
              Text(
                'Цвет интерфейса',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              UIColorPicker(
                color: BlocProvider.of<UIColorBloc>(context).state.color,
                onChanged: (color) {
                  BlocProvider.of<UIColorBloc>(
                    context,
                  ).add(UpdateUIColorEvent(color));
                },
              ),

              const SizedBox(height: 16.0),

              // Dev info
              Text(
                'Контактная информация',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Dev contact info
              DividedNamedList(
                children: [
                  NamedEntry(
                    name: 'E-Mail',

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
                  'Свяжитесь со мной если у вас есть вопросы, предложения или Вы заметили ошибку ❤️',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: WasubiColors.wasubiNeutral[600]!,
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              ExpandableDividedNamedList(
                label: 'Необратимые действия',

                children: [
                  NamedEntry(
                    name: 'Удалить все данные',

                    child: DeleteButton(
                      onPressed: () {
                        print('Delete all data');
                      },
                    ),
                  ),

                  if (BlocProvider.of<UserBloc>(context).state.authStatus ==
                      AuthStatus.authorized) ...{
                    NamedEntry(
                      name: 'Удалить аккаунт',

                      child: DeleteButton(
                        onPressed: () {
                          print('Delete account');
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
                  'Выражаю благодарность за помощь в тестировании приложения: Ansam, ED1LOAD, Xenocious',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: WasubiColors.wasubiNeutral[600]!,
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
