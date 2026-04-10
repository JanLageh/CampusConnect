import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/user_profile_repository.dart';

class FirestoreUserProfileRepository implements UserProfileRepository {
  final FirebaseFirestore _firestore;

  FirestoreUserProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>> bootstrapUserProfile({
    required String uid,
    required String email,
  }) async {
    final userDoc = _firestore.collection('users').doc(uid);
    final snapshot = await userDoc.get();
    
    if (!snapshot.exists) {
      final payload = {
        'email': email,
        'role': 'student',
        'createdAt': FieldValue.serverTimestamp(),
      };
      await userDoc.set(payload);
      return payload;
    }
    
    return snapshot.data() ?? {};
  }
}
