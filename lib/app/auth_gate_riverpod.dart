import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import '../auth/presentation/login_screen_riverpod.dart';
import '../auth/presentation/verify_email_screen_riverpod.dart';
import 'protected_module_router_riverpod.dart';

class AuthGateRiverpod extends ConsumerWidget {
  const AuthGateRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (session) {
        if (session == null) {
          // User is not signed in
          return const LoginScreenRiverpod();
        }

        if (!session.isEmailVerified) {
          // User is signed in but email not verified
          return const VerifyEmailScreenRiverpod();
        }

        // User is signed in and verified
        return const ProtectedModuleRouterRiverpod();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Retry by invalidating the provider
                  ref.invalidate(authStateProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
