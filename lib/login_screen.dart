import 'package:flutter/material.dart';
import 'auth/presentation/login_controller.dart';
import 'auth/data/firebase_auth_repository.dart';
import 'auth/domain/auth_repository.dart';
import 'auth/presentation/auth_validators.dart';
import 'auth/presentation/sign_up_screen.dart';
import 'auth/presentation/reset_password_screen.dart';
import 'auth/presentation/login_status_banner.dart';

class LoginScreen extends StatefulWidget {
  final AuthRepository? authRepository;

  const LoginScreen({super.key, this.authRepository});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color primaryDarkBlue = const Color(0xFF001e40);
  final Color primaryContainer = const Color(0xFF003366);
  final Color backgroundSurface = const Color(0xFFf8f9fa);
  final Color surfaceHighest = const Color(0xFFffffff);
  final Color secondaryContainer = const Color(0xFF90efef);
  final Color textDark = const Color(0xFF191c1d);
  final Color errorColor = const Color(0xFFba1a1a);
  final Color fieldBackground = const Color(0xFFF3F4F6);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late LoginController _controller;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(
      authRepository: widget.authRepository ?? FirebaseAuthRepository(),
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _controller.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundSurface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: primaryDarkBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.school_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // School Title
                    Text(
                      'ACLC College of Mandaue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: primaryDarkBlue,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Welcome Text
                    Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Log in to your campus dashboard.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),

                    if (_statusMessage != null)
                      LoginStatusBanner(
                        message: _statusMessage!,
                        onDismiss: () => setState(() => _statusMessage = null),
                      ),

                    if (_controller.errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: errorColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _controller.errorMessage!,
                          style: TextStyle(color: errorColor, fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Email Field
                    Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'student@horizon.edu',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.grey.shade500,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: fieldBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: AuthValidators.validateEmail,
                    ),
                    const SizedBox(height: 20),

                    // Password Field Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ResetPasswordScreen(
                                  authRepository: widget.authRepository,
                                ),
                              ),
                            );
                            if (result is String && result.isNotEmpty) {
                              setState(() => _statusMessage = result);
                              _controller.clearError();
                            }
                          },
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF006a6a),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          letterSpacing: 2.0,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey.shade500,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: fieldBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Sign In Button
                    ElevatedButton(
                      onPressed: _controller.isLoading ? null : _handleSignIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryDarkBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: _controller.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 20),
                              ],
                            ),
                    ),

                    const SizedBox(height: 32),

                    // Or Continue With Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey.shade300, thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR CONTINUE WITH',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade400,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey.shade300, thickness: 1),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),

                    // Social Logins (Student Number)
                    ElevatedButton(
                      onPressed: () {
                        // Handle Student Number login
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFAFAFA),
                        foregroundColor: textDark,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Center(
                              child: Icon(Icons.person, size: 10, color: Colors.grey.shade600),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Login with Student Number',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Sign Up Text
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: const Color(0xFF006a6a),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Footer
                    Text(
                      '© 2024 ACLC COLLEGE OF MANDAUE • CSO VERIFIED',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade400,
                        letterSpacing: 0.5,
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
