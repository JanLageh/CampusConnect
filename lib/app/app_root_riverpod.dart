import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import 'auth_gate_riverpod.dart';

class AppRootRiverpod extends ConsumerStatefulWidget {
  const AppRootRiverpod({super.key});

  @override
  ConsumerState<AppRootRiverpod> createState() => _AppRootRiverpodState();
}

class _AppRootRiverpodState extends ConsumerState<AppRootRiverpod> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Access the auth state provider to trigger initialization
      ref.read(authStateNotifierProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    // The AuthGate will handle routing based on authentication state
    // It checks for existing session, restores it if valid, and redirects accordingly
    return const AuthGateRiverpod();
  }
}
