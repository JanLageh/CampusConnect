import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/verify_email_provider.dart';

class VerifyEmailScreenRiverpod extends ConsumerWidget {
  const VerifyEmailScreenRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verifyState = ref.watch(verifyEmailProvider);

    const Color primaryDarkBlue = Color(0xFF001e40);
    const Color backgroundSurface = Color(0xFFf8f9fa);
    const Color textDark = Color(0xFF191c1d);

    return Scaffold(
      backgroundColor: backgroundSurface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 48.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.mark_email_read,
                    size: 80,
                    color: primaryDarkBlue,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Verify your email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'We sent a verification link to your email address. Please verify your account to access Campus Connect modules.\n\nOnce verified, return here or login again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: !verifyState.canResend
                        ? null
                        : () => ref
                              .read(verifyEmailProvider.notifier)
                              .resendVerificationEmail(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryDarkBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: verifyState.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            verifyState.secondsLeft > 0
                                ? 'Resend in ${verifyState.secondsLeft} s'
                                : 'Resend Verification Email',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () =>
                        ref.read(verifyEmailProvider.notifier).signOut(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Return to Login',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
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
