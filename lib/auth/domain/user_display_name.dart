import 'entities/user_entity.dart';

extension UserDisplayName on UserEntity {
  String get displayName {
    final trimmedFullName = fullName.trim();
    if (trimmedFullName.isNotEmpty) {
      return trimmedFullName;
    }

    final emailPrefix = email.split('@').first.trim();
    if (emailPrefix.isNotEmpty) {
      return emailPrefix;
    }

    return 'User';
  }
}
