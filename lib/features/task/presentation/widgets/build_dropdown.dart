import 'package:experiment_app/features/task/presentation/widgets/input_decoration.dart';
import 'package:flutter/material.dart';

Widget buildDropdown(
  List<String> items,
  String? selectedValue,
  ValueChanged<String?> onChanged
) {
  return DropdownButtonFormField<String>(
    value: selectedValue,
    items: items.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    onChanged: onChanged,
    decoration: buildInputDecoration('').copyWith(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    ),
  );
}