import 'dart:async';
import 'package:experiment_app/features/profile/presentation/manager/profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:experiment_app/features/profile/presentation/widgets/build_header.dart';
import 'package:experiment_app/features/profile/presentation/widgets/edit_profile_card.dart';
import 'package:experiment_app/features/profile/presentation/widgets/primary_button.dart';
import 'package:experiment_app/injection.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;

  bool _isLoading = false;

  Timer? _debounce;
  bool _isCheckingUsername = false;
  bool? _isUsernameAvailable;
  // String? _usernameStatusMessage;

  final currentUser = getIt<SupabaseClient>().auth.currentUser;

  @override
  void initState() {
    super.initState();
    final currentUsername = currentUser?.userMetadata?['username'] ?? '';
    _usernameController = TextEditingController(text: currentUsername);
    _usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _usernameController.removeListener(_onUsernameChanged);
    _usernameController.dispose();
    super.dispose();
  }

  void _onUsernameChanged() {
    setState(() {
      // _usernameStatusMessage = null;
      _isUsernameAvailable = null;
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_usernameController.text.trim() != (currentUser?.userMetadata?['username'] ?? '')) {
        _checkUsernameAvailability();
      } else {
        setState(() {
          _isUsernameAvailable = true;
          // _usernameStatusMessage = null;
        });
        _formKey.currentState?.validate();
      }
    });
  }

  Future<void> _checkUsernameAvailability() async {
    final username = _usernameController.text.trim().toLowerCase();

    if (username.length < 6) {
      setState(() {
        _isUsernameAvailable = null;
      });
      _formKey.currentState?.validate();
      return;
    }

    setState(() {
      _isCheckingUsername = true;
      // _usernameStatusMessage = "Checking availability...";
    });

    try {
      final isTaken = await getIt<SupabaseClient>().rpc(
        'is_username_taken',
        params: {'username_to_check': username}
      );
      setState(() {
        _isUsernameAvailable = !isTaken;
        // if (_isUsernameAvailable!) {
        //   _usernameStatusMessage = "Username available!";
        // } else {
        //   _usernameStatusMessage = null;
        // }
      });
    } catch (e) {
      setState(() {
        _isUsernameAvailable = null;
        // _usernameStatusMessage = "Error checking username";
      });
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error checking username: ${e.toString()}"),
            backgroundColor: Colors.red
          ),
        );
      }
    } finally {
      setState(() {
        _isCheckingUsername = false;
      });
      _formKey.currentState?.validate();
    }
  }

  Future<void> _onSaveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isUsernameAvailable == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username is already used'),
          backgroundColor: Colors.red,
        )
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final newUsername = _usernameController.text.trim().toLowerCase();
      await context.read<ProfileNotifier>().updateUsername(newUsername);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username updated successfully'),
            backgroundColor: Colors.green,
          )
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          )
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double headerHeight = screenHeight * 0.32;
    final double avatarRadius = screenWidth * 0.13;
    final double horizontalPadding = screenWidth * 0.1;

    final currentUsername = currentUser?.userMetadata?['username'] ?? 'No Username';
    final userEmail = currentUser?.email ?? 'No Email';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          buildHeader(context: context),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: headerHeight - (avatarRadius * 3.3),
                          ),
                          Form(
                            key: _formKey,
                            child: EditProfileCard(
                              avatarRadius: avatarRadius,
                              currentUsername: currentUsername,
                              userEmail: userEmail,
                              usernameController: _usernameController,
                              onUsernameChanged: _onUsernameChanged,
                              usernameValidator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'Username must be at least 6 characters';
                                }
                                if (_isUsernameAvailable == false) {
                                  return 'Username is already used';
                                }
                                if (value.trim().length > 20) {
                                  return "Username can't exceed 20 characters";
                                }
                                return null;
                              },
                              // usernameStatusMessage: _usernameStatusMessage,
                              isCheckingUsername: _isCheckingUsername,
                              isUsernameAvailable: _isUsernameAvailable,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PrimaryButton(
                          text: 'Save',
                          onPressed: _isLoading ? null : _onSaveProfile,
                          isLoading: _isLoading,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ]
      ),
    );
  }
}