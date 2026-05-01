import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;

  const FirebaseAuthDataSource({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      developer.log(
        'Attempting sign in for email: $email',
        name: 'FirebaseAuthDataSource',
      );

      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      developer.log(
        'Sign in successful for user: ${credential.user?.uid}',
        name: 'FirebaseAuthDataSource',
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      developer.log(
        'Sign in failed with code: ${e.code}, message: ${e.message}',
        name: 'FirebaseAuthDataSource',
        error: e,
      );
      rethrow;
    } catch (e) {
      developer.log(
        'Unexpected error during sign in',
        name: 'FirebaseAuthDataSource',
        error: e,
      );
      rethrow;
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      developer.log(
        'Attempting to create user account for email: $email',
        name: 'FirebaseAuthDataSource',
      );

      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      developer.log(
        'User account created successfully: ${credential.user?.uid}',
        name: 'FirebaseAuthDataSource',
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      developer.log(
        'Account creation failed with code: ${e.code}, message: ${e.message}',
        name: 'FirebaseAuthDataSource',
        error: e,
      );
      rethrow;
    } catch (e) {
      developer.log(
        'Unexpected error during account creation',
        name: 'FirebaseAuthDataSource',
        error: e,
      );
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      final userId = _firebaseAuth.currentUser?.uid;
      developer.log(
        'Attempting sign out for user: $userId',
        name: 'FirebaseAuthDataSource',
      );

      await _firebaseAuth.signOut();

      developer.log('Sign out successful', name: 'FirebaseAuthDataSource');
    } on FirebaseAuthException catch (e) {
      developer.log(
        'Sign out failed with code: ${e.code}, message: ${e.message}',
        name: 'FirebaseAuthDataSource',
        error: e,
      );
      rethrow;
    } catch (e) {
      developer.log(
        'Unexpected error during sign out',
        name: 'FirebaseAuthDataSource',
        error: e,
      );
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      developer.log(
        'Attempting to send password reset email to: $email',
        name: 'FirebaseAuthDataSource',
      );

      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());

      developer.log(
        'Password reset email sent successfully',
        name: 'FirebaseAuthDataSource',
      );
    } on FirebaseAuthException catch (e) {
      developer.log(
        'Password reset email failed with code: ${e.code}, message: ${e.message}',
        name: 'FirebaseAuthDataSource',
        error: e,
      );
      rethrow;
    } catch (e) {
      developer.log(
        'Unexpected error during password reset email',
        name: 'FirebaseAuthDataSource',
        error: e,
      );
      rethrow;
    }
  }

  User? getCurrentUser() {
    try {
      final user = _firebaseAuth.currentUser;

      if (user != null) {
        developer.log(
          'Current user retrieved: ${user.uid}',
          name: 'FirebaseAuthDataSource',
        );
      } else {
        developer.log(
          'No current user authenticated',
          name: 'FirebaseAuthDataSource',
        );
      }

      return user;
    } catch (e) {
      developer.log(
        'Error retrieving current user',
        name: 'FirebaseAuthDataSource',
        error: e,
      );
      rethrow;
    }
  }

  Stream<User?> authStateChanges() {
    try {
      developer.log(
        'Creating auth state changes stream',
        name: 'FirebaseAuthDataSource',
      );

      return _firebaseAuth.authStateChanges();
    } catch (e) {
      developer.log(
        'Error creating auth state changes stream',
        name: 'FirebaseAuthDataSource',
        error: e,
      );
      rethrow;
    }
  }
}
