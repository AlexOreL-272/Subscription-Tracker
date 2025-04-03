import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:subscription_tracker/screens/subscriptions/common/scripts/scripts.dart';

class DatePicker extends StatelessWidget {
  final DateTime? value;
  final BoxDecoration? decoration;
  final TextStyle? textStyle;
  final IconData icon;

  final ValueChanged<DateTime?> onChanged;

  final Widget? additionalAction;
  final ValueChanged? onAdditionalAction;

  const DatePicker({
    required this.value,
    required this.onChanged,
    this.decoration,
    this.textStyle,
    this.icon = Icons.calendar_month_outlined,
    this.additionalAction,
    this.onAdditionalAction,
    super.key,
  });

  Future<void> _showCustomDatePicker(BuildContext context) async {
    DateTime? finalChoice = value;
    DateTime? selectedDate = value;

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
              initialSelectedDate: value ?? DateTime.now(),
              minDate: DateTime(2010),
              maxDate: DateTime.now().add(const Duration(days: 100 * 365)),

              showNavigationArrow: true,
              showActionButtons: false,

              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHigh,

              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: Colors.transparent,

                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),

              selectionMode: DateRangePickerSelectionMode.single,

              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                selectedDate = args.value as DateTime;
              },
            ),
          ),

          actionsPadding: EdgeInsets.zero,

          actions: [
            additionalAction ?? const SizedBox(width: 0.0),

            TextButton(
              onPressed: () => Navigator.pop(context),

              child: const Text('Отмена'),
            ),

            TextButton(
              onPressed: () {
                finalChoice = selectedDate;
                Navigator.pop(context);
              },

              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (finalChoice != null && finalChoice != value) {
      onChanged(finalChoice);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = value != null ? formatDate(value!) : 'Никогда';

    return GestureDetector(
      onTap: () => _showCustomDatePicker(context),
      child: Container(
        decoration: decoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: textStyle?.color),
              const SizedBox(width: 8.0),
              Text(formattedDate, style: textStyle),
            ],
          ),
        ),
      ),
    );
  }
}
