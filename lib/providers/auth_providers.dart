import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/data/firebase_auth_repository.dart';
import '../auth/domain/auth_repository.dart';
import '../auth/data/firestore_user_profile_repository.dart';
import '../auth/domain/user_profile_repository.dart';
import '../auth/models/auth_session.dart';

/// Provider for the AuthRepository
/// This is a singleton that provides access to authentication operations
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

/// Provider for the UserProfileRepository
/// This is a singleton that provides access to user profile operations
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return FirestoreUserProfileRepository();
});

/// Provider that streams the current auth state
/// Returns null when user is signed out, AuthSession when signed in
final authStateProvider = StreamProvider<AuthSession?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.observeAuthState();
});

/// Provider that returns the current auth session synchronously
/// Useful for widgets that need immediate access to user state
final currentAuthSessionProvider = Provider<AuthSession?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (session) => session,
    loading: () => null,
    error: (error, stackTrace) => null,
  );
});
