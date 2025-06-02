import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/common/scripts/scripts.dart';
import 'package:subscription_tracker/bloc/settings_bloc/settings_bloc.dart';
import 'package:subscription_tracker/bloc/subscription_bloc/subscription_bloc.dart';
import 'package:subscription_tracker/models/subscription_model.dart';
import 'package:subscription_tracker/pages/statistics/screens/statistics_screen/common/scripts/scripts.dart';
import 'package:subscription_tracker/pages/statistics/screens/statistics_screen/widgets/date_picker.dart';
import 'package:subscription_tracker/repo/currency_rates/currency_repo.dart';
import 'package:subscription_tracker/services/shared_data.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DonutChartOld extends StatefulWidget {
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

  const DonutChartOld({super.key});

  @override
  State<DonutChartOld> createState() => _DonutChartOldState();
}

class _DonutChartOldState extends State<DonutChartOld> {
  double _total = 0.0;
  DateTime _selectedMonth = DateTime.now();
  List<MapEntry<String, double>> _sortedCostsPerCategory = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCurrency =
        SharedData.currenciesSymbols[BlocProvider.of<SettingsBloc>(
          context,
        ).state.currency];

    final subscriptions =
        BlocProvider.of<SubscriptionBloc>(
          context,
        ).state.subscriptions.values.toList();

    _sortedCostsPerCategory = _calculateMonthlyCategoryStats(
      subscriptions,
      _selectedMonth,
    );

    _total = _sortedCostsPerCategory.fold<double>(0, (sum, e) => sum + e.value);

    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final uiColor = isDark ? UIBaseColors.dark() : UIBaseColors.light();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: uiColor.container,
        borderRadius: BorderRadius.circular(10.0),

        boxShadow: [
          BoxShadow(color: uiColor.shadow, blurRadius: 2.0, spreadRadius: 1.0),
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
                      color: uiColor.secondaryText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Text(
                  DonutChartOld.dateFormat.format(_selectedMonth),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: uiColor.secondaryText,
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
                  '${_total.toStringAsFixed(2)} $selectedCurrency',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32.0),

          _Legend(labels: _sortedCostsPerCategory, currency: selectedCurrency!),

          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections(BuildContext context) {
    return List<PieChartSectionData>.generate(
      min(_sortedCostsPerCategory.length, DonutChartOld._maxSections),

      (index) {
        final cost = _sortedCostsPerCategory[index].value;

        return PieChartSectionData(
          color: DonutChartOld._colors[index],
          value: cost + 1e-3,
          showTitle: false,
          title: cost.toStringAsFixed(2),
          radius: 40,
        );
      },
    );
  }

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

    final selectedCurrency =
        BlocProvider.of<SettingsBloc>(context).state.currency;
    final currencyRepo = RepositoryProvider.of<CurrencyRepo>(context);

    for (var sub in subscriptions) {
      if (!sub.isActive) continue;

      final category =
          sub.category == null || sub.category == 'Все'
              ? DonutChartOld._defaultCategory
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

        totalCost += currencyRepo.convert(
          trialCharges * sub.trialCost!,
          sub.currency,
          selectedCurrency,
        );

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

          totalCost += currencyRepo.convert(
            regularCharges * sub.cost,
            sub.currency,
            selectedCurrency,
          );
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

        totalCost += currencyRepo.convert(
          charges * sub.cost,
          sub.currency,
          selectedCurrency,
        );
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
          if (a.key == DonutChartOld._defaultCategory) {
            return 1;
          }

          if (b.key == DonutChartOld._defaultCategory) {
            return -1;
          }

          return b.value.compareTo(a.value);
        });

    if (entries.length <= DonutChartOld._maxSections) return entries;

    final topN = entries.take(DonutChartOld._maxSections - 1).toList();
    final otherSum = entries
        .skip(DonutChartOld._maxSections - 1)
        .fold<double>(0, (sum, e) => sum + e.value);

    topN.add(MapEntry(DonutChartOld._defaultCategory, otherSum));

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

  const DonutChart({super.key});

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  double _total = 0.0;

  late DateTime _selectedFrom;
  late DateTime _selectedTo;

  List<MapEntry<String, double>> _sortedCostsPerCategory = [];

  @override
  void initState() {
    final now = DateTime.now();
    _selectedFrom = DateTime(now.year, now.month);
    _selectedTo = DateTime(
      now.year,
      now.month + 1,
    ).subtract(const Duration(days: 1));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCurrency =
        SharedData.currenciesSymbols[BlocProvider.of<SettingsBloc>(
          context,
        ).state.currency];

    final subscriptions =
        BlocProvider.of<SubscriptionBloc>(
          context,
        ).state.subscriptions.values.toList();

    _sortedCostsPerCategory = _calculateMonthlyCategoryStats(
      subscriptions,
      _selectedFrom,
      _selectedTo,
    );

    _total = _sortedCostsPerCategory.fold<double>(0, (sum, e) => sum + e.value);

    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final uiColor = isDark ? UIBaseColors.dark() : UIBaseColors.light();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: uiColor.container,
        borderRadius: BorderRadius.circular(10.0),

        boxShadow: [
          BoxShadow(color: uiColor.shadow, blurRadius: 2.0, spreadRadius: 1.0),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          const SizedBox(height: 16.0),

          Text(
            AppLocalizations.of(context)!.pieChartTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: uiColor.secondaryText,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16.0),

          DatePicker(
            start: _selectedFrom,
            end: _selectedTo,

            onChanged: (value) {
              if (value.key == null || value.value == null) {
                return;
              }

              setState(() {
                _selectedFrom = value.key!;
                _selectedTo = value.value!;
              });
            },

            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8.0),
            ),

            textStyle: TextStyle(color: uiColor.text, fontSize: 16.0),
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
                  '${_total.toStringAsFixed(2)} $selectedCurrency',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32.0),

