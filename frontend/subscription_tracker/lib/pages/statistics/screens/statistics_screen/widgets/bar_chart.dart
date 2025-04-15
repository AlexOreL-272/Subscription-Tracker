import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/common/scripts/scripts.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_bloc.dart';
import 'package:subscription_tracker/models/subscription_model.dart';
import 'package:subscription_tracker/pages/statistics/screens/statistics_screen/common/scripts/scripts.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class YearlyExpenseBarChart extends StatelessWidget {
  static const _shortDateFormat = RussianDateFormat.MMM();
  static const _defaultDateFormat = RussianDateFormat.ddMMMMyyyy();

  const YearlyExpenseBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final subscriptions =
        BlocProvider.of<SubscriptionBloc>(
          context,
        ).state.subscriptions.values.toList();

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month);
    final monthLabels = List.generate(12, (i) {
      final date = DateTime(monthStart.year, monthStart.month + i);
      return _shortDateFormat.format(date);
    });

    final monthlyTotals = _calculateMonthlyExpenses(subscriptions, monthStart);
    final maxTotal = monthlyTotals.reduce((a, b) => a > b ? a : b);

    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.brightness == Brightness.dark
                ? Color(0xFF282828)
                : WasubiColors.wasubiNeutral[100]!,
        borderRadius: BorderRadius.circular(8.0),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 2.0,
            spreadRadius: 1.0,
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Text(
              'Расходы за следующий год',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color:
                    Theme.of(context).colorScheme.brightness == Brightness.dark
                        ? Colors.white
                        : WasubiColors.wasubiNeutral[600]!,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16.0),

            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 200.0,

              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,

                        getTitlesWidget: (value, meta) {
                          final index = _sanitizeValue(value).toInt();

                          if (index < 0 || index >= monthLabels.length) {
                            return const SizedBox();
                          }

                          return Text(
                            monthLabels[index],
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(fontWeight: FontWeight.w400),
                          );
                        },

                        interval: 1.0,
                      ),
                    ),

                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        reservedSize: 40,
                      ),
                    ),

                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),

                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true),

                  barGroups: List.generate(12, (index) {
                    final value = double.parse(
                      monthlyTotals[index].toStringAsFixed(2),
                    );

                    final color = _getColorForValue(
                      value,
                      maxTotal,
                      low: Color(0xFF81C784),
                      mid: Color(0xFFFFF176),
                      high: Color(0xFFE57373),
                    );

                    return BarChartGroupData(
                      x: index,

                      barRods: [
                        BarChartRodData(
                          toY: value,

                          color: color,
                          width: 20.0,

                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6.0),
                            topRight: Radius.circular(6.0),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 8.0),

            Text(
              '${_defaultDateFormat.format(monthStart)} - ${_defaultDateFormat.format(DateTime(monthStart.year + 1, monthStart.month).subtract(const Duration(days: 1)))}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  double _sanitizeValue(double value) {
    if (value.isNaN || value.isInfinite) return 0;
    return value;
  }

  Color _getColorForValue(
    double value,
    double maxValue, {
    Color low = Colors.green,
    Color mid = Colors.yellow,
    Color high = Colors.red,
  }) {
    final ratio = value / maxValue;

    if (ratio < 0.5) {
      return Color.lerp(low, mid, ratio * 2)!;
    } else {
      return Color.lerp(mid, high, (ratio - 0.5) * 2)!;
    }
  }

  List<double> _calculateMonthlyExpenses(
    List<SubscriptionModel> subs,
    DateTime startMonth,
  ) {
    final totals = List<double>.filled(12, 0.0);

    for (final sub in subs) {
      if (!sub.isActive) continue;

      for (int i = 0; i < 12; i++) {
        final monthStart = DateTime(startMonth.year, startMonth.month + i);

        final monthEnd = DateTime(
          monthStart.year,
          monthStart.month + 1,
        ).subtract(const Duration(days: 1));

        final endDate = sub.endDate ?? monthEnd;

        double total = 0.0;

        if (sub.trialActive &&
            sub.trialEndDate != null &&
            sub.trialInterval != null &&
            sub.trialCost != null) {
          final trialCharges = countCharges(
            start: monthStart,
            end: monthEnd,
            firstPay: sub.firstPay,
            intervalDays: sub.trialInterval!,
            cutoff:
                sub.trialEndDate!.isBefore(endDate)
                    ? sub.trialEndDate!
                    : endDate,
          );
          total += trialCharges * sub.trialCost!;

          if (sub.trialEndDate!.isBefore(monthEnd)) {
            final postTrialStart = sub.trialEndDate!.add(
              const Duration(days: 1),
            );

            final regularCharges = countCharges(
              start: monthStart,
              end: monthEnd,
              firstPay: postTrialStart,
              intervalDays: sub.interval,
              cutoff: endDate,
            );
            total += regularCharges * sub.cost;
          }
        } else {
          final regularCharges = countCharges(
            start: monthStart,
            end: monthEnd,
            firstPay: sub.firstPay,
            intervalDays: sub.interval,
            cutoff: endDate,
          );
          total += regularCharges * sub.cost;
        }

        totals[i] += total;
      }
    }

    return totals;
  }
}
