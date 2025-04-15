import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/common/scripts/scripts.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_bloc.dart';
import 'package:subscription_tracker/models/subscription_model.dart';
import 'package:subscription_tracker/pages/statistics/screens/statistics_screen/common/scripts/scripts.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class DonutChart extends StatefulWidget {
  static const List<Color> _colors = [
    Colors.blueAccent,
    Colors.pinkAccent,
    Colors.tealAccent,
    Colors.deepPurpleAccent,
    Colors.yellow,
  ];

  static const int _maxSections = 5;
  static const String _defaultCategory = 'Остальное';
  static const dateFormat = RussianDateFormat.MMMMyyyy();

  const DonutChart({super.key});

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  double _total = 0.0;
  DateTime _selectedMonth = DateTime.now();
  List<MapEntry<String, double>> sortedCostsPerCategory = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final subscriptions =
        BlocProvider.of<SubscriptionBloc>(
          context,
        ).state.subscriptions.values.toList();

    sortedCostsPerCategory = _calculateMonthlyCategoryStats(
      subscriptions,
      _selectedMonth,
    );

    _total = sortedCostsPerCategory.fold<double>(0, (sum, e) => sum + e.value);

    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.brightness == Brightness.dark
                ? Color(0xFF282828)
                : WasubiColors.wasubiNeutral[100]!,
        borderRadius: BorderRadius.circular(10.0),

        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.brightness == Brightness.dark
                    ? Colors.white.withAlpha(10)
                    : Colors.black.withAlpha(10),
            blurRadius: 2.0,
            spreadRadius: 1.0,
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          const SizedBox(height: 16.0),

          Padding(
            padding: const EdgeInsets.only(left: 16.0),

            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Expanded(
                  child: Text(
                    'Траты за',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color:
                          Theme.of(context).colorScheme.brightness ==
                                  Brightness.dark
                              ? Colors.white
                              : WasubiColors.wasubiNeutral[600]!,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Text(
                  DonutChart.dateFormat.format(_selectedMonth),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color:
                        Theme.of(context).colorScheme.brightness ==
                                Brightness.dark
                            ? Colors.white
                            : WasubiColors.wasubiNeutral[600]!,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  visualDensity: VisualDensity.compact,

                  onPressed: () {
                    setState(() {
                      _selectedMonth = DateTime(
                        _selectedMonth.year,
                        _selectedMonth.month - 1,
                      );
                    });
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  visualDensity: VisualDensity.compact,

                  onPressed: () {
                    setState(() {
                      _selectedMonth = DateTime(
                        _selectedMonth.year,
                        _selectedMonth.month + 1,
                      );
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16.0),

          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300.0,

            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0.0,
                    centerSpaceRadius: 100.0,
                    startDegreeOffset: -90.0,
                    sections: _showingSections(context),
                  ),
                ),

                Text(
                  '${_total.toStringAsFixed(2)} ₽',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32.0),

          _Legend(labels: sortedCostsPerCategory.map((e) => e.key).toList()),

          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections(BuildContext context) {
    return List<PieChartSectionData>.generate(
      min(sortedCostsPerCategory.length, DonutChart._maxSections),

      (index) {
        final cost = sortedCostsPerCategory[index].value;

        return PieChartSectionData(
          color: DonutChart._colors[index],
          value: cost + 1e-3,
          showTitle: false,
          title: cost.toStringAsFixed(2),
          radius: 40,
        );
      },
    );
  }

  // TODO: add currency conversion
  Map<String, double> _getMonthlyCategoryCostsWithTrial(
    List<SubscriptionModel> subscriptions,
    DateTime selectedMonth,
  ) {
    final monthStart = DateTime(selectedMonth.year, selectedMonth.month);
    final monthEnd = DateTime(
      selectedMonth.year,
      selectedMonth.month + 1,
    ).subtract(Duration(days: 1));

    final Map<String, double> categoryTotals = {};

    for (var sub in subscriptions) {
      if (!sub.isActive) continue;

      final category =
          sub.category == null || sub.category == 'Все'
              ? DonutChart._defaultCategory
              : sub.category!;

      final effectiveEnd =
          sub.endDate != null && sub.endDate!.isBefore(monthEnd)
              ? sub.endDate!
              : monthEnd;

      double totalCost = 0;

      if (sub.trialActive &&
          sub.trialInterval != null &&
          sub.trialCost != null &&
          sub.trialEndDate != null) {
        final trialEnd = sub.trialEndDate!;
        final trialCharges = countCharges(
          start: monthStart,
          end: monthEnd,
          firstPay: sub.firstPay,
          intervalDays: sub.trialInterval!,
          cutoff: trialEnd.isBefore(effectiveEnd) ? trialEnd : effectiveEnd,
        );

        totalCost += trialCharges * sub.trialCost!;

        // If subscription continues after trial within this month
        if (trialEnd.isBefore(monthEnd)) {
          final firstRegularCharge = trialEnd.add(Duration(days: 1));

          final regularCharges = countCharges(
            start: monthStart,
            end: monthEnd,
            firstPay: firstRegularCharge,
            intervalDays: sub.interval,
            cutoff: effectiveEnd,
          );

          totalCost += regularCharges * sub.cost;
        }
      } else {
        // No trial, use regular values
        final charges = countCharges(
          start: monthStart,
          end: monthEnd,
          firstPay: sub.firstPay,
          intervalDays: sub.interval,
          cutoff: effectiveEnd,
        );

        totalCost += charges * sub.cost;
      }

      if (totalCost >= 0) {
        categoryTotals[category] = (categoryTotals[category] ?? .0) + totalCost;
      }
    }

    return categoryTotals;
  }

  List<MapEntry<String, double>> _getTopNCategories(Map<String, double> input) {
    final entries =
        input.entries.toList()..sort((a, b) {
          // ensure that 'others' category at the end of the list
          if (a.key == DonutChart._defaultCategory) {
            return 1;
          }

          if (b.key == DonutChart._defaultCategory) {
            return -1;
          }

          return b.value.compareTo(a.value);
        });

    if (entries.length <= DonutChart._maxSections) return entries;

    final topN = entries.take(DonutChart._maxSections - 1).toList();
    final otherSum = entries
        .skip(DonutChart._maxSections - 1)
        .fold<double>(0, (sum, e) => sum + e.value);

    topN.add(MapEntry(DonutChart._defaultCategory, otherSum));

    return topN;
  }

  List<MapEntry<String, double>> _calculateMonthlyCategoryStats(
    List<SubscriptionModel> allSubs,
    DateTime selectedMonth,
  ) {
    final categoryCosts = _getMonthlyCategoryCostsWithTrial(
      allSubs,
      selectedMonth,
    );

    return _getTopNCategories(categoryCosts);
  }
}

class _Legend extends StatelessWidget {
  final List<String> labels;

  const _Legend({required this.labels});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 12.0,
      alignment: WrapAlignment.center,

      children: List.generate(min(labels.length, DonutChart._maxSections), (
        index,
      ) {
        return _LegendItem(
          color: DonutChart._colors[index],
          label: labels[index],
        );
      }),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          CircleAvatar(radius: 6, backgroundColor: color),

          const SizedBox(width: 6),

          ConstrainedBox(
            constraints: BoxConstraints(
              // TODO: maybe use something else
              maxWidth: MediaQuery.of(context).size.width / 2.0,
            ),

            child: Text(
              label,
              style: Theme.of(context).textTheme.titleLarge,
              textWidthBasis: TextWidthBasis.parent,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
