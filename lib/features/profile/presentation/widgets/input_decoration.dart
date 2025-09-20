import 'package:flutter/material.dart';

InputDecoration inputDecoration({
  required String hintText,
  bool isCheckingUsername = false,
  String? helperText,
  Color? helperColor,
}) {
  return InputDecoration(
    hintText: hintText,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    helperText: helperText,
    helperStyle: TextStyle(color: helperColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF7B6EF2), width: 2),
    ),
    suffixIcon: isCheckingUsername
      ? Transform.scale(
          scale: 0.5,
          child: const CircularProgressIndicator(),
        )
      : null,
    errorMaxLines: 2,
  );
}