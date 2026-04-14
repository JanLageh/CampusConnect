import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campusconnect/app/auth_gate.dart';
import 'package:campusconnect/auth/application/auth_session_controller.dart';
import 'package:campusconnect/auth/domain/auth_repository.dart';
import 'package:campusconnect/auth/models/auth_session.dart';
import 'package:campusconnect/login_screen.dart';
import 'package:campusconnect/app/protected_module_router.dart';
import 'package:campusconnect/auth/presentation/verify_email_screen.dart';
import 'dart:async';

class FakeAuthRepository implements AuthRepository {
  final StreamController<AuthSession?> _controller =
      StreamController<AuthSession?>.broadcast();

  void emit(AuthSession? session) {
    _controller.add(session);
  }

  @override
  Stream<AuthSession?> observeAuthState() => _controller.stream;

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
  late FakeAuthRepository authRepository;
  late AuthSessionController sessionController;

  setUp(() {
    authRepository = FakeAuthRepository();
    sessionController = AuthSessionController(authRepository: authRepository);
  });

  Widget buildTestApp() {
    return MaterialApp(
      home: AuthGate(
        authRepository: authRepository,
        authSessionController: sessionController,
      ),
    );
  }

  testWidgets('redirects to LoginScreen when unauthenticated', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    authRepository.emit(null);
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(ProtectedModuleRouter), findsNothing);
  });

  testWidgets('redirects to VerifyEmailScreen when unverified', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    authRepository.emit(
      const AuthSession(
        uid: '123',
        email: 'test@horizon.edu',
        isEmailVerified: false,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(VerifyEmailScreen), findsOneWidget);
    expect(find.byType(ProtectedModuleRouter), findsNothing);
  });

  testWidgets('redirects to ProtectedModuleRouter when verified', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    authRepository.emit(
      const AuthSession(
        uid: '123',
        email: 'test@horizon.edu',
        isEmailVerified: true,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProtectedModuleRouter), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets(
    'ProtectedModuleRouter enforces hard redirect when bypassed with null session',
    (WidgetTester tester) async {
      final fakeRepo = FakeAuthRepository();

      await tester.pumpWidget(
        MaterialApp(
          // Notice we are NOT using AuthGate here to simulate a bypass deep link
          home: ProtectedModuleRouter(authRepository: fakeRepo),
        ),
      );

      fakeRepo.emit(null);
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    },
  );

  testWidgets('ProtectedModuleRouter blocks access when unverified', (
    WidgetTester tester,
  ) async {
    final fakeRepo = FakeAuthRepository();

    await tester.pumpWidget(
      MaterialApp(home: ProtectedModuleRouter(authRepository: fakeRepo)),
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
  });
}
