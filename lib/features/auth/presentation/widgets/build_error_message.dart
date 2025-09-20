import 'package:flutter/material.dart';

Widget buildErrorMessageWidget({
  required String? errorMessage,
}) {
  final Color errorBackgroundColor = const Color(0xFFFC9B9B);
  final Color errorForegroundColor = const Color(0xFFA00606);

  if (errorMessage == null) {
    return const SizedBox(height: 40);
  }

  return Container(
    margin: const EdgeInsets.only(top: 16, bottom: 16),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    width: double.infinity,
    decoration: BoxDecoration(
      color: errorBackgroundColor.withAlpha(100),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      errorMessage,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: errorForegroundColor,
        fontSize: 14,
      ),
    ),
  );
}