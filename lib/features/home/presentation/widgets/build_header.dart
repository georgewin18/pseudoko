import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:experiment_app/features/home/presentation/widgets/mini_date_widget.dart';

Widget buildHeader({
  required String? name,
  required VoidCallback onPressed,
  required isFocusedOnTask,
  required DateTime date,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          return SizeTransition(
            sizeFactor: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: isFocusedOnTask
          ? Padding(
              key: const ValueKey('simple-date'),
              padding: EdgeInsets.symmetric(
                  vertical: 8
              ),
              child: miniDateWidget(date),
            )
          : Column(
              key: const ValueKey('header-message'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name != null ? 'Hello, $name!' : 'Hello, User!',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),

                Text(
                  'Welcome back to DoKo',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
          ],
        ),
      ),

      GestureDetector(
        onTap: onPressed,
        child: const Icon(
          LucideIcons.bell,
          color: Colors.white,
        ),
      )
    ],
  );
}