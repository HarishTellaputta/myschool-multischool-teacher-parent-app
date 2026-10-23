
import 'package:flutter/material.dart';

import 'package:myschool_app/parent/features/auth/login/login_screen.dart'
    as parent;
import 'package:myschool_app/teacher/auth/login_screen.dart'
    as teacher;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MySchoolApp());
}

class MySchoolApp extends StatelessWidget {
  const MySchoolApp({super.key});

  static const Color primary = Color(0xFF3155D9);
  static const Color background = Color(0xFFF5F7FC);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MySchool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
      ),
      home: const RoleSelectionScreen(),
    );
  }
}

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  static const Color primary = MySchoolApp.primary;

  void _openParentLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const parent.LoginScreen(),
      ),
    );
  }

  void _openTeacherLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const teacher.LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 28,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 18),

                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withOpacity(0.22),
                            blurRadius: 28,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        size: 56,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'MySchool',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF172033),
                      letterSpacing: 0.3,
                    ),
                  ),

                  const SizedBox(height: 9),

                  const Text(
                    'Learning Today, Leading Tomorrow',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF697386),
                    ),
                  ),

                  const SizedBox(height: 42),

                  const Text(
                    'Welcome!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF172033),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Choose how you want to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF697386),
                    ),
                  ),

                  const SizedBox(height: 28),

                  _RoleCard(
                    icon: Icons.family_restroom_rounded,
                    title: 'Parent Login',
                    subtitle:
                        'View attendance, homework and school updates',
                    color: primary,
                    onTap: () => _openParentLogin(context),
                  ),

                  const SizedBox(height: 18),

                  _RoleCard(
                    icon: Icons.cast_for_education_rounded,
                    title: 'Teacher Login',
                    subtitle:
                        'Manage classes, attendance and homework',
                    color: const Color(0xFF16805D),
                    onTap: () => _openTeacherLogin(context),
                  ),

                  const SizedBox(height: 36),

                  const Text(
                    'MySchool • School Management App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF929AA8),
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

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFE6EAF2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 31,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172033),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: Color(0xFF697386),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 17,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
