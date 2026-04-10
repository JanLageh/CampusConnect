import 'package:flutter/material.dart';
import 'app/app_root.dart';
import 'auth/data/firebase_auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
