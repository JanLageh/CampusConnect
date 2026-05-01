class ServiceException implements Exception {
  final String message;

  const ServiceException(this.message);

  @override
  String toString() => 'ServiceException: $message';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceException &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
