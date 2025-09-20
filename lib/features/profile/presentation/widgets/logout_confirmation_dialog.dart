import 'package:flutter/material.dart';

import 'package:experiment_app/features/profile/presentation/widgets/build_cancel_confirmation_button.dart';
import 'package:experiment_app/features/profile/presentation/widgets/build_logout_confirmation_button.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Are you sure you want to log out?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildCancelConfirmationButton(context),
                buildLogoutConfirmationButton(context),
              ],
            )
          ],
        ),
      ),
    );
  }
}