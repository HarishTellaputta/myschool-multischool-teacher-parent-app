
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:myschool_app/parent/services/api_service.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController schoolCodeController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  static const Color primary = Color(0xff3155D9);
  static const Color background = Color(0xffF6F8FC);
  static const Color textDark = Color(0xff172033);
  static const Color textMuted = Color(0xff697386);

  Future<void> _forgotPassword() async {
    FocusScope.of(context).unfocus();

    final schoolCode = schoolCodeController.text.trim();
    final email = emailController.text.trim();

    if (schoolCode.isEmpty) {
      _showMessage('Please enter your School Code', isError: true);
      return;
    }

    if (email.isEmpty) {
      _showMessage('Please enter your email address', isError: true);
      return;
    }

    if (!email.contains('@')) {
      _showMessage('Please enter a valid email address', isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await ApiService.post(
        '/auth/forgot-password',
        body: {
          'schoolCode': schoolCode,
          'email': email,
        },
      );

      if (!mounted) return;

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        String responseText = response.body.trim();

        // Backend currently returns:
        // Password reset token generated: <token>
        // This is suitable only for development/testing.
        try {
          final decoded = jsonDecode(responseText);

          if (decoded is Map) {
            responseText =
                decoded['message']?.toString() ?? responseText;
          }
        } catch (_) {
          // Response may be plain text rather than JSON.
        }

        const prefix = 'Password reset token generated:';

        if (responseText.startsWith(prefix)) {
          final token = responseText.substring(prefix.length).trim();

          if (token.isEmpty) {
            _showMessage(
              'Reset token was not received.',
              isError: true,
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResetPasswordScreen(token: token),
            ),
          );
        } else {
          _showMessage(
            responseText.isNotEmpty
                ? responseText
                : 'Reset request processed.',
          );
        }
      } else {
        String message = 'Unable to process password reset request.';

        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map) {
            message = decoded['message']?.toString() ??
                decoded['error']?.toString() ??
                message;
          } else if (response.body.trim().isNotEmpty) {
            message = response.body.trim();
          }
        } catch (_) {
          if (response.body.trim().isNotEmpty) {
            message = response.body.trim();
          }
        }

        _showMessage(message, isError: true);
      }
    } catch (e) {
      if (!mounted) return;

      debugPrint('FORGOT PASSWORD ERROR: $e');

      _showMessage(
        'Unable to connect to server. Please try again.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError
                    ? Icons.error_outline_rounded
                    : Icons.check_circle_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          backgroundColor:
              isError ? const Color(0xffD93025) : const Color(0xff188038),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        color: textMuted,
        fontSize: 12.5,
      ),
      prefixIcon: Icon(icon, color: primary),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xffE5E9F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xffE5E9F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: primary,
          width: 1.6,
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: textDark,
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  void dispose() {
    schoolCodeController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
        foregroundColor: textDark,
        title: Text(
          'Forgot Password',
          style: GoogleFonts.poppins(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 39,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'MySchool',
                      style: GoogleFonts.poppins(
                        color: primary,
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xffE5E9F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.lock_reset_rounded,
                          color: primary,
                          size: 42,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Reset Your Password',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: textDark,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your School Code and registered email address.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: textMuted,
                            fontSize: 12.5,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 25),

                        _buildLabel('School Code'),
                        TextField(
                          controller: schoolCodeController,
                          textCapitalization: TextCapitalization.characters,
                          autocorrect: false,
                          textInputAction: TextInputAction.next,
                          decoration: _inputDecoration(
                            hint: 'Enter your School Code',
                            icon: Icons.business_outlined,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildLabel('Email Address'),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            if (!isLoading) _forgotPassword();
                          },
                          decoration: _inputDecoration(
                            hint: 'Enter your registered email',
                            icon: Icons.email_outlined,
                          ),
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _forgotPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  const Color(0xff9EAFE9),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Continue',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'If you cannot reset your password, contact your school administrator.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: textMuted,
                            fontSize: 11.5,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
