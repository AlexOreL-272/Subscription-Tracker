import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_bloc.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_state.dart';
import 'package:subscription_tracker/pages/statistics/screens/statistics_screen/statistics_screen.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

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

        title: Text(
          'Статистика',
          style: Theme.of(context).textTheme.titleLarge,
        ),

        centerTitle: true,
      ),

      body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
        builder: (blocBuildCtx, state) {
          return const StatisticsScreen();
        },
      ),
    );
  }
}
