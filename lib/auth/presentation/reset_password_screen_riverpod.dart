import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/reset_password_provider.dart';
import '../domain/validators/auth_validator.dart';
import '../../core/widgets/widgets.dart';

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
  final Color textDark = const Color(0xFF191c1d);

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
                    Icon(Icons.lock_reset, size: 64, color: primaryDarkBlue),
                    const SizedBox(height: 24),

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

                    Text(
                      'Enter your email address and we will send you a link to reset your password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),

                    if (resetState.errorMessage != null) ...[
                      ErrorContainer(
                        message: resetState.errorMessage!,
                        type: MessageType.error,
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (resetState.isSuccess) ...[
                      const ErrorContainer(
                        message: 'Password reset email sent! Check your inbox.',
                        type: MessageType.success,
                      ),
                      const SizedBox(height: 16),
                    ],

                    const FormLabel(text: 'Email Address'),
                    const SizedBox(height: 8),

                    FormInputField(
                      controller: _emailController,
                      hintText: 'student@aclc.edu',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          AuthValidator.validateEmail(value ?? ''),
                      enabled: !resetState.isLoading,
                    ),
                    const SizedBox(height: 32),

                    PrimaryButton(
                      text: 'Send Reset Email',
                      onPressed: resetState.isLoading ? null : _handleReset,
                      isLoading: resetState.isLoading,
                      icon: Icons.send,
                    ),
                    const SizedBox(height: 24),

                    Center(
                      child: SecondaryButton(
                        text: 'Back to Login',
                        onPressed: resetState.isLoading
                            ? null
                            : () => Navigator.pop(context),
                        fullWidth: false,
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
