import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

Widget buildPasswordField({
  required String label,
  required String hint,
  required bool isPasswordVisible,
  required VoidCallback callback,
  required VoidCallback togglePasswordVisibility,
  required TextEditingController controller,
}) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          onChanged: (_) => callback(),
          obscureText: !isPasswordVisible,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade500)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade500),
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
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          }
        ),
      ]
  );
}