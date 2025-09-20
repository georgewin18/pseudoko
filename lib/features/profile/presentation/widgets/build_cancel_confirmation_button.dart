import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget buildCancelConfirmationButton(BuildContext context) {
  return OutlinedButton(
    onPressed: () {
      context.pop(false);
    },
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 12
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      side: BorderSide(
        color: Color(0xFF7B6EF2),
        width: 2,
      ),
    ),
    child: const Text(
      'Cancel',
      style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold
      ),
    ),
  );
}