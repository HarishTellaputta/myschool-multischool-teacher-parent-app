
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myschool_app/teacher/auth/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String resetToken;

  const ResetPasswordScreen({
    super.key,
    required this.resetToken,
  });

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthService authService = AuthService();

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  static const Color primaryColor = Color(0xff1565C0);
  static const Color backgroundColor = Color(0xffF5F8FC);
  static const Color darkColor = Color(0xff172033);
  static const Color mutedColor = Color(0xff667085);

  // ============================================================
  // RESET PASSWORD
  // ============================================================

  Future<void> _resetPassword() async {
    if (isLoading) return;

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final token = widget.resetToken.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (token.isEmpty) {
      _showMessage(
        'Invalid or expired reset request.',
        Colors.red,
      );
      return;
    }

    if (password != confirmPassword) {
      _showMessage(
        'Passwords do not match.',
        Colors.red,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await authService.resetPassword(
        token: token,
        newPassword: password,
        confirmPassword: confirmPassword,
      );

      if (!mounted) return;

      _showMessage(
        response.trim().isNotEmpty
            ? response
            : 'Password reset successfully.',
        Colors.green,
      );

      await Future.delayed(
        const Duration(milliseconds: 900),
      );

      if (!mounted) return;

      // Return to the first screen, usually Login.
      Navigator.of(context).popUntil(
        (route) => route.isFirst,
      );
    } on DioException catch (e) {
      if (!mounted) return;

      String message = 'Password reset failed. Please try again.';

      final data = e.response?.data;

      if (data is String && data.trim().isNotEmpty) {
        message = data;
      } else if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      } else if (data is Map && data['error'] != null) {
        message = data['error'].toString();
      }

      _showMessage(message, Colors.red);
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Something went wrong. Please try again.',
        Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // ============================================================
  // SNACKBAR MESSAGE
  // ============================================================

  void _showMessage(String message, Color color) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // COMMON INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required bool obscure,
    required VoidCallback onToggleVisibility,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: GoogleFonts.poppins(
        color: mutedColor,
        fontSize: 13,
      ),
      hintStyle: GoogleFonts.poppins(
        color: const Color(0xff98A2B3),
        fontSize: 12,
      ),
      prefixIcon: const Icon(
        Icons.lock_outline_rounded,
        color: primaryColor,
      ),
      suffixIcon: IconButton(
        tooltip: obscure ? 'Show password' : 'Hide password',
        onPressed: isLoading ? null : onToggleVisibility,
        icon: Icon(
          obscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: mutedColor,
        ),
      ),
      filled: true,
      fillColor: const Color(0xffF8FAFC),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xffE4E7EC),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xffE4E7EC),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.6,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.6,
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'Reset Password',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 460,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  24,
                  28,
                  24,
                  24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: const Color(0xffE8EDF4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ICON
                      Center(
                        child: Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: const Color(0xffEAF3FF),
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: const Icon(
                            Icons.lock_reset_rounded,
                            size: 48,
                            color: primaryColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // TITLE
                      Text(
                        'Create New Password',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          color: darkColor,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // DESCRIPTION
                      Text(
                        'Choose a strong password to keep your '
                        'teacher account secure.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          height: 1.6,
                          color: mutedColor,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // NEW PASSWORD LABEL
                      Text(
                        'New Password',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff344054),
                        ),
                      ),

                      const SizedBox(height: 9),

                      // NEW PASSWORD
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        enabled: !isLoading,
                        autocorrect: false,
                        enableSuggestions: false,
                        textInputAction: TextInputAction.next,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: darkColor,
                        ),
                        decoration: _inputDecoration(
                          label: 'Password',
                          hint: 'Enter new password',
                          obscure: obscurePassword,
                          onToggleVisibility: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          final password = value ?? '';

                          if (password.isEmpty) {
                            return 'Please enter a new password';
                          }

                          if (password.length < 8) {
                            return 'Use at least 8 characters';
                          }

                          if (password.trim().isEmpty) {
                            return 'Password cannot contain only spaces';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // CONFIRM PASSWORD LABEL
                      Text(
                        'Confirm Password',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff344054),
                        ),
                      ),

                      const SizedBox(height: 9),

                      // CONFIRM PASSWORD
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: obscureConfirmPassword,
                        enabled: !isLoading,
                        autocorrect: false,
                        enableSuggestions: false,
                        textInputAction: TextInputAction.done,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: darkColor,
                        ),
                        decoration: _inputDecoration(
                          label: 'Confirm Password',
                          hint: 'Re-enter new password',
                          obscure: obscureConfirmPassword,
                          onToggleVisibility: () {
                            setState(() {
                              obscureConfirmPassword =
                                  !obscureConfirmPassword;
                            });
                          },
                        ),
                        validator: (value) {
                          final confirmPassword = value ?? '';

                          if (confirmPassword.isEmpty) {
                            return 'Please confirm your password';
                          }

                          if (confirmPassword !=
                              passwordController.text) {
                            return 'Passwords do not match';
                          }

                          return null;
                        },
                        onFieldSubmitted: (_) {
                          if (!isLoading) {
                            _resetPassword();
                          }
                        },
                      ),

                      const SizedBox(height: 14),

                      // PASSWORD REQUIREMENT
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xffF0F7FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 18,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                'Password must contain at least '
                                '8 characters.',
                                style: GoogleFonts.poppins(
                                  fontSize: 11.5,
                                  height: 1.5,
                                  color: const Color(0xff475467),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 26),

                      // RESET BUTTON
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed:
                              isLoading ? null : _resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            disabledBackgroundColor:
                                primaryColor.withOpacity(0.55),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 23,
                                  height: 23,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Reset Password',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // BACK BUTTON
                      TextButton.icon(
                        onPressed: isLoading
                            ? null
                            : () {
                                Navigator.of(context).maybePop();
                              },
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          size: 18,
                        ),
                        label: Text(
                          'Back',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
