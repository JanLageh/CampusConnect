import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel {
  final String userId;
  final String fullName;
  final String email;
  final String studentId;
  final String role;
  final List<String> groupMemberships;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.studentId,
    required this.role,
    required this.groupMemberships,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw FormatException('Document data is null for user: ${doc.id}');
    }

    return UserModel(
      userId: doc.id,
      fullName: data['fullName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      studentId: data['studentId'] as String? ?? '',
      role: data['role'] as String? ?? 'student',
      groupMemberships: data['groupMemberships'] != null
          ? List<String>.from(data['groupMemberships'] as List)
          : [],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'email': email,
      'studentId': studentId,
      'role': role,
      'groupMemberships': groupMemberships,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      studentId: studentId,
      role: role,
      groupMemberships: List<String>.from(groupMemberships),
    );
  }

  UserModel copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? studentId,
    String? role,
    List<String>? groupMemberships,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      studentId: studentId ?? this.studentId,
      role: role ?? this.role,
      groupMemberships: groupMemberships ?? this.groupMemberships,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          fullName == other.fullName &&
          email == other.email &&
          studentId == other.studentId &&
          role == other.role &&
          _listEquals(groupMemberships, other.groupMemberships) &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      userId.hashCode ^
      fullName.hashCode ^
      email.hashCode ^
      studentId.hashCode ^
      role.hashCode ^
      groupMemberships.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

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
    return 'UserModel(userId: $userId, fullName: $fullName, email: $email, '
        'studentId: $studentId, role: $role, groupMemberships: $groupMemberships, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
