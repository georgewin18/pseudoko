import 'package:flutter/material.dart';

import 'package:experiment_app/core/widgets/expand_button_clipper.dart';
import 'package:experiment_app/core/widgets/shrink_button_clipper.dart';

Widget buildExpandButton({
  required bool isExpanded,
  required VoidCallback onTap,
}) {
  const double buttonSize = 24;

  return ClipPath(
    clipper: isExpanded ? ShrinkButtonClipper() : ExpandButtonClipper(),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize + 8,
        color: const Color(0xFF8A63D2),
        child: Icon(
          isExpanded
            ? Icons.keyboard_arrow_up
            : Icons.keyboard_arrow_down,
          color: Colors.white,
          size: 20,
        ),
      ),
    ),
  );
}