import 'package:flutter/material.dart';

class ExpandButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    final double sideHeight = size.height * 0.8;

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, sideHeight);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, sideHeight);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}