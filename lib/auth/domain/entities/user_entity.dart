class UserEntity {
  final String userId;
  final String fullName;
  final String email;
  final String studentId;
  final String role;
  final List<String> groupMemberships;

  const UserEntity({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.studentId,
    required this.role,
    required this.groupMemberships,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          fullName == other.fullName &&
          email == other.email &&
          studentId == other.studentId &&
          role == other.role &&
          _listEquals(groupMemberships, other.groupMemberships);

  @override
  int get hashCode =>
      userId.hashCode ^
      fullName.hashCode ^
      email.hashCode ^
      studentId.hashCode ^
      role.hashCode ^
      groupMemberships.hashCode;

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'UserEntity(userId: $userId, fullName: $fullName, email: $email, '
        'studentId: $studentId, role: $role, groupMemberships: $groupMemberships)';
  }
}
