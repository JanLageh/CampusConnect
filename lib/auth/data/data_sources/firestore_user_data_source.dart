import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUserDataSource {
  final FirebaseFirestore _firestore;

  const FirestoreUserDataSource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  Future<void> createUser({
    required String userId,
    required String fullName,
    required String email,
    required String studentId,
  }) async {
    throw UnimplementedError(
      'FirestoreUserDataSource.createUser() not yet implemented',
    );
  }

  Future<DocumentSnapshot?> getUser({required String userId}) async {
    throw UnimplementedError(
      'FirestoreUserDataSource.getUser() not yet implemented',
    );
  }

  Future<void> updateUser({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    throw UnimplementedError(
      'FirestoreUserDataSource.updateUser() not yet implemented',
    );
  }
}
