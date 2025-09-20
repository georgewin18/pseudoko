import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:experiment_app/features/profile/presentation/widgets/build_avatar.dart';
import 'package:experiment_app/features/profile/presentation/widgets/build_labeled_text_field.dart';
import 'package:experiment_app/features/profile/presentation/widgets/card_decoration.dart';

class EditProfileCard extends StatelessWidget {
  final double avatarRadius;
  final String currentUsername;
  final String userEmail;
  final TextEditingController usernameController;
  final String? Function(String?)? usernameValidator;
  final VoidCallback onUsernameChanged;

  final String? usernameStatusMessage;
  final bool isCheckingUsername;
  final bool? isUsernameAvailable;

  const EditProfileCard({
    super.key,
    required this.avatarRadius,
    required this.currentUsername,
    required this.userEmail,
    required this.usernameController,
    this.usernameValidator,
    required this.onUsernameChanged,
    this.usernameStatusMessage,
    required this.isCheckingUsername,
    this.isUsernameAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: avatarRadius + 16,
            left: 16,
            right: 16,
            bottom: 32,
          ),
          decoration: cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (context) {
                  String? helperText;
                  Color helperColor = Colors.grey;

                  if (isCheckingUsername) {
                    helperText = "Checking availability...";
                  } else if (isUsernameAvailable == true) {
                    helperText = "Username available!";
                    helperColor = Colors.green;
                  } else if (isUsernameAvailable == false) {
                    helperText = null;
                  }

                  return buildLabeledTextField(
                    label: 'Username',
                    hint: 'Enter new username',
                    controller: usernameController,
                    validator: usernameValidator,
                    maxLength: 20,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-z0-9_]")),
                    ],
                    isCheckingUsername: isCheckingUsername,
                    helperText: helperText,
                    helperColor: helperColor,
                  );
                },
              ),

              const SizedBox(height: 24),

              buildLabeledTextField(
                label: 'Email',
                hint: userEmail,
                enabled: false,
              ),
            ],
          ),
        ),

        Positioned(
          top: -avatarRadius,
          child: buildAvatar(
            avatarRadius: avatarRadius,
            username: currentUsername,
          ),
        ),
      ],
    );
  }
}