import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:experiment_app/features/profile/presentation/widgets/build_header.dart';
import 'package:experiment_app/features/profile/presentation/widgets/primary_button.dart';
import 'package:experiment_app/features/profile/presentation/manager/profile_notifier.dart';
import 'package:experiment_app/features/profile/presentation/widgets/change_password_card.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSavePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<ProfileNotifier>().updatePassword(
        currentPassword: _currentPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim()
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully'),
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Change Password',
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
                            child: ChangePasswordCard(
                              currentPasswordController: _currentPasswordController,
                              newPasswordController: _newPasswordController,
                              confirmPasswordController: _confirmPasswordController,
                              isCurrentPasswordVisible: _isCurrentPasswordVisible,
                              isNewPasswordVisible: _isNewPasswordVisible,
                              isConfirmPasswordVisible: _isConfirmPasswordVisible,
                              toggleCurrentPasswordVisibility: () => setState(() =>
                                _isCurrentPasswordVisible = !_isCurrentPasswordVisible
                              ),
                              toggleNewPasswordVisibility: () => setState(() =>
                                _isNewPasswordVisible = !_isNewPasswordVisible
                              ),
                              toggleConfirmPasswordVisibility: () => setState(() =>
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible
                              ),
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
                          onPressed: _onSavePassword,
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