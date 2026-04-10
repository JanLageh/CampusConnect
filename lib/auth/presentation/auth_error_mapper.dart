import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorMapper {
  static String getFriendlyMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Invalid email or password.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'too-many-requests':
          return 'Too many failed attempts. Please try again later.';
        case 'email-already-in-use':
          return 'An account already exists for that email.';
        case 'invalid-email':
          return 'The email address is badly formatted.';
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'network-request-failed':
          return 'Network error. Please check your connection.';
        default:
          return 'An authentication error occurred. Please try again.';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }
}