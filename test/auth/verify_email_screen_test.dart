import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campusconnect/auth/presentation/verify_email_screen.dart';
import 'package:campusconnect/auth/domain/auth_repository.dart';
import 'package:campusconnect/auth/models/auth_session.dart';

class MockAuthRepository implements AuthRepository {
  bool sendVerificationCalled = false;
  bool signOutCalled = false;

  @override
  Future<void> sendVerificationEmail() async {
    sendVerificationCalled = true;
    return Future.value();
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
    return Future.value();
  }

  @override
  Future<void> sendPasswordReset({required String email}) => throw UnimplementedError();
  @override
  Stream<AuthSession?> observeAuthState() => const Stream.empty();
  @override
  Future<AuthSession> signIn({required String email, required String password}) => throw UnimplementedError();
  @override
  Future<AuthSession> signUp({required String email, required String password}) => throw UnimplementedError();
}

void main() {
  testWidgets('pressing resend sends email and disables button due to cooldown', (tester) async {
    final mockRepo = MockAuthRepository();

    await tester.pumpWidget(MaterialApp(
      home: VerifyEmailScreen(authRepository: mockRepo),
    ));

    // Tap resend
    await tester.tap(find.text('Resend Verification Email'));
    await tester.pump();

    // Verify
    expect(mockRepo.sendVerificationCalled, isTrue);

    // Verify it changed to cooldown message
    expect(find.textContaining('Resend in'), findsOneWidget);

    // Button should be disabled now
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);

    // Wait for cooldown (to avoid timer warnings at end of test)
    await tester.pumpAndSettle(const Duration(seconds: 46));
  });

  testWidgets('pressing sign out calls signOut', (tester) async {
    final mockRepo = MockAuthRepository();

    await tester.pumpWidget(MaterialApp(
      home: VerifyEmailScreen(authRepository: mockRepo),
    ));

    await tester.ensureVisible(find.text('Return to Login'));
    await tester.tap(find.text('Return to Login'));
    await tester.pumpAndSettle();

    expect(mockRepo.signOutCalled, isTrue);
  });
}
