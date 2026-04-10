import 'package:flutter_test/flutter_test.dart';
import 'package:campusconnect/auth/application/auth_session_controller.dart';
import 'package:campusconnect/auth/domain/auth_repository.dart';
import 'package:campusconnect/auth/models/auth_session.dart';
import 'dart:async';

class FakeAuthRepository2 implements AuthRepository {
  bool signOutCalled = false;
  Stream<AuthSession?> get sessionStream => const Stream.empty();

  @override
  Stream<AuthSession?> observeAuthState() => sessionStream;

  @override
  Future<AuthSession> signIn({required String email, required String password}) => throw UnimplementedError();

  @override
  Future<AuthSession> signUp({required String email, required String password}) => throw UnimplementedError();

  @override
  Future<void> sendVerificationEmail() => throw UnimplementedError();

  @override
  Future<void> sendPasswordReset({required String email}) => throw UnimplementedError();

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }
}

void main() {
  test('signOut calls registered cleanup hooks and repository signOut', () async {
    final fakeRepo = FakeAuthRepository2();
    final controller = AuthSessionController(authRepository: fakeRepo);

    bool hook1Called = false;
    bool hook2Called = false;

    controller.registerCleanupHook(() {
      hook1Called = true;
    });

    controller.registerCleanupHook(() {
      hook2Called = true;
    });

    await controller.signOut();

    expect(hook1Called, isTrue);
    expect(hook2Called, isTrue);
    expect(fakeRepo.signOutCalled, isTrue);
  });

  test('signOut continues even if a registered hook throws an error', () async {
    final fakeRepo = FakeAuthRepository2();
    final controller = AuthSessionController(authRepository: fakeRepo);

    bool hook2Called = false;

    controller.registerCleanupHook(() {
      throw Exception('Hook 1 failed');
    });

    controller.registerCleanupHook(() {
      hook2Called = true;
    });

    await controller.signOut();

    // Hook 2 and repo sign_out should still execute
    expect(hook2Called, isTrue);
    expect(fakeRepo.signOutCalled, isTrue);
  });
}
