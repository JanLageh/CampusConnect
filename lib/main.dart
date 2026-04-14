import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app_root.dart';
import 'auth/data/firebase_auth_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppRoot(authRepository: FirebaseAuthRepository()),
    );
  }
}
