import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:experiment_app/injection.dart';
import 'package:experiment_app/features/auth/presentation/widgets/build_error_message.dart';
import 'package:experiment_app/features/auth/presentation/widgets/build_password_field.dart';
import 'package:experiment_app/features/auth/presentation/widgets/build_email_field.dart';
import 'package:experiment_app/features/auth/presentation/widgets/logo_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  String? _errorMessage;

  final Color buttonColor = const Color(0xFF7B6EF2);

  Future<void> _signIn() async {
    _clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await getIt<SupabaseClient>().auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        context.go('/home');
      }
    } on AuthException catch (e) {
      String message;
      if (e.message.toLowerCase().contains('invalid login credentials')) {
        message = "Oops! Incorrect email or password. Please try again.";
      } else if (e.message.toLowerCase().contains('email not confirmed')) {
        message = "This account has not been verified. Please check your email for a verification link.";
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                      SizedBox(
                        height: screenHeight * 0.1,
                      ),

                      const LogoWidget(),

                      const SizedBox(height: 32),

                      const Text(
                        'Welcome back👋',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Text(
                        'Sign In to Continue',
                        style: TextStyle(
                          fontSize: 14
                        ),
                      ),

                      buildErrorMessageWidget(
                        errorMessage: _errorMessage,
                      ),

                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildEmailField(
                              label: 'Email',
                              hint: 'Enter your email',
                              callback: _clearError,
                              controller: _emailController,
                            ),

                            const SizedBox(height: 16),

                            buildPasswordField(
                              label: 'Password',
                              hint: 'Enter your Password',
                              isPasswordVisible: _isPasswordVisible,
                              callback: _clearError,
                              togglePasswordVisibility: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              controller: _passwordController,
                            )
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
                horizontal: screenWidth * 0.08,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black26,
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
                        'Sign In',
                        style: TextStyle(
                          fontSize: 14, color: Colors.white
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
                  "Don't have an account? ",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    context.push('/sign-up');
                  },
                  child: const Text(
                    'Sign up here',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14
                    ),
                  ),
                )
              ],
            ),

            SizedBox(
              height: screenHeight * 0.05
            ),
          ],
        )
      ),
    );
  }
}