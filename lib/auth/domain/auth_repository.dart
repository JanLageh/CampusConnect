import '../models/auth_session.dart';

abstract class AuthRepository {
  Stream<AuthSession?> observeAuthState();
  Future<AuthSession> signIn({required String email, required String password});
  Future<AuthSession> signUp({required String email, required String password});
  Future<void> sendVerificationEmail();
  Future<void> sendPasswordReset({required String email});
  Future<void> signOut();
}
