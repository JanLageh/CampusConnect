abstract class UserProfileRepository {
  /// Contract includes email, role, createdAt fields and defaults role to student
  /// when creating bootstrap payload.
  Future<Map<String, dynamic>> bootstrapUserProfile({
    required String uid,
    required String email,
  });
}
