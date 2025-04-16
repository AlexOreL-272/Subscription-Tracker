import 'package:flutter/material.dart';
import 'package:subscription_tracker/pages/statistics/screens/statistics_screen/widgets/pie_chart.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePicker extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  final BoxDecoration? decoration;
  final TextStyle? textStyle;

  final ValueChanged<MapEntry<DateTime?, DateTime?>> onChanged;

  const DatePicker({
    required this.start,
    required this.end,
    required this.onChanged,
    this.decoration,
    this.textStyle,
    super.key,
  });

  Future<void> _showCustomDatePicker(BuildContext context) async {
    DateTime? finalStartChoice = start;
    DateTime? selectedStartDate = start;

    DateTime? finalEndChoice = end;
    DateTime? selectedEndDate = end;

    FocusScope.of(context).unfocus();

    await showDialog(
      context: context,

      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выберите дату'),

          content: SizedBox(
            width: double.maxFinite,
            height: 300.0,

            child: SfDateRangePicker(
              initialSelectedDate: start,
              minDate: DateTime(2010),
              maxDate: DateTime.now().add(const Duration(days: 100 * 365)),

              monthViewSettings: const DateRangePickerMonthViewSettings(
                showTrailingAndLeadingDates: false,
              ),

              showNavigationArrow: true,
              showActionButtons: false,

              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHigh,

              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: Colors.transparent,

                textStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),

              selectionMode: DateRangePickerSelectionMode.range,

              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                final choice = args.value as PickerDateRange;

                selectedStartDate = choice.startDate;
                selectedEndDate = choice.endDate;
              },
            ),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),

              child: const Text('Отмена'),
            ),

            TextButton(
              onPressed: () {
                finalStartChoice = selectedStartDate;
                finalEndChoice = selectedEndDate;
                Navigator.pop(context);
              },

              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if ((finalStartChoice != null && finalStartChoice != start) ||
        (finalEndChoice != null && finalEndChoice != end)) {
      onChanged(MapEntry(finalStartChoice, finalEndChoice));
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${DonutChart.dateFormat.format(start)} - ${DonutChart.dateFormat.format(end)}';

    return GestureDetector(
      onTap: () => _showCustomDatePicker(context),

      child: Container(
        decoration: decoration,

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),

          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.0,

            children: [
              Text(formattedDate, style: textStyle),

              Icon(Icons.keyboard_arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}
