import 'package:flutter/material.dart';
import 'package:subscription_tracker/pages/statistics/screens/statistics_screen/widgets/bar_chart.dart';
import 'package:subscription_tracker/pages/statistics/screens/statistics_screen/widgets/pie_chart.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),

      child: SingleChildScrollView(
        clipBehavior: Clip.none,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            const SizedBox(height: 16.0),

            const DonutChart(),

            const SizedBox(height: 16.0),

            const YearlyExpenseBarChart(),

            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
