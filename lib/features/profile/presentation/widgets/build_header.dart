import 'package:flutter/material.dart';

Widget buildHeader({
  required BuildContext context,
}) {
  final headerHeight = MediaQuery.of(context).size.height * 0.32;
  final headerColor = Color(0xFF7B6EF2);

  return Container(
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