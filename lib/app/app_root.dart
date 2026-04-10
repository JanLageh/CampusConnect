import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../login_screen.dart';
import '../auth/domain/auth_repository.dart';

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
          return StreamBuilder(
            stream: authRepository.observeAuthState(),
            builder: (context, authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              final session = authSnapshot.data;
              if (session == null) {
                return const LoginScreen();
              }
              return Scaffold(body: Center(child: Text('Welcome, ${session.email}')));
            },
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
