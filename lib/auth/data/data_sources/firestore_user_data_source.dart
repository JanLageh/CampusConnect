import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/exceptions/user_exception.dart';

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
      developer.log(
        'Creating user document for userId: $userId',
        name: 'FirestoreUserDataSource',
      );

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

      developer.log(
        'Successfully created user document for userId: $userId',
        name: 'FirestoreUserDataSource',
      );
    } on FirebaseException catch (e) {
      developer.log(
        'Firestore error creating user: ${e.code} - ${e.message}',
        name: 'FirestoreUserDataSource',
        error: e,
      );

      throw _mapFirestoreException(e, 'create user');
    } catch (e) {
      developer.log(
        'Unexpected error creating user: $e',
        name: 'FirestoreUserDataSource',
        error: e,
      );

      throw UserException('Failed to create user: ${e.toString()}');
    }
  }

  Future<DocumentSnapshot?> getUser({required String userId}) async {
    try {
      developer.log(
        'Fetching user document for userId: $userId',
        name: 'FirestoreUserDataSource',
      );

      final docSnapshot = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();

      if (!docSnapshot.exists) {
        developer.log(
          'User document not found for userId: $userId',
          name: 'FirestoreUserDataSource',
        );
        return null;
      }

      developer.log(
        'Successfully fetched user document for userId: $userId',
        name: 'FirestoreUserDataSource',
      );

      return docSnapshot;
    } on FirebaseException catch (e) {
      developer.log(
        'Firestore error fetching user: ${e.code} - ${e.message}',
        name: 'FirestoreUserDataSource',
        error: e,
      );

      throw _mapFirestoreException(e, 'fetch user');
    } catch (e) {
      developer.log(
        'Unexpected error fetching user: $e',
        name: 'FirestoreUserDataSource',
        error: e,
      );

      throw UserException('Failed to fetch user: ${e.toString()}');
    }
  }

  Future<void> updateUser({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      developer.log(
        'Updating user document for userId: $userId with fields: ${updates.keys.join(", ")}',
        name: 'FirestoreUserDataSource',
      );

      final updatesWithTimestamp = {
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .update(updatesWithTimestamp);

      developer.log(
        'Successfully updated user document for userId: $userId',
        name: 'FirestoreUserDataSource',
      );
    } on FirebaseException catch (e) {
      developer.log(
        'Firestore error updating user: ${e.code} - ${e.message}',
        name: 'FirestoreUserDataSource',
        error: e,
      );

      throw _mapFirestoreException(e, 'update user');
    } catch (e) {
      developer.log(
        'Unexpected error updating user: $e',
        name: 'FirestoreUserDataSource',
        error: e,
      );

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
