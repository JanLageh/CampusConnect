import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<void> createUserMetadata({
    required String userId,
    required String fullName,
    required String email,
    required String studentId,
  });

  Future<UserEntity?> getUserMetadata({required String userId});

  Future<void> updateUserMetadata({
    required String userId,
    required Map<String, dynamic> updates,
  });
}
