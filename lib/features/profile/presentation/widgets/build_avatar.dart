import 'package:flutter/material.dart';

Widget buildAvatar({
  required double avatarRadius,
  required String username,
}) {
  return CircleAvatar(
    radius: avatarRadius,
    backgroundColor: Colors.white,
    child: CircleAvatar(
      radius: avatarRadius - 5,
      backgroundColor: Colors.deepPurple[100],
      child: Text(
        username.isNotEmpty ? username[0].toUpperCase() : 'A',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple[700],
        ),
      ),
    ),
  );
}