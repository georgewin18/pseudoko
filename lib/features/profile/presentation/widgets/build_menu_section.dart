import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

import 'package:experiment_app/features/profile/presentation/manager/profile_notifier.dart';
import 'package:experiment_app/features/profile/presentation/widgets/card_decoration.dart';
import 'package:experiment_app/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:experiment_app/features/profile/presentation/widgets/logout_confirmation_dialog.dart';

Widget buildMenuSection(BuildContext context, ProfileNotifier notifier) {
  Future<void> showLogoutDialog(BuildContext context) async {
    final bool? didRequestLogout = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          return const LogoutConfirmationDialog();
        }
    );

    if (didRequestLogout == true && context.mounted) {
      try {
        await notifier.signOut();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.red,
              )
          );
        }
      }
    }
  }

  return Container(
    width: double.infinity,
    decoration: cardDecoration(),
    child: Column(
      children: [
        ProfileMenuItem(
            icon: LucideIcons.pen,
            title: "Edit Profile",
            onTap: () {
              context.push('/profile/edit-profile');
            }
        ),

        ProfileMenuItem(
          icon: LucideIcons.lock,
          title: "Change Password",
          onTap: () {
            context.push('/profile/change-password');
          },
        ),

        ProfileMenuItem(
          icon: LucideIcons.log_out,
          title: "Logout",
          onTap: () => showLogoutDialog(context),
          textColor: Colors.red,
        ),
      ],
    ),
  );
}

