import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../auth/domain/auth_repository.dart';
import 'auth_gate.dart';

class AppRoot extends StatelessWidget {
  final AuthRepository authRepository;

  const AppRoot({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text('Failed to initialize Firebase')));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return AuthGate(authRepository: authRepository);
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
