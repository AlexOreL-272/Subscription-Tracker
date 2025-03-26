import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subscription_tracker/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);
  runApp(const App());
}
