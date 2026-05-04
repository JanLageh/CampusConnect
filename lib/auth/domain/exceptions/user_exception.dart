class UserException implements Exception {
  final String message;
  final String? code;

  const UserException(this.message, {this.code});

  @override
  String toString() =>
      'UserException: $message${code != null ? ' (code: $code)' : ''}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserException &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}
