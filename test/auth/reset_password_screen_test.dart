import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campusconnect/login_screen.dart';
import 'package:campusconnect/auth/presentation/reset_password_screen.dart';
import 'package:campusconnect/auth/presentation/login_status_banner.dart';
import 'package:campusconnect/auth/domain/auth_repository.dart';
import 'package:campusconnect/auth/models/auth_session.dart';

class MockAuthRepository implements AuthRepository {
  bool resetCalled = false;
  String? resetEmail;

  @override
  Future<void> sendPasswordReset({required String email}) async {
    resetCalled = true;
    resetEmail = email;
    return Future.value();
  }

  @override
  Stream<AuthSession?> observeAuthState() => const Stream.empty();
  @override
  Future<AuthSession> signIn({required String email, required String password}) => throw UnimplementedError();
  @override
  Future<AuthSession> signUp({required String email, required String password}) => throw UnimplementedError();
  @override
  Future<void> sendVerificationEmail() => throw UnimplementedError();
  @override
  Future<void> signOut() => throw UnimplementedError();
}

void main() {
  testWidgets('tapping forgot password navigates to reset screen', (tester) async {
    final mockRepo = MockAuthRepository();
    await tester.pumpWidget(MaterialApp(home: LoginScreen(authRepository: mockRepo)));

    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();

    expect(find.byType(ResetPasswordScreen), findsOneWidget);
  });

  testWidgets('submitting email shows confirmation and returns to login with banner', (tester) async {
    final mockRepo = MockAuthRepository();
    await tester.pumpWidget(MaterialApp(home: LoginScreen(authRepository: mockRepo)));

    // Navigate to reset screen
    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();

    // Enter email and submit
    await tester.enterText(find.byType(TextFormField).first, 'test@horizon.edu');
    await tester.tap(find.text('Send Reset Link'));
    await tester.pumpAndSettle();

    // Verify it called repo
    expect(mockRepo.resetCalled, isTrue);
    expect(mockRepo.resetEmail, 'test@horizon.edu');

    // Verify it navigated back to login screen
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(ResetPasswordScreen), findsNothing);

    // Verify banner is shown
    expect(find.byType(LoginStatusBanner), findsOneWidget);
    expect(find.text('Check your email for a password reset link.'), findsOneWidget);
  });
}
