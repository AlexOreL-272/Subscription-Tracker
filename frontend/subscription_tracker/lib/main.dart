import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subscription_tracker/main_screen.dart';
import 'package:subscription_tracker/bloc/category_bloc/category_bloc.dart';
import 'package:subscription_tracker/bloc/subscription_bloc/subscription_bloc.dart';
import 'package:subscription_tracker/bloc/settings_bloc/settings_bloc.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_bloc.dart';
import 'package:subscription_tracker/repo/category_repo/category_repo.dart';
import 'package:subscription_tracker/repo/currency_rates/currency_repo.dart';
import 'package:subscription_tracker/repo/settings_repo/settings_repo.dart';
import 'package:subscription_tracker/repo/subscriptions_repo/subscriptions_repo.dart';
import 'package:subscription_tracker/repo/user_repo/user_repo.dart';
import 'package:subscription_tracker/services/subs_api_service.dart';

final _apiService = SubsApiService.create();

final _categoryRepo = CategoryRepo();
final _currencyRepo = CurrencyRepo();
final _settingsRepo = SettingsRepo();
final _subscriptionsRepo = SubscriptionsRepo();
final _userRepo = UserRepo(apiService: _apiService);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await initializeDateFormatting('ru_RU', null);
  await Hive.initFlutter();

  await _categoryRepo.init();
  await _currencyRepo.initializeCurrencyRates();
  await _settingsRepo.init();
  await _subscriptionsRepo.init();
  await _userRepo.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(categoryRepo: _categoryRepo),
        ),
        BlocProvider<SubscriptionBloc>(
          create: (context) => SubscriptionBloc(subsRepo: _subscriptionsRepo),
        ),
        BlocProvider<UserBloc>(
          create:
              (context) =>
                  UserBloc(userRepo: _userRepo, apiService: _apiService),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(settingsRepo: _settingsRepo),
        ),
        RepositoryProvider<CurrencyRepo>(create: (_) => _currencyRepo),
      ],

      child: const App(),
    ),
  );
}
