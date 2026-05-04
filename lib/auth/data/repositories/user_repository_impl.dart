import '../../../core/utils/app_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/exceptions/user_exception.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/firestore_user_data_source.dart';
import '../models/user_model.dart';

/// Implementation of [UserRepository] using Cloud Firestore.
///
/// This repository manages user metadata stored in Firestore, providing
/// operations for creating, reading, and updating user documents. It handles:
/// - User metadata creation during registration
/// - User metadata retrieval for authenticated users
/// - User metadata updates (profile changes, group memberships)
///
/// All Firestore exceptions are mapped to domain-specific UserExceptions
/// with user-friendly error messages.
///
/// Requirements: 1.5, 2.5, 7.1, 7.2, 7.3, 7.4, 7.5, 10.3
class UserRepositoryImpl implements UserRepository {
  final FirestoreUserDataSource _dataSource;

  const UserRepositoryImpl({required FirestoreUserDataSource dataSource})
    : _dataSource = dataSource;

  /// Creates user metadata in Firestore during registration.
  ///
  /// This method is called after Firebase Authentication account creation
  /// to store additional user information in Firestore. The document is
  /// created at users/{userId} with the following fields:
  /// - fullName: User's full name
  /// - email: User's email address
  /// - studentId: Student identification number
  /// - role: User role (defaults to 'student')
  /// - groupMemberships: List of group IDs (defaults to empty list)
  /// - createdAt: Document creation timestamp
  /// - updatedAt: Document last update timestamp
  ///
  /// Throws:
  /// - [UserException] if document creation fails
  /// - [UserException] if user already exists
  /// - [UserException] if permission is denied
  ///
  /// Requirements: 1.5, 7.1, 7.2, 7.4
  @override
  Future<void> createUserMetadata({
    required String userId,
    required String fullName,
    required String email,
    required String studentId,
  }) async {
    try {
      AppLogger.debug(
        'UserRepository: Creating metadata for userId: $userId',
      );

      await _dataSource.createUser(
        userId: userId,
        fullName: fullName,
        email: email,
        studentId: studentId,
      );

      AppLogger.debug(
        'UserRepository: Metadata created successfully for userId: $userId',
      );
    } on UserException {
      rethrow;
    } on FirebaseException catch (e) {
      AppLogger.debug(
        'UserRepository: Firestore error creating metadata: ${e.code}',
        error: e,
      );
      throw _mapFirestoreException(e, 'create user metadata');
    } catch (e) {
      AppLogger.debug(
        'UserRepository: Unexpected error creating metadata',
        error: e,
      );
      throw UserException('Failed to create user metadata: ${e.toString()}');
    }
  }

  /// Retrieves user metadata from Firestore.
  ///
  /// This method is called during sign-in and session restoration to load
  /// complete user information. It converts the Firestore document to a
  /// domain UserEntity.
  ///
  /// Returns null if the user document doesn't exist. This is not considered
  /// an error condition - the caller should handle missing metadata appropriately
  /// (e.g., by prompting profile completion or re-authentication).
  ///
  /// Throws:
  /// - [UserException] if Firestore read fails
  /// - [UserException] if permission is denied
  /// - [UserException] if document data is malformed
  ///
  /// Requirements: 2.5, 7.3, 7.5
  @override
  Future<UserEntity?> getUserMetadata({required String userId}) async {
    try {
      AppLogger.debug(
        'UserRepository: Fetching metadata for userId: $userId',
      );

      final docSnapshot = await _dataSource.getUser(userId: userId);

      if (docSnapshot == null) {
        AppLogger.debug(
          'UserRepository: No metadata found for userId: $userId',
        );
        return null;
      }

      final userModel = UserModel.fromFirestore(docSnapshot);
      final userEntity = userModel.toEntity();

      AppLogger.debug(
        'UserRepository: Metadata retrieved successfully for userId: $userId',
      );

      return userEntity;
    } on UserException {
      rethrow;
    } on FirebaseException catch (e) {
      AppLogger.debug(
        'UserRepository: Firestore error fetching metadata: ${e.code}',
        error: e,
      );
      throw _mapFirestoreException(e, 'fetch user metadata');
    } on FormatException catch (e) {
      AppLogger.debug(
        'UserRepository: Document format error for userId: $userId',
        error: e,
      );
      throw UserException(
        'User data is malformed. Please contact support.',
        code: 'invalid-data',
      );
    } catch (e) {
      AppLogger.debug(
        'UserRepository: Unexpected error fetching metadata',
        error: e,
      );
      throw UserException('Failed to fetch user metadata: ${e.toString()}');
    }
  }

