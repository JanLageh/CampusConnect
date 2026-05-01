import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

// Data Sources
import '../auth/data/data_sources/firebase_auth_data_source.dart';
import '../auth/data/data_sources/firestore_user_data_source.dart';

// Repositories
import '../auth/domain/repositories/auth_repository.dart';
import '../auth/domain/repositories/user_repository.dart';
import '../auth/data/repositories/auth_repository_impl.dart';
import '../auth/data/repositories/user_repository_impl.dart';

// Use Cases
import '../auth/domain/use_cases/sign_in_use_case.dart';
import '../auth/domain/use_cases/register_use_case.dart';
import '../auth/domain/use_cases/sign_out_use_case.dart';
import '../auth/domain/use_cases/reset_password_use_case.dart';
import '../auth/domain/use_cases/get_current_user_use_case.dart';
import '../auth/domain/use_cases/update_user_profile_use_case.dart';

// Entities
import '../auth/domain/entities/user_entity.dart';

// Auth State
import '../auth/presentation/providers/auth_state_provider.dart';

// ============================================================================
// Firebase Instances
// ============================================================================

/// Provider for FirebaseAuth instance
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Provider for FirebaseFirestore instance
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// ============================================================================
// Data Sources
// ============================================================================

/// Provider for FirebaseAuthDataSource
final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthDataSource(firebaseAuth: firebaseAuth);
});

/// Provider for FirestoreUserDataSource
final firestoreUserDataSourceProvider = Provider<FirestoreUserDataSource>((
  ref,
) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return FirestoreUserDataSource(firestore: firestore);
});

// ============================================================================
// Repositories
// ============================================================================

/// Provider for UserRepository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dataSource = ref.watch(firestoreUserDataSourceProvider);
  return UserRepositoryImpl(dataSource: dataSource);
});

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authDataSource = ref.watch(firebaseAuthDataSourceProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  return AuthRepositoryImpl(
    authDataSource: authDataSource,
    userRepository: userRepository,
  );
});

// ============================================================================
// Use Cases
// ============================================================================

/// Provider for SignInUseCase
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignInUseCase(authRepository: authRepository);
});

/// Provider for RegisterUseCase
final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  return RegisterUseCase(
    authRepository: authRepository,
    userRepository: userRepository,
  );
});

/// Provider for SignOutUseCase
final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(authRepository: authRepository);
});

/// Provider for ResetPasswordUseCase
final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return ResetPasswordUseCase(authRepository: authRepository);
});

/// Provider for GetCurrentUserUseCase
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(authRepository: authRepository);
});

/// Provider for UpdateUserProfileUseCase
final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>((
  ref,
) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UpdateUserProfileUseCase(userRepository: userRepository);
});

// ============================================================================
// Auth State Management
// ============================================================================

/// Provider for AuthStateNotifier
/// This manages the global authentication state and listens to auth changes
final authStateNotifierProvider =
    NotifierProvider<AuthStateNotifier, AuthState>(AuthStateNotifier.new);

/// Convenience provider to get current user
final currentUserProvider = Provider<UserEntity?>((ref) {
  return ref.watch(authStateNotifierProvider).user;
});

/// Convenience provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateNotifierProvider).isAuthenticated;
});

/// Convenience provider to check if user is unauthenticated
final isUnauthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateNotifierProvider).isUnauthenticated;
});

/// Convenience provider to check if auth state is loading
final isAuthLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authStateNotifierProvider).isLoading;
});

/// Notifier for managing authentication state
class AuthStateNotifier extends Notifier<AuthState> {
  late AuthRepository _authRepository;
  StreamSubscription<UserEntity?>? _authStateSubscription;

  @override
  AuthState build() {
    // Get the auth repository from the providers
    _authRepository = ref.watch(authRepositoryProvider);

    // Initialize authentication state
    _initialize();

    ref.onDispose(() {
      _authStateSubscription?.cancel();
    });

    // Return initial loading state
    return const AuthState(isLoading: true);
  }

  /// Initialize authentication state and listen to changes
  Future<void> _initialize() async {
    try {
      // Check for existing session on app start
      final currentUser = await _authRepository.getCurrentUser();

      state = AuthState(user: currentUser, isLoading: false);

      // Listen to authentication state changes
      _authStateSubscription = _authRepository.authStateChanges().listen(
        (user) {
          state = AuthState(user: user, isLoading: false);
        },
        onError: (error) {
          state = AuthState(
            user: null,
            isLoading: false,
            error: error.toString(),
          );
        },
      );
    } catch (e) {
      state = AuthState(
        user: null,
        isLoading: false,
        error: 'Failed to restore session: ${e.toString()}',
      );
    }
  }

  /// Get current user entity
  UserEntity? get currentUser => state.user;

  /// Check if user is authenticated
  bool get isAuthenticated => state.isAuthenticated;

  /// Check if user is unauthenticated
  bool get isUnauthenticated => state.isUnauthenticated;

  /// Manually refresh authentication state
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final currentUser = await _authRepository.getCurrentUser();
      state = AuthState(user: currentUser, isLoading: false);
    } catch (e) {
      state = AuthState(
        user: null,
        isLoading: false,
        error: 'Failed to refresh session: ${e.toString()}',
      );
    }
  }

  /// Clear any error state
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
