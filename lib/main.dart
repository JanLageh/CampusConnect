import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app_root_riverpod.dart';
import 'app/routes.dart';
import 'firebase_options.dart';
import 'appwrite_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize and ping Appwrite to verify connectivity
  try {
    await AppwriteConfig.ping();
  } catch (e) {
    // ignore: avoid_print
    print('Warning: Could not connect to Appwrite: $e');
  }

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Connect',
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      // Use AppRootRiverpod as the home widget (handles auth gate)
      home: const AppRootRiverpod(),
      // Configure route generator for named navigation
      onGenerateRoute: AppRouteGenerator.generateRoute,
      // Set initial route
      initialRoute: '/',
    );
  }
}
