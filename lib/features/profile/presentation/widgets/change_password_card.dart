import 'package:flutter/material.dart';

import 'package:experiment_app/features/profile/presentation/widgets/card_decoration.dart';
import 'package:experiment_app/features/profile/presentation/widgets/build_password_field.dart';

class ChangePasswordCard extends StatelessWidget {
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  final bool isCurrentPasswordVisible;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;

  final VoidCallback toggleCurrentPasswordVisibility;
  final VoidCallback toggleNewPasswordVisibility;
  final VoidCallback toggleConfirmPasswordVisibility;

  const ChangePasswordCard({
    super.key,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.isCurrentPasswordVisible,
    required this.isNewPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.toggleCurrentPasswordVisibility,
    required this.toggleNewPasswordVisibility,
    required this.toggleConfirmPasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 16,
      ),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildPasswordField(
            label: 'Current Password',
            hint: 'Enter current password',
            controller: currentPasswordController,
            isPasswordVisible: isCurrentPasswordVisible,
            togglePasswordVisibility: toggleCurrentPasswordVisibility,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your current password';
              }
              return null;
            }
          ),

          SizedBox(height: 24),

          buildPasswordField(
            label: 'New Password',
            hint: 'Enter new password',
            controller: newPasswordController,
            isPasswordVisible: isNewPasswordVisible,
            togglePasswordVisibility: toggleNewPasswordVisibility,
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'New password must be at least 6 characters';
              }
              if (value == currentPasswordController.text) {
                return 'New password cannot be the same as the current password';
              }
              return null;
            }
          ),

          SizedBox(height: 24),

          buildPasswordField(
            label: 'Confirm New Password',
            hint: 'Confirm new password',
            controller: confirmPasswordController,
            isPasswordVisible: isConfirmPasswordVisible,
            togglePasswordVisibility: toggleConfirmPasswordVisibility,
            validator: (value) {
              if (value == null || value != newPasswordController.text) {
                return 'Passwords do not match!';
              }
              return null;
            }
          ),
        ]
      )
    );
  }
}