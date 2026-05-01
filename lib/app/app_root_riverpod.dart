import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'auth_gate_riverpod.dart';

class AppRootRiverpod extends ConsumerWidget {
  const AppRootRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Failed to initialize Firebase')),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return const AuthGateRiverpod();
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
