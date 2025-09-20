import 'package:flutter/material.dart';

Widget buildEmailField({
  required String label,
  required String hint,
  required VoidCallback callback,
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
        keyboardType: TextInputType.emailAddress,
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
        ),
        validator: (value) {
          if (value == null || value.isEmpty || !value.contains('@')) {
            return 'Please enter a valid email address';
          }
          return null;
        }
      ),
    ]
  );
}