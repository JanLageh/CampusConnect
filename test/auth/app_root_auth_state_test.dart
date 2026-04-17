import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campusconnect/auth/domain/auth_repository.dart';
import 'package:campusconnect/auth/models/auth_session.dart';
import 'package:campusconnect/app/app_root.dart';
import 'package:campusconnect/login_screen.dart';
import 'package:campusconnect/auth/presentation/verify_email_screen.dart';
import 'dart:async';

class FakeAuthRepository implements AuthRepository {
  final StreamController<AuthSession?> _controller =
      StreamController<AuthSession?>.broadcast();
  AuthSession? _currentSession;

  void emit(AuthSession? session) {
    _currentSession = session;
    _controller.add(session);
  }

  @override
  Stream<AuthSession?> observeAuthState() async* {
    yield _currentSession;
    yield* _controller.stream;
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<AuthSession> signUp({
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<void> sendVerificationEmail() => throw UnimplementedError();

  @override
  Future<void> sendPasswordReset({required String email}) =>
      throw UnimplementedError();

  @override
  Future<void> signOut() => throw UnimplementedError();
}

void main() {
  testWidgets(
    'AppRoot startup resolves initial route from live auth stream to LoginScreen',
    (WidgetTester tester) async {
      final fakeRepo = FakeAuthRepository();

      await tester.pumpWidget(
        MaterialApp(home: AppRoot(authRepository: fakeRepo)),
      );

      fakeRepo.emit(null);
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(VerifyEmailScreen), findsNothing);
    },
  );

  testWidgets(
    'AppRoot startup resolves initial route from live auth stream to VerifyEmailScreen',
    (WidgetTester tester) async {
      final fakeRepo = FakeAuthRepository();

      await tester.pumpWidget(
        MaterialApp(home: AppRoot(authRepository: fakeRepo)),
      );

      fakeRepo.emit(
        const AuthSession(
          uid: '123',
          email: 'test@horizon.edu',
          isEmailVerified: false,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(VerifyEmailScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    },
  );
}
