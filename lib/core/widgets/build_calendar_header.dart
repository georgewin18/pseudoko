import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';

Widget buildCalendarHeader({
  required DateTime focusedDay,
  required VoidCallback onChevronLeftPressed,
  required VoidCallback onChevronRightPressed,
  bool isHomePage = false,
}) {
  Color color = isHomePage ? Colors.white : Colors.black;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      IconButton(
        icon: Icon(
          LucideIcons.chevron_left,
          color: color,
        ),
        onPressed: onChevronLeftPressed,
      ),

      Column(
        children: [
          Text(
            DateFormat.MMMM().format(focusedDay),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            DateFormat.y().format(focusedDay),
            style: TextStyle(
              fontSize: 14,
              color: color,
            ),
          )
        ],
      ),

      IconButton(
        icon: Icon(
          LucideIcons.chevron_right,
          color: color,
        ),
        onPressed: onChevronRightPressed,
      ),
    ],
  );
}