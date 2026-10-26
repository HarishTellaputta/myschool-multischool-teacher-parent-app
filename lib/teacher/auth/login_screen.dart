
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:myschool_app/teacher/home/teacher_home_screen.dart';
import 'package:myschool_app/teacher/auth/auth_service.dart';
import 'package:myschool_app/teacher/auth/auth_storage.dart';
import 'package:myschool_app/teacher/auth/forgot_password_screen.dart';
import 'package:myschool_app/teacher/auth/register_screen.dart';
import 'package:myschool_app/teacher/services/teacher_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final schoolCodeController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService authService = AuthService();

  bool obscurePassword = true;
  bool isLoading = false;

  static const primary = Color(0xFF2563EB);
  static const background = Color(0xFFF5F7FC);
  static const dark = Color(0xFF172033);
  static const muted = Color(0xFF778197);
  static const border = Color(0xFFE3E8F2);

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
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.school_outlined,
                      color: primary,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Teacher Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to access your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: muted),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'School Code',
                          style: TextStyle(
                            color: dark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: schoolCodeController,
                          textCapitalization:
                              TextCapitalization.characters,
                          textInputAction: TextInputAction.next,
                          decoration: _decoration(
                            'Enter your school code',
                            Icons.domain_outlined,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Username',
                          style: TextStyle(
                            color: dark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: usernameController,
                          textInputAction: TextInputAction.next,
                          decoration: _decoration(
                            'Enter your username',
                            Icons.person_outline,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Password',
                              style: TextStyle(
                                color: dark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : _openForgotPassword,
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(color: primary),
                              ),
                            ),
                          ],
                        ),
                        TextField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            if (!isLoading) _login();
                          },
                          decoration: _decoration(
                            'Enter your password',
                            Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: muted,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        OutlinedButton(
                          onPressed:
                              isLoading ? null : _openRegister,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primary,
                            side: const BorderSide(color: border),
                            minimumSize:
                                const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              const Text('Create Teacher Account'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 15,
                        color: muted,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Secure teacher access',
                        style: TextStyle(
                          fontSize: 12,
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: muted,
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icon,
        color: primary,
        size: 21,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: primary,
          width: 1.5,
        ),
      ),
    );
  }

  Future<void> _openForgotPassword() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ForgotPasswordScreen(),
      ),
    );
  }

  Future<void> _openRegister() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    final schoolCode =
        schoolCodeController.text.trim().toUpperCase();
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (schoolCode.isEmpty) {
      _showMessage('Please enter school code');
      return;
    }

    if (username.isEmpty) {
      _showMessage('Please enter username');
      return;
    }

    if (password.isEmpty) {
      _showMessage('Please enter password');
      return;
    }

    setState(() => isLoading = true);

    try {
      // AuthService.login must accept schoolCode and send it
      // to the backend as part of the login request.
      final response = await authService.login(
        schoolCode: schoolCode,
        username: username,
        password: password,
      );

      final token = response['token']?.toString();
      final userId = response['userId'];
      final loggedInUsername =
          response['username']?.toString();
      final role =
          response['role']?.toString().trim().toUpperCase();

      if (role != 'TEACHER') {
        throw Exception(
          'Teacher account tho maatrame Teacher Login cheyyagalru.',
        );
      }

      if (token == null || token.isEmpty) {
        throw Exception('Login token not found.');
      }

      if (userId == null) {
        throw Exception('User ID not found.');
      }

      final parsedUserId = int.tryParse(userId.toString());
      if (parsedUserId == null) {
        throw Exception('Invalid User ID.');
      }

      await AuthStorage.saveToken(token);
      await AuthStorage.saveUserId(parsedUserId);
      await AuthStorage.saveTeacherUsername(
        loggedInUsername ?? '',
      );
      await AuthStorage.saveTeacherRole(role!);

      final teacherService = TeacherService(token);
      final teacherData =
          await teacherService.getTeacherByUserId(
        parsedUserId,
      );

      final teacherId = teacherData['id'];
      if (teacherId == null) {
        throw Exception(
          'Teacher profile not found for this user.',
        );
      }

      final parsedTeacherId =
          int.tryParse(teacherId.toString());
      if (parsedTeacherId == null) {
        throw Exception('Invalid Teacher ID.');
      }

      await AuthStorage.saveTeacherId(parsedTeacherId);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const TeacherHomeScreen(),
        ),
      );
    } on DioException catch (e) {
      String message = 'Login failed. Please try again.';
      final data = e.response?.data;

      if (data is Map) {
        message = data['message']?.toString() ??
            data['error']?.toString() ??
            message;
      } else if (data is String && data.isNotEmpty) {
        message = data;
      }

      if (mounted) _showMessage(message);
    } catch (e) {
      if (mounted) {
        _showMessage(
          e.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
