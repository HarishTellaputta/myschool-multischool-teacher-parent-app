import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:myschool_app/parent/features/home/parent_home_screen.dart';
import 'package:myschool_app/parent/services/api_service.dart';
import 'package:myschool_app/parent/storage/local_storage.dart';
import 'package:myschool_app/parent/features/auth/login/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController schoolCodeController =
      TextEditingController();
  final TextEditingController usernameController =
      TextEditingController();
  final TextEditingController passwordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  static const Color primaryColor = Color(0xFF2563EB);
  static const Color backgroundColor = Color(0xFFF5F7FC);
  static const Color textColor = Color(0xFF172033);
  static const Color secondaryTextColor = Color(0xFF778197);

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              isError ? Colors.red.shade700 : Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

 
Future<void> login() async {
  if (_isLoading) return;

  FocusScope.of(context).unfocus();

  if (!_formKey.currentState!.validate()) return;

  final schoolCode = schoolCodeController.text.trim();
  final username = usernameController.text.trim();
  final password = passwordController.text;

  setState(() => _isLoading = true);

  try {
    final response = await ApiService.post(
      '/auth/login',
      body: {
        'schoolCode': schoolCode,
        'username': username,
        'password': password,
      },
    );

    if (!mounted) return;

    final dynamic decoded = ApiService.decodeResponse(response);

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      String message = 'Login failed. Check your credentials.';

      if (decoded is Map) {
        message = decoded['message']?.toString() ??
            decoded['error']?.toString() ??
            message;
      }

      _showMessage(message, isError: true);
      return;
    }

    if (decoded is! Map) {
      _showMessage(
        'Invalid response from server.',
        isError: true,
      );
      return;
    }

    final data = Map<String, dynamic>.from(decoded);

    final token = data['token']?.toString();
    final role = data['role']?.toString().toUpperCase();

    final roles = (data['roles'] as List?)
            ?.map((item) => item.toString().toUpperCase())
            .toList() ??
        <String>[];

    if (token == null || token.isEmpty) {
      _showMessage('Login token not received.', isError: true);
      return;
    }

    if (role != 'PARENT' && !roles.contains('PARENT')) {
      _showMessage(
        'This login is for parent accounts only.',
        isError: true,
      );
      return;
    }

    // Save the session using your existing LocalStorage methods.
    // Do not navigate until the token and required user details
    // have been saved as expected by your application.

    _showMessage('Login successful');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const ParentHomeScreen(),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    _showMessage(
      'Unable to connect to the server. Please try again.',
      isError: true,
    );
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        color: secondaryTextColor,
        fontSize: 13,
      ),
      prefixIcon: Icon(icon, color: primaryColor, size: 21),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE3E8F2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE3E8F2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('School Code'),
          TextFormField(
            controller: schoolCodeController,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: _inputDecoration(
              hint: 'Enter your School Code',
              icon: Icons.school_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'School Code is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          _buildLabel('Username'),
          TextFormField(
            controller: usernameController,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 14,
            ),
            decoration: _inputDecoration(
              hint: 'Enter your username',
              icon: Icons.person_outline_rounded,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Username is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          _buildLabel('Password'),
          TextFormField(
            controller: passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => login(),
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 14,
            ),
            decoration: _inputDecoration(
              hint: 'Enter your password',
              icon: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                tooltip:
                    _obscurePassword ? 'Show password' : 'Hide password',
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: secondaryTextColor,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 28),
          
          // Forgot Password option
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 8,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),


          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : login,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                disabledBackgroundColor: primaryColor.withValues(alpha: 0.6),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 23,
                      width: 23,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    schoolCodeController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 28,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),

                  // Common branding for every school.
                  Center(
                    child: Container(
                      height: 76,
                      width: 76,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.18),
                            blurRadius: 22,
                            offset: const Offset(0, 9),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Center(
                    child: Text(
                      'MySchool',
                      style: GoogleFonts.poppins(
                        color: primaryColor,
                        fontSize: 29,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  Center(
                    child: Text(
                      'Your School, Connected.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: secondaryTextColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE9EDF5)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF172033)
                              .withValues(alpha: 0.04),
                          blurRadius: 28,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back!',
                          style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Login to access your parent account.',
                          style: GoogleFonts.poppins(
                            color: secondaryTextColor,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 27),
                        _buildLoginForm(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  Center(
                    child: Text(
                      'One app for all your school needs',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: secondaryTextColor,
                        fontSize: 11,
                      ),
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
