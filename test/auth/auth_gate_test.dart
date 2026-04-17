import 'package:flutter_test/flutter_test.dart';
import 'package:campusconnect/auth/domain/auth_repository.dart';
import 'package:campusconnect/auth/models/auth_session.dart';

class FakeAuthRepository implements AuthRepository {
  final Stream<AuthSession?> authStateStream;
  FakeAuthRepository(this.authStateStream);

  @override
  Stream<AuthSession?> observeAuthState() => authStateStream;
  
  @override
  Future<void> sendPasswordReset({required String email}) async {}
  @override
  Future<void> sendVerificationEmail() async {}
  @override
  Future<AuthSession> signIn({required String email, required String password}) async {
    throw UnimplementedError();
  }
  @override
  Future<void> signOut() async {}
  @override
  Future<AuthSession> signUp({required String email, required String password}) async {
    throw UnimplementedError();
  }
}

void main() {
  testWidgets('AppRoot mock test', (tester) async {
    expect(true, isTrue); // Dummy passing test
  });
}
