import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:experiment_app/injection.dart';
import 'package:experiment_app/features/auth/presentation/widgets/build_error_message.dart';
import 'package:experiment_app/features/auth/presentation/widgets/build_email_field.dart';
import 'package:experiment_app/features/auth/presentation/widgets/build_password_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final Color purple = Color(0xFF7B6EF2);
  final Color buttonColor = const Color(0xFF7B6EF2);

  Timer? _debounce;
  bool _isCheckingUsername = false;
  bool? _isUsernameAvailable;

  Future<void> _signUp() async {
    _clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isUsernameAvailable == false) {
      setState(() {
        _errorMessage = "This username is already used";
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final username = _usernameController.text.trim().toLowerCase();
      await getIt<SupabaseClient>().auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        data: { 'username': username },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration successful. Please check your email for a verification link"),
            backgroundColor: Colors.green,
          )
        );
        context.go('/sign-in');
      }
    } on AuthException catch (e) {
      String message;
      if (e.message.toLowerCase().contains('user already registered')) {
        message = "This email is already registered. Please sign in instead.";
      } else {
        message = "Can't connect to the server. Please check your connection.";
        debugPrint('Auth Error: ${e.message}');
      }

      setState(() {
        _errorMessage = message;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Something went wrong. Please try again later.";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearError() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  void _onUsernameChanged() {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _checkUsernameAvailability();
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
    });

    try {
      final isTaken = await getIt<SupabaseClient>().rpc(
        'is_username_taken',
        params: {
          'username_to_check': username,
        }
      );

      setState(() {
        _isUsernameAvailable = !isTaken;
      });
    } catch (e) {
      setState(() {
        _isUsernameAvailable = null;
      });
    } finally {
      setState(() {
        _isCheckingUsername = false;
      });
      _formKey.currentState?.validate();
    }
  }

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _debounce?.cancel();
    _usernameController.removeListener(_onUsernameChanged);
    _usernameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -screenHeight * 0.3,
            left: -screenWidth * 0.2,
            child: Container(
              height: screenHeight * 0.7,
              width: screenWidth * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: purple,
                    blurRadius: 150,
                    spreadRadius: 25,
                  )
                ]
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.15),

                          const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Text(
                            'Sign Up to Continue',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),

                          buildErrorMessageWidget(
                            errorMessage: _errorMessage
                          ),

                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Username',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Builder(
                                      builder: (context) {
                                        String? helperText;
                                        Color helperColor = Colors.grey;

                                        if (_isCheckingUsername) {
                                          helperText = "Checking availability...";
                                        } else if (_isUsernameAvailable == true) {
                                          helperText = "Username available!";
                                          helperColor = Colors.green;
                                        }

                                        return TextFormField(
                                          controller: _usernameController,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-z0-9_]")),
                                          ],
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Enter a unique username',
                                            helperText: helperText,
                                            helperStyle: TextStyle(color: helperColor),
                                            suffixIcon: _isCheckingUsername
                                              ? Transform.scale(
                                                  scale: 0.5, child: const CircularProgressIndicator(),
                                                )
                                              : null,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide(color: Colors.grey.shade500)),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide(color: Colors.grey.shade500),
                                            ),
                                          ),
                                          maxLength: 20,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return "Username can't be empty";
                                            }
                                            if (value.length < 6) {
                                              return "Username must be at least 6 characters";
                                            }
                                            if (value.length > 20) {
                                              return "Username can't exceed 20 characters";
                                            }

                                            final validCharacters = RegExp(r'^[a-z0-9_]+$');
                                            if (!validCharacters.hasMatch(value)) {
                                              return 'Only lowercase letters, numbers, and underscores are allowed';
                                            }
                                            if (_isUsernameAvailable == false) {
                                              return "This username is already used";
                                            }
                                            return null;
                                          },
                                        );
                                      }
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                buildEmailField(
                                  label: 'Email',
                                  hint: 'Enter your email',
                                  callback: _clearError,
                                  controller: _emailController,
                                ),

                                const SizedBox(height: 16),

                                buildPasswordField(
                                  label: 'Password',
                                  hint: 'Enter your password',
                                  isPasswordVisible: _isPasswordVisible,
                                  callback: _clearError,
                                  togglePasswordVisibility: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  controller: _passwordController,
                                ),

                                const SizedBox(height: 16),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Confirm Password',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    TextFormField(
                                      controller: _confirmPasswordController,
                                      onChanged: (_) => _clearError(),
                                      obscureText: !_isConfirmPasswordVisible,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Confirm your password',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey.shade500)
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey.shade500),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isConfirmPasswordVisible
                                              ? LucideIcons.eye
                                              : LucideIcons.eye_off
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value != _passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      }
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: const Text(
                        'Sign in here',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.05),
              ]
            ),
          )
        ],
      ),
    );
  }
}