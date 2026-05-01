class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException(this.message, {this.code});

  @override
  String toString() =>
      'AuthException: $message${code != null ? ' (code: $code)' : ''}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthException &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}
