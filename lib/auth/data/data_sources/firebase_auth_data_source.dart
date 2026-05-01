import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;

  const FirebaseAuthDataSource({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError(
      'FirebaseAuthDataSource.signInWithEmailAndPassword() not yet implemented',
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError(
      'FirebaseAuthDataSource.createUserWithEmailAndPassword() not yet implemented',
    );
  }

  Future<void> signOut() async {
    throw UnimplementedError(
      'FirebaseAuthDataSource.signOut() not yet implemented',
    );
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    throw UnimplementedError(
      'FirebaseAuthDataSource.sendPasswordResetEmail() not yet implemented',
    );
  }

  User? getCurrentUser() {
    throw UnimplementedError(
      'FirebaseAuthDataSource.getCurrentUser() not yet implemented',
    );
  }

  Stream<User?> authStateChanges() {
    throw UnimplementedError(
      'FirebaseAuthDataSource.authStateChanges() not yet implemented',
    );
  }
}
