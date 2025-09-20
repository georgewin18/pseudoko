import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget buildLogoutConfirmationButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      context.pop(true);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 12
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
    ),
    child: const Text(
      "Logout",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}