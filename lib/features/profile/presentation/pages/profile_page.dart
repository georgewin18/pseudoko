import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:experiment_app/features/profile/presentation/manager/profile_notifier.dart';
import 'package:experiment_app/features/profile/presentation/widgets/build_header.dart';
import 'package:experiment_app/features/profile/presentation/widgets/build_menu_section.dart';
import 'package:experiment_app/features/profile/presentation/widgets/build_profile_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileNotifier>().loadCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double headerHeight = screenHeight * 0.32;
    final double avatarRadius = screenWidth * 0.13;
    final double horizontalPadding = screenWidth * 0.1;

    return Consumer<ProfileNotifier>(
      builder: (context, notifier, child) {
        final username = notifier.currentUser?.userMetadata?['username'] ?? 'Loading...';
        final userEmail = notifier.currentUser?.email ?? 'Loading...';

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              buildHeader(context: context),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: headerHeight - (avatarRadius * 2.2),
                      ),
                      buildProfileCard(
                          avatarRadius: avatarRadius,
                          username: username,
                          userEmail: userEmail
                      ),
                      SizedBox(height: 16),
                      buildMenuSection(context, notifier),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}