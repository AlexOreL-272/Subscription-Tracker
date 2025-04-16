import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subscription_tracker/main_screen.dart';
import 'package:subscription_tracker/models/category_bloc/category_bloc.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_bloc.dart';
import 'package:subscription_tracker/models/settings_bloc/settings_bloc.dart';
import 'package:subscription_tracker/models/user_bloc/user_bloc.dart';
import 'package:subscription_tracker/repo/currency_rates/currency_repo.dart';

final _currencyRepo = CurrencyRepo();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU', null);
  await Hive.initFlutter();
  await _currencyRepo.initializeCurrencyRates();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CategoryBloc>(create: (context) => CategoryBloc()),
        BlocProvider<SubscriptionBloc>(create: (context) => SubscriptionBloc()),
        BlocProvider<UserBloc>(create: (context) => UserBloc()),
        BlocProvider<SettingsBloc>(create: (context) => SettingsBloc()),
        RepositoryProvider<CurrencyRepo>(create: (_) => _currencyRepo),
      ],

      child: const App(),
    ),
  );
}