          _Legend(labels: _sortedCostsPerCategory, currency: selectedCurrency!),

          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections(BuildContext context) {
    final sections = List<PieChartSectionData>.generate(
      min(_sortedCostsPerCategory.length, DonutChart._maxSections),

      (index) {
        final cost = _sortedCostsPerCategory[index].value;

        return PieChartSectionData(
          color: DonutChart._colors[index],
          value: cost + 1e-3,
          showTitle: false,
          title: cost.toStringAsFixed(2),
          radius: 40,
        );
      },
    );

    if (sections.isEmpty) {
      return [
        PieChartSectionData(
          color: DonutChart._colors[0],
          value: 1e-3,
          showTitle: false,
          title: '0',
          radius: 40,
        ),
      ];
    }

    return sections;
  }

  Map<String, double> _getMonthlyCategoryCostsWithTrial(
    List<SubscriptionModel> subscriptions,
    DateTime from,
    DateTime to,
  ) {
    final Map<String, double> categoryTotals = {};

    final selectedCurrency =
        BlocProvider.of<SettingsBloc>(context).state.currency;
    final currencyRepo = RepositoryProvider.of<CurrencyRepo>(context);

    for (var sub in subscriptions) {
      if (!sub.isActive) continue;

      final category =
          sub.category == null || sub.category == 'Все'
              ? DonutChart._defaultCategory
              : sub.category!;

      final effectiveEnd =
          sub.endDate != null && sub.endDate!.isBefore(to) ? sub.endDate! : to;

      double totalCost = 0;

      if (sub.trialActive &&
          sub.trialInterval != null &&
          sub.trialCost != null &&
          sub.trialEndDate != null) {
        final trialEnd = sub.trialEndDate!;
        final trialCharges = countCharges(
          start: from,
          end: to,
          firstPay: sub.firstPay,
          intervalDays: sub.trialInterval!,
          cutoff: trialEnd.isBefore(effectiveEnd) ? trialEnd : effectiveEnd,
        );

        totalCost += currencyRepo.convert(
          trialCharges * sub.trialCost!,
          sub.currency,
          selectedCurrency,
        );

        // If subscription continues after trial within this month
        if (trialEnd.isBefore(to)) {
          final firstRegularCharge = trialEnd.add(Duration(days: 1));

          final regularCharges = countCharges(
            start: from,
            end: to,
            firstPay: firstRegularCharge,
            intervalDays: sub.interval,
            cutoff: effectiveEnd,
          );

          totalCost += currencyRepo.convert(
            regularCharges * sub.cost,
            sub.currency,
            selectedCurrency,
          );
        }
      } else {
        // No trial, use regular values
        final charges = countCharges(
          start: from,
          end: to,
          firstPay: sub.firstPay,
          intervalDays: sub.interval,
          cutoff: effectiveEnd,
        );

        totalCost += currencyRepo.convert(
          charges * sub.cost,
          sub.currency,
          selectedCurrency,
        );
      }

      if (totalCost > 0) {
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
    DateTime from,
    DateTime to,
  ) {
    final categoryCosts = _getMonthlyCategoryCostsWithTrial(allSubs, from, to);

    return _getTopNCategories(categoryCosts);
  }
}

class _Legend extends StatelessWidget {
  final List<MapEntry<String, double>> labels;
  final String currency;

  const _Legend({required this.labels, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 12.0,
      alignment: WrapAlignment.center,

      children: List.generate(min(labels.length, DonutChartOld._maxSections), (
        index,
      ) {
        return _LegendItem(
          color: DonutChartOld._colors[index],
          selectedCurrency: currency,
          label: labels[index],
        );
      }),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final MapEntry<String, double> label;
  final String selectedCurrency;
  final Color color;

  const _LegendItem({
    required this.label,
    required this.selectedCurrency,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = ThemeData.estimateBrightnessForColor(color);
    final textColor =
        brightness == Brightness.light ? Colors.black87 : Colors.white;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.0),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),

        child: ConstrainedBox(
          constraints: BoxConstraints(
            // TODO: maybe use something else
            maxWidth: MediaQuery.of(context).size.width / 2.0,
          ),

          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: label.key,
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),

                TextSpan(
                  text: ' ${label.value.toStringAsFixed(2)} $selectedCurrency',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(color: textColor),
            textWidthBasis: TextWidthBasis.parent,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
