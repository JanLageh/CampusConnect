import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campusconnect/login_screen.dart';
import 'package:campusconnect/auth/domain/auth_repository.dart';
import 'package:campusconnect/auth/models/auth_session.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Stream<AuthSession?> observeAuthState() {
    return const Stream.empty();
  }

  @override
  Future<AuthSession> signIn({required String email, required String password}) async {
    if (email == 'student@horizon.edu' && password == 'password123') {
      return AuthSession(uid: '1', email: email);
    }
    throw FirebaseAuthException(code: 'user-not-found', message: 'User not found');
  }

  @override
  Future<AuthSession> signUp({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendVerificationEmail() {
    throw UnimplementedError();
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

void main() {
  testWidgets('LoginScreen blocks empty input', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LoginScreen(authRepository: MockAuthRepository()),
    ));

    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('LoginScreen shows error on invalid credentials', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LoginScreen(authRepository: MockAuthRepository()),
    ));

    await tester.enterText(find.byType(TextFormField).first, 'wrong@horizon.edu');
    await tester.enterText(find.byType(TextFormField).last, 'wrongpass');
    
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid email or password.'), findsOneWidget); 
  });

  testWidgets('LoginScreen exposes only email credential flow', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LoginScreen(authRepository: MockAuthRepository()),
    ));

    expect(find.text('Google'), findsNothing);
    expect(find.text('ACLC Student Number'), findsNothing);
  });
}
