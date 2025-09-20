import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

Widget buildPasswordField({
  required String label,
  required String hint,
  required bool isPasswordVisible,
  required VoidCallback togglePasswordVisibility,
  required TextEditingController controller,
  String? Function(String?)? validator,
}) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
          ),
        ),

        SizedBox(height: 8),

        TextFormField(
          controller: controller,
          obscureText: !isPasswordVisible,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            errorMaxLines: 2,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible
                  ? LucideIcons.eye
                  : LucideIcons.eye_off
              ),
              onPressed: togglePasswordVisibility,
            ),
          ),
          validator: validator,
        ),
      ]
  );
}