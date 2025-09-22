import 'package:flutter/material.dart';

Widget buildBackgroundHeader({
  required double headerHeight,
}) {
  final headerColor = Color(0xFF7B6EF2);

  return AnimatedContainer(
    duration: const Duration(milliseconds: 400),
    curve: Curves.easeInOutCubic,
    height: headerHeight,
    decoration: BoxDecoration(
        color: headerColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        )
    ),
  );
}