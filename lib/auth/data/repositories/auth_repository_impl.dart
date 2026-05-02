import '../../../core/utils/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/exceptions/auth_exception.dart';
import '../../domain/exceptions/network_exception.dart';
import '../../domain/exceptions/service_exception.dart';
import '../../domain/exceptions/validation_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/firebase_auth_data_source.dart';

/// Implementation of [AuthRepository] using Firebase Authentication.
///
/// This repository coordinates between Firebase Authentication and user metadata
/// storage, providing a complete authentication solution. It handles:
/// - User sign-in with metadata loading
/// - User registration (auth account creation only)
/// - Password reset
/// - Sign out
/// - Current user retrieval with metadata
/// - Authentication state change streams
///
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _authDataSource;
  final UserRepository _userRepository;

  const AuthRepositoryImpl({
    required FirebaseAuthDataSource authDataSource,
    required UserRepository userRepository,
  }) : _authDataSource = authDataSource,
       _userRepository = userRepository;

  /// Signs in a user with email and password, then loads their metadata.
  ///
  /// Process:
  /// 1. Calls Firebase Auth to authenticate credentials
  /// 2. Loads user metadata from Firestore
  /// 3. Returns complete UserEntity
  ///
  /// Throws:
  /// - [AuthException] for invalid credentials or authentication failures
  /// - [NetworkException] for network connectivity issues
  /// - [ServiceException] for Firebase service unavailability
  ///
  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.debug(
        'AuthRepository: Attempting sign in for email: $email',
      );

      final credential = await _authDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException('Sign in failed: No user returned');
      }

      final userId = credential.user!.uid;

      AppLogger.debug(
        'AuthRepository: Authentication successful, loading metadata for userId: $userId',
      );

      final userEntity = await _userRepository.getUserMetadata(userId: userId);

      if (userEntity == null) {
        AppLogger.debug(
          'AuthRepository: User metadata not found for userId: $userId',
        );
        throw const AuthException(
          'User data not found. Please contact support.',
        );
      }

      AppLogger.debug(
        'AuthRepository: Sign in complete for userId: $userId',
      );

      return userEntity;
    } on FirebaseAuthException catch (e) {
      AppLogger.debug(
        'AuthRepository: Firebase auth error during sign in: ${e.code}',
        error: e,
      );
      throw _mapFirebaseAuthException(e);
    } on AuthException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on ServiceException {
      rethrow;
    } catch (e) {
      AppLogger.debug(
        'AuthRepository: Unexpected error during sign in',
        error: e,
      );
      throw AuthException('Sign in failed: ${e.toString()}');
    }
  }

  /// Registers a new user with email and password.
  ///
  /// This method only creates the Firebase Authentication account.
  /// User metadata creation is handled by the application service to maintain
  /// proper separation of concerns.
  ///
  /// Returns the userId of the newly created account.
  ///
  /// Throws:
  /// - [AuthException] for registration failures (e.g., email already exists)
  /// - [ValidationException] for invalid email or weak password
  /// - [NetworkException] for network connectivity issues
  /// - [ServiceException] for Firebase service unavailability
  @override
  Future<String> register({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.debug(
        'AuthRepository: Attempting registration for email: $email',
      );

      final credential = await _authDataSource.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException('Registration failed: No user returned');
      }

      final userId = credential.user!.uid;

      AppLogger.debug(
        'AuthRepository: Registration successful, userId: $userId',
      );

      return userId;
    } on FirebaseAuthException catch (e) {
      AppLogger.debug(
        'AuthRepository: Firebase auth error during registration: ${e.code}',
        error: e,
      );
      throw _mapFirebaseAuthException(e);
    } on AuthException {
      rethrow;
    } on ValidationException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on ServiceException {
      rethrow;
    } catch (e) {
      AppLogger.debug(
        'AuthRepository: Unexpected error during registration',
        error: e,
      );
      throw AuthException('Registration failed: ${e.toString()}');
    }
  }

  /// Signs out the current user.
  ///
  /// Clears the Firebase Authentication session. The caller is responsible
  /// for clearing any cached user data in the presentation layer.
  ///
  /// Throws:
  /// - [AuthException] if sign out fails
  @override
  Future<void> signOut() async {
    try {
      AppLogger.debug(
        'AuthRepository: Attempting sign out',
      );

      await _authDataSource.signOut();

      AppLogger.debug(
        'AuthRepository: Sign out successful',
      );
    } on FirebaseAuthException catch (e) {
      AppLogger.debug(
        'AuthRepository: Firebase auth error during sign out: ${e.code}',
        error: e,
      );
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      AppLogger.debug(
        'AuthRepository: Unexpected error during sign out',
        error: e,
      );
      throw AuthException('Sign out failed: ${e.toString()}');
    }
  }

  /// Sends a password reset email to the specified email address.
  ///
  /// This method completes silently regardless of whether the email exists
  /// in the system. This is a security best practice to prevent email
  /// enumeration attacks.
  ///
  /// Throws:
  /// - [AuthException] if the operation fails
  /// - [NetworkException] for network connectivity issues
  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      AppLogger.debug(
        'AuthRepository: Sending password reset email to: $email',
      );

      await _authDataSource.sendPasswordResetEmail(email: email);

      AppLogger.debug(
        'AuthRepository: Password reset email sent successfully',
      );
    } on FirebaseAuthException catch (e) {
      AppLogger.debug(
        'AuthRepository: Firebase auth error sending password reset: ${e.code}',
        error: e,
      );
      throw _mapFirebaseAuthException(e);
    } on NetworkException {
      rethrow;
    } catch (e) {
      AppLogger.debug(
        'AuthRepository: Unexpected error sending password reset email',
        error: e,
      );
      throw AuthException(
        'Failed to send password reset email: ${e.toString()}',
      );
    }
  }

  /// Gets the currently authenticated user with their metadata.
  ///
  /// Returns null if no user is authenticated or if metadata cannot be loaded.
  ///
  /// Process:
  /// 1. Checks Firebase Auth for current user
  /// 2. If user exists, loads metadata from Firestore
  /// 3. Returns complete UserEntity or null
  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      AppLogger.debug(
        'AuthRepository: Getting current user',
      );

      final firebaseUser = _authDataSource.getCurrentUser();

      if (firebaseUser == null) {
        AppLogger.debug(
          'AuthRepository: No user currently authenticated',
        );
        return null;
      }

      final userId = firebaseUser.uid;

      AppLogger.debug(
        'AuthRepository: Current user found, loading metadata for userId: $userId',
      );

      // Load user metadata
      final userEntity = await _userRepository.getUserMetadata(userId: userId);

      if (userEntity == null) {
        AppLogger.debug(
          'AuthRepository: User metadata not found for userId: $userId',
        );
        return null;
      }

      AppLogger.debug(
        'AuthRepository: Current user retrieved successfully',
      );

      return userEntity;
    } catch (e) {
      AppLogger.debug(
        'AuthRepository: Error getting current user',
        error: e,
      );
      // Return null instead of throwing to allow graceful handling
      return null;
    }
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    try {
      AppLogger.debug(
        'AuthRepository: Creating auth state changes stream',
      );

      return _authDataSource.authStateChanges().asyncMap((firebaseUser) async {
        if (firebaseUser == null) {
          AppLogger.debug(
            'AuthRepository: Auth state changed to unauthenticated',
          );
          return null;
        }

        final userId = firebaseUser.uid;

        AppLogger.debug(
          'AuthRepository: Auth state changed to authenticated, loading metadata for userId: $userId',
        );

        try {
          final userEntity = await _userRepository.getUserMetadata(
            userId: userId,
          );

          if (userEntity == null) {
            AppLogger.debug(
              'AuthRepository: User metadata not found for userId: $userId in auth state stream',
            );
          }

          return userEntity;
        } catch (e) {
          AppLogger.debug(
            'AuthRepository: Error loading metadata in auth state stream',
            error: e,
          );
          // Return null to indicate authentication state is invalid
          return null;
        }
      });
    } catch (e) {
      AppLogger.debug(
        'AuthRepository: Error creating auth state changes stream',
        error: e,
      );
      rethrow;
    }
  }

  /// Maps Firebase Authentication exceptions to domain exceptions.
  Exception _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
        return const AuthException(
          'Invalid email or password.',
          code: 'invalid-credentials',
        );

      case 'invalid-email':
        return const ValidationException(
          'Please enter a valid email address.',
          'email',
        );

      case 'user-disabled':
        return const AuthException(
          'This account has been disabled. Please contact support.',
          code: 'user-disabled',
        );

      case 'email-already-in-use':
        return const AuthException(
          'This email is already registered. Please sign in instead.',
          code: 'email-already-in-use',
        );

      case 'weak-password':
        return const ValidationException(
          'Password must be at least 6 characters long.',
          'password',
        );

      case 'too-many-requests':
        return const AuthException(
          'Too many failed attempts. Please try again later.',
          code: 'too-many-requests',
        );

      case 'network-request-failed':
        return const NetworkException(
          'Network error. Please check your connection.',
        );

      case 'operation-not-allowed':
        return const ServiceException(
          'This operation is not allowed. Please contact support.',
        );

      case 'internal-error':
        return const ServiceException(
          'An internal error occurred. Please try again.',
        );

      case 'invalid-credential':
        return const AuthException(
          'Invalid credentials provided.',
          code: 'invalid-credential',
        );

      case 'user-token-expired':
      case 'requires-recent-login':
        return const AuthException(
          'Your session has expired. Please sign in again.',
          code: 'session-expired',
        );

      default:
        AppLogger.debug(
          'Unmapped Firebase auth error code: ${e.code}',
        );
        return AuthException(
          'An unexpected error occurred. Please try again.',
          code: e.code,
        );
    }
  }
}
