class ValidationException implements Exception {
  final String message;
  final String field;

  const ValidationException(this.message, this.field);

  @override
  String toString() => 'ValidationException: $message (field: $field)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationException &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          field == other.field;

  @override
  int get hashCode => message.hashCode ^ field.hashCode;
}
