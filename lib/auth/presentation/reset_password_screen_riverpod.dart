import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/reset_password_provider.dart';
import '../domain/validators/auth_validator.dart';

class ResetPasswordScreenRiverpod extends ConsumerStatefulWidget {
  const ResetPasswordScreenRiverpod({super.key});

  @override
  ConsumerState<ResetPasswordScreenRiverpod> createState() =>
      _ResetPasswordScreenRiverpodState();
}

class _ResetPasswordScreenRiverpodState
    extends ConsumerState<ResetPasswordScreenRiverpod> {
  final Color primaryDarkBlue = const Color(0xFF001e40);
  final Color backgroundSurface = const Color(0xFFf8f9fa);
  final Color surfaceHighest = const Color(0xFFffffff);
  final Color textDark = const Color(0xFF191c1d);
  final Color errorColor = const Color(0xFFba1a1a);
  final Color successColor = const Color(0xFF006a6a);
  final Color fieldBackground = const Color(0xFFF3F4F6);

  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref
          .read(resetPasswordProvider.notifier)
          .sendResetEmail(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final resetState = ref.watch(resetPasswordProvider);

    // Show success message and navigate back after success
    ref.listen<ResetPasswordState>(resetPasswordProvider, (previous, next) {
      if (next.isSuccess && mounted) {
        Navigator.pop(
          context,
          'Password reset email sent! Check your inbox for instructions.',
        );
      }
    });

    return Scaffold(
      backgroundColor: backgroundSurface,
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: backgroundSurface,
        elevation: 0,
        foregroundColor: textDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                  children: [
                    // Icon
                    Icon(Icons.lock_reset, size: 64, color: primaryDarkBlue),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'Forgot your password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      'Enter your email address and we will send you a link to reset your password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Error message display
                    if (resetState.errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: errorColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: errorColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: errorColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                resetState.errorMessage!,
                                style: TextStyle(
                                  color: errorColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Success message display (shown before navigation)
                    if (resetState.isSuccess) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: successColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: successColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: successColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Password reset email sent! Check your inbox.',
                                style: TextStyle(
                                  color: successColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Email field label
                    Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Email input field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'student@aclc.edu',
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
                      validator: (value) =>
                          AuthValidator.validateEmail(value ?? ''),
                      enabled: !resetState.isLoading,
                    ),
                    const SizedBox(height: 32),

                    // Send Reset Email button
                    ElevatedButton(
                      onPressed: resetState.isLoading ? null : _handleReset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryDarkBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: resetState.isLoading
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
                                  'Send Reset Email',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.send, size: 18),
                              ],
                            ),
                    ),
                    const SizedBox(height: 24),

                    // Back to login link
                    Center(
                      child: TextButton(
                        onPressed: resetState.isLoading
                            ? null
                            : () => Navigator.pop(context),
                        child: Text(
                          'Back to Login',
                          style: TextStyle(
                            color: successColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
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
