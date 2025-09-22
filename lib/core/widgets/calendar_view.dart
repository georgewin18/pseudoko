import 'package:experiment_app/core/widgets/calendar_builders.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;
  final List<dynamic> Function(DateTime) eventLoader;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(DateTime) onPageChanged;
  final void Function(CalendarFormat) onFormatChanged;

  const CalendarView({
    super.key,
    required this.focusedDay,
    this.selectedDay,
    required this.calendarFormat,
    required this.eventLoader,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.onFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: focusedDay,
      firstDay: DateTime.utc(2025, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),

      selectedDayPredicate: (day) => isSameDay(selectedDay, day),

      calendarFormat: calendarFormat,
      eventLoader: eventLoader,
      onDaySelected: onDaySelected,
      onPageChanged: onPageChanged,
      onFormatChanged: onFormatChanged,

      availableGestures: AvailableGestures.horizontalSwipe,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerVisible: false,
      daysOfWeekHeight: 20,
      rowHeight: 45,

      calendarBuilders: CalendarBuilders(
        dowBuilder: AppCalendarBuilders.dowBuilder,
        selectedBuilder: AppCalendarBuilders.selectedBuilder,
        todayBuilder: AppCalendarBuilders.todayBuilder,
        defaultBuilder: AppCalendarBuilders.defaultBuilder,
        markerBuilder: AppCalendarBuilders.markerBuilder,
      ),
    );
  }
}