  /// Updates user metadata in Firestore.
  ///
  /// This method allows updating specific fields in the user document without
  /// replacing the entire document. Common use cases include:
  /// - Updating profile information (fullName, studentId)
  /// - Managing group memberships
  /// - Updating role assignments
  ///
  /// The updatedAt timestamp is automatically set by the data source.
  ///
  /// Example:
  /// ```dart
  /// await updateUserMetadata(
  ///   userId: 'user123',
  ///   updates: {
  ///     'fullName': 'New Name',
  ///     'groupMemberships': ['group1', 'group2'],
  ///   },
  /// );
  /// ```
  ///
  /// Throws:
  /// - [UserException] if the document doesn't exist
  /// - [UserException] if Firestore update fails
  /// - [UserException] if permission is denied
  ///
  /// Requirements: 7.3, 7.5, 10.3
  @override
  Future<void> updateUserMetadata({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      AppLogger.debug(
        'UserRepository: Updating metadata for userId: $userId with fields: ${updates.keys.join(", ")}',
      );

      _validateUpdates(updates);

      await _dataSource.updateUser(userId: userId, updates: updates);

      AppLogger.debug(
        'UserRepository: Metadata updated successfully for userId: $userId',
      );
    } on UserException {
      rethrow;
    } on FirebaseException catch (e) {
      AppLogger.debug(
        'UserRepository: Firestore error updating metadata: ${e.code}',
        error: e,
      );
      throw _mapFirestoreException(e, 'update user metadata');
    } catch (e) {
      AppLogger.debug(
        'UserRepository: Unexpected error updating metadata',
        error: e,
      );
      throw UserException('Failed to update user metadata: ${e.toString()}');
    }
  }

  /// Validates update fields to prevent modification of protected fields.
  ///
  /// Protected fields that should not be updated directly:
  /// - userId: Immutable identifier
  /// - createdAt: Should never change after creation
  ///
  /// Throws [UserException] if protected fields are present in updates.
  void _validateUpdates(Map<String, dynamic> updates) {
    const protectedFields = ['userId', 'createdAt'];

    for (final field in protectedFields) {
      if (updates.containsKey(field)) {
        throw UserException(
          'Cannot update protected field: $field',
          code: 'invalid-update',
        );
      }
    }
  }

  /// Maps Firestore exceptions to domain-specific UserExceptions.
  ///
  /// This provides consistent error handling across all Firestore operations
  /// and translates Firebase error codes into user-friendly messages that
  /// match the design document specifications.
  ///
  /// Requirements: 7.5, 10.3
  UserException _mapFirestoreException(FirebaseException e, String operation) {
    switch (e.code) {
      case 'permission-denied':
        return UserException(
          'Access denied. Please sign in again.',
          code: e.code,
        );

      case 'not-found':
        return UserException('User data not found.', code: e.code);

      case 'unavailable':
        return UserException(
          'Service temporarily unavailable. Please try again.',
          code: e.code,
        );

      case 'deadline-exceeded':
        return UserException(
          'Request timed out. Please check your connection.',
          code: e.code,
        );

      case 'already-exists':
        return UserException('User already exists.', code: e.code);

      case 'resource-exhausted':
        return UserException(
          'Too many requests. Please try again later.',
          code: e.code,
        );

      case 'cancelled':
        return UserException('Operation was cancelled.', code: e.code);

      case 'data-loss':
      case 'internal':
        return UserException(
          'Internal error occurred. Please try again.',
          code: e.code,
        );

      case 'invalid-argument':
        return UserException('Invalid data provided.', code: e.code);

      case 'failed-precondition':
        return UserException(
          'Operation cannot be performed in current state.',
          code: e.code,
        );

      case 'aborted':
        return UserException(
          'Operation was aborted. Please try again.',
          code: e.code,
        );

      case 'out-of-range':
        return UserException('Invalid data range.', code: e.code);

      case 'unimplemented':
        return UserException('This operation is not supported.', code: e.code);

      default:
        AppLogger.debug(
          'Unmapped Firestore error code: ${e.code}',
        );
        return UserException(
          'Failed to $operation: ${e.message ?? "Unknown error"}',
          code: e.code,
        );
    }
  }
}
