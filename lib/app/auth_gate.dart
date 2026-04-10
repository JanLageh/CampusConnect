import 'package:flutter/material.dart';
import '../auth/application/auth_session_controller.dart';
import '../auth/domain/auth_repository.dart';
import '../login_screen.dart';
import '../auth/presentation/verify_email_screen.dart';
import 'protected_module_router.dart';

class AuthGate extends StatelessWidget {
  final AuthRepository authRepository;
  final AuthSessionController authSessionController;

  const AuthGate({
    super.key,
    required this.authRepository,
    required this.authSessionController,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authSessionController.observeAuthState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        final session = snapshot.data;
        
        if (session == null) {
          return LoginScreen(authRepository: authRepository);
        }
        
        if (!session.isEmailVerified) {
          return VerifyEmailScreen(authRepository: authRepository);
        }
        
        return ProtectedModuleRouter(authRepository: authRepository);
      },
    );
  }
}
