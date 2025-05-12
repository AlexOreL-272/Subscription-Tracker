import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/bloc/subscription_bloc/subscription_bloc.dart';
import 'package:subscription_tracker/bloc/subscription_bloc/subscription_state.dart';
import 'package:subscription_tracker/pages/statistics/screens/calendar_screen/calendar_screen.dart';
import 'package:subscription_tracker/pages/statistics/screens/calendar_screen/widgets/tab_selector.dart';
import 'package:subscription_tracker/pages/statistics/screens/statistics_screen/statistics_screen.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with TickerProviderStateMixin {
  final _tabs = [const StatisticsScreen(), const CalendarScreen()];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          AppLocalizations.of(context)!.statisticsPageTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),

        centerTitle: true,

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),

          child: Padding(
            padding: const EdgeInsets.all(16.0),

            child: TabSelector(
              tabController: _tabController,
              labels: <Widget>[
                const Center(child: Text('Статистика')),

                const Center(child: Text('Календарь')),
              ],

              onChanged: (value) {},
            ),
          ),
        ),
      ),

      body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
        builder: (blocBuildCtx, state) {
          return TabBarView(controller: _tabController, children: _tabs);
        },
      ),
    );
  }
}
