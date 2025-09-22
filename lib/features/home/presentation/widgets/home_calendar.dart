import 'package:experiment_app/features/task/data/models/user_task_model.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:experiment_app/core/widgets/build_calendar_header.dart';
import 'package:experiment_app/core/widgets/build_expand_button.dart';
import 'package:experiment_app/core/widgets/calendar_view.dart';

class HomeCalendar extends StatefulWidget {
  final List<UserTask> tasks;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const HomeCalendar({
    super.key,
    required this.tasks,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<HomeCalendar> createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  late Map<DateTime, List<UserTask>> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = _groupTasksByDay(widget.tasks);
  }

  @override
  void didUpdateWidget(covariant HomeCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tasks != oldWidget.tasks) {
      setState(() {
        _tasks = _groupTasksByDay(widget.tasks);
      });
    }
  }

  Map<DateTime, List<UserTask>> _groupTasksByDay(List<UserTask> tasks) {
    final Map<DateTime, List<UserTask>> eventsMap = {};
    for (var task in tasks) {
      if (task.date != null) {
        final day = DateTime.utc(task.date!.year, task.date!.month, task.date!.day);
        if (eventsMap[day] == null) {
          eventsMap[day] = [];
        }
        eventsMap[day]!.add(task);
      }
    }
    return eventsMap;
  }

  List<UserTask> _getTaskForDay(DateTime day) {
    return _tasks[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildCalendarHeader(
              focusedDay: _focusedDay,
              onChevronLeftPressed: _onChevronLeft,
              onChevronRightPressed: _onChevronRight,
              isHomePage: true,
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                  bottom: 24
              ),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: CalendarView(
                focusedDay: _focusedDay,
                selectedDay: widget.selectedDate,
                calendarFormat: _calendarFormat,
                eventLoader: _getTaskForDay,
                onDaySelected: _onDaySelected,
                onPageChanged: (focusedDay) =>
                  setState(() => _focusedDay = focusedDay
                ),
                onFormatChanged: (format) =>
                  setState(() => _calendarFormat = format
                ),
              ),
            )
          ],
        ),

        Positioned(
          bottom: 0,
          child: buildExpandButton(
            isExpanded: _calendarFormat == CalendarFormat.month,
            onTap: _toggleCalendarFormat,
          ),
        )
      ]
    );
  }

  void _onChevronLeft() {
    setState(() {
      if (_calendarFormat == CalendarFormat.month) {
        _focusedDay = DateTime.utc(_focusedDay.year, _focusedDay.month - 1);
      } else {
        _focusedDay = DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day - 7);
      }
    });
  }

  void _onChevronRight() {
    setState(() {
      if (_calendarFormat == CalendarFormat.month) {
        _focusedDay = DateTime.utc(_focusedDay.year, _focusedDay.month + 1);
      } else {
        _focusedDay = DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day + 7);
      }
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (!isSameDay(widget.selectedDate, selectedDay)) {
        _focusedDay = selectedDay;
        widget.onDateSelected(selectedDay);
      }
    });
  }

  void _toggleCalendarFormat() {
    setState(() {
      _calendarFormat = _calendarFormat == CalendarFormat.week
          ? CalendarFormat.month
          : CalendarFormat.week;
    });
  }
}