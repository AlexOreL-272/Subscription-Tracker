import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_bloc.dart';
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

  const DonutChart({super.key});

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  double total = 0.0;
  late List<MapEntry<String, double>> sortedCostsPerCategory;

  @override
  void initState() {
    super.initState();

    final subscriptions =
        BlocProvider.of<SubscriptionBloc>(context).state.subscriptions.values;

    var costPerCategory = {
      for (var subs in subscriptions) ...{
        (subs.category == null || subs.category == 'Все'
                ? DonutChart._defaultCategory
                : subs.category!):
            0.0,
      },

      DonutChart._defaultCategory: 0.0,
    };

    // TODO: add currency conversion
    for (final subs in subscriptions) {
      final label =
          subs.category == null || subs.category == 'Все'
              ? DonutChart._defaultCategory
              : subs.category!;

      costPerCategory[label] = costPerCategory[label]! + subs.cost;

      total += subs.cost;
    }

    sortedCostsPerCategory =
        costPerCategory.entries.toList()..sort((a, b) {
          if (a.key == DonutChart._defaultCategory) {
            return 1;
          }

          if (b.key == DonutChart._defaultCategory) {
            return -1;
          }

          return b.value.compareTo(a.value);
        });

    if (sortedCostsPerCategory.length > DonutChart._maxSections) {
      sortedCostsPerCategory =
          sortedCostsPerCategory.sublist(0, DonutChart._maxSections - 1) +
          [sortedCostsPerCategory.last];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: WasubiColors.wasubiNeutral[100]!,
        borderRadius: BorderRadius.circular(10.0),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
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

          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300.0,

            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 4.0,
                    centerSpaceRadius: 100.0,
                    startDegreeOffset: -90.0,
                    sections: _showingSections(context),
                  ),
                ),

                Text(
                  '${total.toStringAsFixed(2)} ₽',
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
        final label = sortedCostsPerCategory[index].key;
        final cost = sortedCostsPerCategory[index].value;

        return PieChartSectionData(
          color: DonutChart._colors[index],
          value: cost + 0.001,
          showTitle: false,
          title: label,
          radius: 40,
        );
      },
    );
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
