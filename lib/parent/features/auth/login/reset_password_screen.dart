
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:myschool_app/parent/services/api_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({
    super.key,
    required this.token,
  });

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final schoolCodeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  static const Color primary = Color(0xff3155D9);
  static const Color background = Color(0xffF6F8FC);
  static const Color textDark = Color(0xff172033);
  static const Color textMuted = Color(0xff697386);

  @override
  void dispose() {
    schoolCodeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (isLoading) return;

    FocusScope.of(context).unfocus();

    final schoolCode = schoolCodeController.text.trim();
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (schoolCode.isEmpty) {
      _showMessage('Please enter your School Code', true);
      return;
    }

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Please enter both passwords', true);
      return;
    }

    if (newPassword.length < 8) {
      _showMessage(
        'Password must be at least 8 characters',
        true,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage('Passwords do not match', true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await ApiService.post(
        '/auth/reset-password',
        body: {
          'token': widget.token,
          'schoolCode': schoolCode,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );

      if (!mounted) return;

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        _showMessage('Password reset successful', false);

        await Future.delayed(
          const Duration(milliseconds: 900),
        );

        if (!mounted) return;

        Navigator.of(context).popUntil(
          (route) => route.isFirst,
        );
      } else {
        String message = 'Failed to reset password';

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

        _showMessage(message, true);
      }
    } catch (e) {
      if (!mounted) return;

      debugPrint('RESET PASSWORD ERROR: $e');

      _showMessage(
        'Unable to connect to server. Please try again.',
        true,
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showMessage(String message, bool isError) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12.5,
            ),
          ),
          backgroundColor:
              isError ? Colors.red.shade700 : Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: GoogleFonts.poppins(
        color: textMuted,
        fontSize: 13,
      ),
      hintStyle: GoogleFonts.poppins(
        color: textMuted,
        fontSize: 12,
      ),
      prefixIcon: Icon(icon, color: primary),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xffE5E9F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xffE5E9F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primary, width: 1.5),
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
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: GoogleFonts.poppins(
            color: textDark,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: background,
        foregroundColor: textDark,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xffE5E9F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.035),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        height: 68,
                        width: 68,
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(21),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'MySchool',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: primary,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Create New Password',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: textDark,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your School Code and choose a new password.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: textMuted,
                        fontSize: 12.5,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 26),

                    _buildLabel('School Code'),
                    TextField(
                      controller: schoolCodeController,
                      textCapitalization: TextCapitalization.characters,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(
                        label: 'School Code',
                        hint: 'Enter your School Code',
                        icon: Icons.business_outlined,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildLabel('New Password'),
                    TextField(
                      controller: newPasswordController,
                      obscureText: obscureNewPassword,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(
                        label: 'New Password',
                        hint: 'At least 8 characters',
                        icon: Icons.lock_outline_rounded,
                        suffixIcon: IconButton(
                          tooltip: obscureNewPassword
                              ? 'Show password'
                              : 'Hide password',
                          icon: Icon(
                            obscureNewPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: textMuted,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureNewPassword = !obscureNewPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildLabel('Confirm Password'),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        if (!isLoading) _resetPassword();
                      },
                      decoration: _inputDecoration(
                        label: 'Confirm Password',
                        hint: 'Re-enter new password',
                        icon: Icons.lock_outline_rounded,
                        suffixIcon: IconButton(
                          tooltip: obscureConfirmPassword
                              ? 'Show password'
                              : 'Hide password',
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: textMuted,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword =
                                  !obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 27),

                    SizedBox(
                      height: 53,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              const Color(0xff9EAFE9),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.3,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Reset Password',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 17),
                    Text(
                      'Your reset link is valid for a limited time.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: textMuted,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
