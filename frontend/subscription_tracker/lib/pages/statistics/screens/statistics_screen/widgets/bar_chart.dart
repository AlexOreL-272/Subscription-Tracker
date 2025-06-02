import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/common/scripts/scripts.dart';
import 'package:subscription_tracker/bloc/settings_bloc/settings_bloc.dart';
import 'package:subscription_tracker/bloc/subscription_bloc/subscription_bloc.dart';
import 'package:subscription_tracker/models/subscription_model.dart';
import 'package:subscription_tracker/pages/statistics/screens/statistics_screen/common/scripts/scripts.dart';
import 'package:subscription_tracker/repo/currency_rates/currency_repo.dart';
import 'package:subscription_tracker/services/shared_data.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class YearlyExpenseBarChart extends StatefulWidget {
  const YearlyExpenseBarChart({super.key});

  @override
  State<YearlyExpenseBarChart> createState() => _YearlyExpenseBarChartState();
}

class _YearlyExpenseBarChartState extends State<YearlyExpenseBarChart> {
  late List<double> _monthlyTotals;
  late double _total;
  late double _maxTotal;

  late DateTime _monthStart;
  late final List<String> _monthLabels;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _monthStart = DateTime(now.year, now.month);

    _monthLabels = List.generate(12, (i) {
      final date = DateTime(_monthStart.year, _monthStart.month + i);
      final lang = BlocProvider.of<SettingsBloc>(context).state.language;
      final isRussian = lang == 'ru';
      final CustomDateFormat shortDateFormat = CustomDateFormat.MMM(
        isRussian: isRussian,
      );
      return shortDateFormat.format(date);
    });

    _monthlyTotals = _calculateMonthlyExpenses(
      context,

      BlocProvider.of<SubscriptionBloc>(
        context,
      ).state.subscriptions.values.toList(),

      _monthStart,
    );

    _total = _monthlyTotals.fold<double>(0, (sum, e) => sum + e);
    _maxTotal = _monthlyTotals.reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final selectedCurrency =
        SharedData.currenciesSymbols[BlocProvider.of<SettingsBloc>(
          context,
        ).state.currency];

    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final uiColor = isDark ? UIBaseColors.dark() : UIBaseColors.light();

    final lang = BlocProvider.of<SettingsBloc>(context).state.language;
    final isRussian = lang == 'ru';

    final CustomDateFormat defaultDateFormat = CustomDateFormat.ddMMMMyyyy(
      isRussian: isRussian,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: uiColor.container,
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
              AppLocalizations.of(context)!.barChartTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: uiColor.secondaryText,
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

                          if (index < 0 || index >= _monthLabels.length) {
                            return const SizedBox();
                          }

                          return Text(
                            _monthLabels[index],
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

                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: _total / 12,
                        color: Colors.grey.shade400,
                        label: HorizontalLineLabel(
                          show: true,
                          alignment: Alignment.topCenter,
                          style: Theme.of(context).textTheme.labelMedium,
                          labelResolver: (value) {
                            final label =
                                AppLocalizations.of(context)!.inAverage;
                            return '$label ${value.y.toStringAsFixed(2)} $selectedCurrency';
                          },
                        ),
                      ),
                    ],
                  ),

                  barGroups: List.generate(12, (index) {
                    final value = double.parse(
                      _monthlyTotals[index].toStringAsFixed(2),
                    );

                    final color = _getColorForValue(
                      value,
                      _maxTotal,
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
              '${defaultDateFormat.format(_monthStart)} - ${defaultDateFormat.format(DateTime(_monthStart.year + 1, _monthStart.month).subtract(const Duration(days: 1)))}',
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
    BuildContext context,
    List<SubscriptionModel> subs,
    DateTime startMonth,
  ) {
    final selectedCurrency =
        BlocProvider.of<SettingsBloc>(context).state.currency;

    final currencyRepo = RepositoryProvider.of<CurrencyRepo>(context);

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

          total += currencyRepo.convert(
            trialCharges * sub.trialCost!,
            sub.currency,
            selectedCurrency,
          );

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

            total += currencyRepo.convert(
              regularCharges * sub.cost,
              sub.currency,
              selectedCurrency,
            );
          }
        } else {
          final regularCharges = countCharges(
            start: monthStart,
            end: monthEnd,
            firstPay: sub.firstPay,
            intervalDays: sub.interval,
            cutoff: endDate,
          );

          total += currencyRepo.convert(
            regularCharges * sub.cost,
            sub.currency,
            selectedCurrency,
          );
        }

        totals[i] += total;
      }
    }

    return totals;
  }
}
