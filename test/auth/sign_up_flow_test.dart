import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campusconnect/auth/presentation/sign_up_screen.dart';
import 'package:campusconnect/auth/domain/auth_repository.dart';
import 'package:campusconnect/auth/domain/user_profile_repository.dart';
import 'package:campusconnect/auth/models/auth_session.dart';

class MockAuthRepository implements AuthRepository {
  bool sendVerificationEmailCalled = false;

  @override
  Stream<AuthSession?> observeAuthState() => const Stream.empty();

  @override
  Future<AuthSession> signIn({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<AuthSession> signUp({required String email, required String password}) async {
    if (password.length >= 8 && RegExp(r'[a-zA-Z]').hasMatch(password) && RegExp(r'[0-9]').hasMatch(password)) {
      return AuthSession(uid: 'user123', email: email);
    }
    throw Exception('weak-password');
  }

  @override
  Future<void> sendVerificationEmail() async {
    sendVerificationEmailCalled = true;
  }

  @override
  Future<void> sendPasswordReset({required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }
}

class MockUserProfileRepository implements UserProfileRepository {
  Map<String, dynamic>? lastBootstrapPayload;

  @override
  Future<Map<String, dynamic>> bootstrapUserProfile({
    required String uid,
    required String email,
  }) async {
    lastBootstrapPayload = {
      'uid': uid,
      'email': email,
      'role': 'student',
      'createdAt': DateTime.now().toIso8601String(),
    };
    return lastBootstrapPayload!;
  }
}

void main() {
  testWidgets('SignUpScreen enforces password policy', (WidgetTester tester) async {
    final mockAuth = MockAuthRepository();
    final mockProfile = MockUserProfileRepository();

    await tester.pumpWidget(MaterialApp(
      home: SignUpScreen(
        authRepository: mockAuth,
        userProfileRepository: mockProfile,
      ),
    ));

    await tester.enterText(find.byType(TextFormField).first, 'student@horizon.edu');
    
    // Enter weak password
    await tester.enterText(find.byType(TextFormField).at(1), 'weak');
    await tester.enterText(find.byType(TextFormField).last, 'weak');
    
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
    await tester.pumpAndSettle();

    expect(find.text('Password must be at least 8 characters long'), findsOneWidget);
  });

  testWidgets('Successful sign-up creates profile, sends verification, and navigates', (WidgetTester tester) async {
    final mockAuth = MockAuthRepository();
    final mockProfile = MockUserProfileRepository();

    await tester.pumpWidget(MaterialApp(
      home: SignUpScreen(
        authRepository: mockAuth,
        userProfileRepository: mockProfile,
      ),
    ));

    await tester.enterText(find.byType(TextFormField).first, 'new@horizon.edu');
    await tester.enterText(find.byType(TextFormField).at(1), 'Valid123');
    await tester.enterText(find.byType(TextFormField).last, 'Valid123');
    
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
    await tester.pumpAndSettle();

    expect(mockProfile.lastBootstrapPayload, isNotNull);
    expect(mockProfile.lastBootstrapPayload!['email'], 'new@horizon.edu');
    expect(mockProfile.lastBootstrapPayload!['role'], 'student');
    expect(mockAuth.sendVerificationEmailCalled, isTrue);
    
    // Check navigation to verify email
    expect(find.text('Verify Email'), findsOneWidget);
  });
}
