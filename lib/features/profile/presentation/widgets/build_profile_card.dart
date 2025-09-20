import 'package:experiment_app/features/profile/presentation/widgets/build_avatar.dart';
import 'package:flutter/material.dart';

import 'package:experiment_app/features/profile/presentation/widgets/card_decoration.dart';


Widget buildProfileCard({
  required double avatarRadius,
  required String username,
  required String userEmail,
}) {
  return Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.center,
    children: [
      Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: avatarRadius,
          bottom: 20,
        ),
        decoration: cardDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              username,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              userEmail,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),

      Positioned(
        top: -avatarRadius,
        child: buildAvatar(
          avatarRadius: avatarRadius,
          username: username
        ),
      )
    ],
  );
}