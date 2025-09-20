import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:experiment_app/features/profile/presentation/widgets/input_decoration.dart';

Widget buildLabeledTextField({
  required String label,
  required String hint,
  TextEditingController? controller,
  String? Function(String?)? validator,
  List<TextInputFormatter>? inputFormatters,
  bool enabled = true,
  VoidCallback? onChanged,
  int? maxLength,
  bool isCheckingUsername = false,
  String? helperText,
  Color? helperColor,
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
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        enabled: enabled,
        onChanged: (_) => onChanged?.call(),
        style: const TextStyle(fontSize: 14),
        decoration: inputDecoration(
          hintText: hint,
          isCheckingUsername: isCheckingUsername,
          helperText: helperText,
          helperColor: helperColor,
        ),
      )
    ],
  );
}