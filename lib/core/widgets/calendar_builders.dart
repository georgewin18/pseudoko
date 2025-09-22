import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppCalendarBuilders {
  static Widget dowBuilder(BuildContext context, DateTime day) {
    final text = DateFormat.E().format(day).toUpperCase();
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget selectedBuilder(BuildContext context, DateTime day, DateTime focusedDay) {
    return Container(
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFF8A63D2),
        shape: BoxShape.circle,
      ),
      child: Text(
        '${day.day}',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget todayBuilder(BuildContext context, DateTime day, DateTime focusedDay) {
    return Center(
      child: Text(
        '${day.day}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF8A63D2),
        ),
      ),
    );
  }

  static Widget defaultBuilder(BuildContext context, DateTime day, DateTime focusedDay) {
    return Center(
      child: Text(
        '${day.day}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget markerBuilder(BuildContext context, DateTime day, List events) {
    if (events.isNotEmpty) {
      return Positioned(
        bottom: 4,
        child: Container(
          width: 16,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF8A63D2),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}