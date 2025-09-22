import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:experiment_app/core/widgets/build_calendar_header.dart';
import 'package:experiment_app/core/widgets/build_expand_button.dart';
import 'package:experiment_app/core/widgets/calendar_view.dart';
import 'package:experiment_app/features/task/data/models/task_model.dart';

class ExpandableCalendar extends StatefulWidget {
  final List<Task> tasks;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const ExpandableCalendar({
    super.key,
    required this.tasks,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<ExpandableCalendar> createState() => _ExpandableCalendarState();
}

class _ExpandableCalendarState extends State<ExpandableCalendar> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  late Map<DateTime, List<Task>> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = _groupTasksByDay(widget.tasks);
  }

  @override
  void didUpdateWidget(covariant ExpandableCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tasks != oldWidget.tasks) {
      setState(() {
        _tasks = _groupTasksByDay(widget.tasks);
      });
    }
  }

  Map<DateTime, List<Task>> _groupTasksByDay(List<Task> tasks) {
    final Map<DateTime, List<Task>> tasksMap = {};
    for (var task in tasks) {
      if (task.date != null) {
        final day = DateTime.utc(task.date.year, task.date.month, task.date.day);
        if (tasksMap[day] == null) {
          tasksMap[day] = [];
        }
        tasksMap[day]!.add(task);
      }
    }
    return tasksMap;
  }

  List<Task> _getTaskForDay(DateTime day) {
    return _tasks[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
            )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildCalendarHeader(
                  focusedDay: _focusedDay,
                  onChevronLeftPressed: _onChevronLeft,
                  onChevronRightPressed: _onChevronRight,
                ),

                const SizedBox(height: 16),

                CalendarView(
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
              ],
            )
          ),
        ),

        Positioned(
          bottom: 0,
          child: buildExpandButton(
            isExpanded: _calendarFormat == CalendarFormat.month,
            onTap: _toggleCalendarFormat,
          ),
        ),
      ],
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