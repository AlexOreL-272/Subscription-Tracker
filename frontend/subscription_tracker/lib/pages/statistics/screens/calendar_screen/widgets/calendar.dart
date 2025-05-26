import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/bloc/settings_bloc/settings_bloc.dart';
import 'package:subscription_tracker/common/scripts/scripts.dart';
import 'package:subscription_tracker/pages/statistics/screens/calendar_screen/widgets/cell.dart';
import 'package:subscription_tracker/pages/statistics/screens/calendar_screen/widgets/event_tile.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarOld extends StatelessWidget {
  const CalendarOld({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
        isDark ? UIBaseColors.containerDark : UIBaseColors.containerLight;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),

      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.width + 100.0,
        ),

        child: SfDateRangePicker(
          initialSelectedDate: null,

          showNavigationArrow: true,
          showActionButtons: false,

          toggleDaySelection: true,

          backgroundColor: backgroundColor,

          headerHeight: 64.0,
          headerStyle: DateRangePickerHeaderStyle(
            backgroundColor: Colors.transparent,
            textStyle: Theme.of(context).textTheme.headlineLarge,
          ),

          minDate: DateTime(2010),
          maxDate: DateTime.now().add(const Duration(days: 100 * 365)),

          selectionMode: DateRangePickerSelectionMode.single,
          selectionShape: DateRangePickerSelectionShape.rectangle,
          selectionRadius: 8.0,

          cellBuilder: (context, cellDetails) {
            return Cell(date: cellDetails.date);
          },
        ),
      ),
    );
  }
}

class Calendar extends StatefulWidget {
  final Map<DateTime, List<EventTileData>> markers;
  final void Function(DateTime) onSelected;

  const Calendar({required this.markers, required this.onSelected, super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final uiTheme = isDark ? UIBaseColors.dark() : UIBaseColors.light();

    final primary = Theme.of(context).colorScheme.primary;

    final lang = BlocProvider.of<SettingsBloc>(context).state.language;
    final isRussian = lang == 'ru';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: uiTheme.container,
        borderRadius: BorderRadius.circular(8.0),
      ),

      child: TableCalendar(
        firstDay: DateTime(now.year, now.month),
        lastDay: now.add(const Duration(days: 365 * 20)),

        locale: lang,

        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,

        startingDayOfWeek: StartingDayOfWeek.monday,
        daysOfWeekHeight: 48.0,

        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },

        onDaySelected: (selectedDay, focusedDay) {
          if (selectedDay == _selectedDay) return;

          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = selectedDay;
          });

          widget.onSelected(_selectedDay!);
        },

        eventLoader: (day) {
          final key = DateTime(day.year, day.month, day.day);
          return widget.markers[key] ?? [];
        },

        calendarStyle: CalendarStyle(
          isTodayHighlighted: false,

          selectedTextStyle: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(color: uiTheme.text),

          selectedDecoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,
            border: Border.all(color: primary, width: 3.0),
            borderRadius: BorderRadius.circular(8.0),
          ),

          markersMaxCount: 3,

          markerDecoration: BoxDecoration(
            color: primary.withAlpha(150),
            shape: BoxShape.circle,
          ),

          defaultDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
          ),

          weekendTextStyle: TextStyle(color: Colors.redAccent[400]!),

          weekendDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
          ),

          disabledDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
          ),

          outsideDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),

        headerStyle: HeaderStyle(
          titleTextFormatter: (date, _) {
            return CustomDateFormat.MMMMyyyy(isRussian: isRussian).format(date);
          },
          formatButtonVisible: false,
          titleCentered: true,
        ),

        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: primary),
          weekendStyle: TextStyle(color: primary),
        ),
      ),
    );
  }
}
