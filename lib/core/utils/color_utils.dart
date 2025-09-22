import 'package:flutter/material.dart';

const List<Color> _avatarColors = [
  Colors.amber,
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.purple,
  Colors.orange,
  Colors.teal,
  Colors.pink,
];

Color getRandomColorFromString(String text) {
  int index = text.hashCode % _avatarColors.length;
  return _avatarColors[index];
}