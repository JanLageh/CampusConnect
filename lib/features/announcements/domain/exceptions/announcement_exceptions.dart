/// Base exception for announcement-related errors
class AnnouncementException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AnnouncementException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() =>
      'AnnouncementException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Exception thrown when an announcement is not found
class AnnouncementNotFoundException extends AnnouncementException {
  const AnnouncementNotFoundException({
    String message = 'Announcement not found',
    String? code,
    dynamic originalError,
  }) : super(message: message, code: code, originalError: originalError);
}

/// Exception thrown when user lacks permission to access/modify an announcement
class AnnouncementPermissionException extends AnnouncementException {
  const AnnouncementPermissionException({
    String message = 'Permission denied',
    String? code,
    dynamic originalError,
  }) : super(message: message, code: code, originalError: originalError);
}

/// Exception thrown when announcement data is invalid
class AnnouncementValidationException extends AnnouncementException {
  const AnnouncementValidationException({
    String message = 'Invalid announcement data',
    String? code,
    dynamic originalError,
  }) : super(message: message, code: code, originalError: originalError);
}

/// Exception thrown when a network/Firestore operation fails
class AnnouncementNetworkException extends AnnouncementException {
  const AnnouncementNetworkException({
    String message = 'Network error occurred',
    String? code,
    dynamic originalError,
  }) : super(message: message, code: code, originalError: originalError);
}
