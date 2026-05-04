import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/exceptions/user_exception.dart';
import '../../../core/utils/app_logger.dart';

class FirestoreUserDataSource {
  final FirebaseFirestore _firestore;

  static const String _usersCollection = 'users';

  const FirestoreUserDataSource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  Future<void> createUser({
    required String userId,
    required String fullName,
    required String email,
    required String studentId,
  }) async {
    try {
      AppLogger.debug('Creating user document for userId: $userId');

      final now = FieldValue.serverTimestamp();
      final userData = {
        'fullName': fullName,
        'email': email,
        'studentId': studentId,
        'role': 'student',
        'groupMemberships': [],
        'createdAt': now,
        'updatedAt': now,
      };

      await _firestore.collection(_usersCollection).doc(userId).set(userData);

      AppLogger.info('Successfully created user document for userId: $userId');
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error creating user: ${e.code}', error: e);

      throw _mapFirestoreException(e, 'create user');
    } catch (e) {
      AppLogger.error('Unexpected error creating user', error: e);

      throw UserException('Failed to create user: ${e.toString()}');
    }
  }

  Future<DocumentSnapshot?> getUser({required String userId}) async {
    try {
      AppLogger.debug('Fetching user document for userId: $userId');

      final docSnapshot = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();

      if (!docSnapshot.exists) {
        AppLogger.debug('User document not found for userId: $userId');
        return null;
      }

      AppLogger.debug('Successfully fetched user document for userId: $userId');

      return docSnapshot;
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error fetching user: ${e.code}', error: e);

      throw _mapFirestoreException(e, 'fetch user');
    } catch (e) {
      AppLogger.error('Unexpected error fetching user', error: e);

      throw UserException('Failed to fetch user: ${e.toString()}');
    }
  }

  Future<void> updateUser({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      AppLogger.debug(
        'Updating user document for userId: $userId with fields: ${updates.keys.join(", ")}',
      );

      final updatesWithTimestamp = {
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .update(updatesWithTimestamp);

      AppLogger.info('Successfully updated user document for userId: $userId');
    } on FirebaseException catch (e) {
      AppLogger.error('Firestore error updating user: ${e.code}', error: e);

      throw _mapFirestoreException(e, 'update user');
    } catch (e) {
      AppLogger.error('Unexpected error updating user', error: e);

      throw UserException('Failed to update user: ${e.toString()}');
    }
  }

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
      default:
        return UserException(
          'Failed to $operation: ${e.message ?? "Unknown error"}',
          code: e.code,
        );
    }
  }
}
