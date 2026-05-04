import '../../domain/exceptions/auth_exception.dart';
import '../../domain/exceptions/user_exception.dart';
import '../../domain/exceptions/validation_exception.dart';
import '../../domain/exceptions/network_exception.dart';
import '../../domain/exceptions/service_exception.dart';

/// Utility class for mapping domain exceptions to user-friendly error messages.
///
/// This class provides static methods to convert technical exceptions into
/// messages that are appropriate for display to end users. The mappings follow
/// the error handling strategy defined in the design document.
class ErrorMessageMapper {
  // Private constructor to prevent instantiation
  ErrorMessageMapper._();

  /// Maps an AuthException to a user-friendly error message.
  ///
  /// Handles Firebase Authentication error codes and provides appropriate
  /// messages based on the error code. Falls back to the exception's message
  /// if no specific mapping exists.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await signIn();
  /// } on AuthException catch (e) {
  ///   final message = ErrorMessageMapper.mapAuthException(e);
  ///   showError(message);
  /// }
  /// ```
  static String mapAuthException(AuthException exception) {
    // Check for specific error codes from Firebase Auth
    switch (exception.code) {
      case 'email-already-in-use':
        return ErrorMessages.emailAlreadyInUse;
      case 'user-not-found':
      case 'wrong-password':
        return ErrorMessages.invalidCredentials;
      case 'user-disabled':
        return ErrorMessages.accountDisabled;
      case 'too-many-requests':
        return ErrorMessages.tooManyAttempts;
      case 'operation-not-allowed':
        return ErrorMessages.operationNotAllowed;
      default:
        // If the exception already has a user-friendly message, use it
        // Otherwise, return a generic error message
        if (exception.message.isNotEmpty &&
            !exception.message.contains('Exception') &&
            !exception.message.contains('failed')) {
          return exception.message;
        }
        return ErrorMessages.unexpectedError;
    }
  }

  /// Maps a UserException to a user-friendly error message.
  ///
  /// Handles Firestore user metadata operation errors and provides appropriate
  /// messages based on the error code.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await getUserMetadata();
  /// } on UserException catch (e) {
  ///   final message = ErrorMessageMapper.mapUserException(e);
  ///   showError(message);
  /// }
  /// ```
  static String mapUserException(UserException exception) {
    // Check for specific error codes from Firestore
    switch (exception.code) {
      case 'permission-denied':
        return ErrorMessages.accessDenied;
      case 'not-found':
        return ErrorMessages.userDataNotFound;
      case 'unavailable':
        return ErrorMessages.serviceUnavailable;
      case 'deadline-exceeded':
        return ErrorMessages.requestTimeout;
      default:
        // If the exception already has a user-friendly message, use it
        if (exception.message.isNotEmpty &&
            !exception.message.contains('Exception') &&
            !exception.message.contains('failed')) {
          return exception.message;
        }
        return ErrorMessages.userDataLoadFailed;
    }
  }

  /// Maps a ValidationException to a user-friendly error message.
  ///
  /// Validation exceptions already contain user-friendly messages from the
  /// AuthValidator, so this method simply returns the exception's message.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   validateInput();
  /// } on ValidationException catch (e) {
  ///   final message = ErrorMessageMapper.mapValidationException(e);
  ///   showError(message);
  /// }
  /// ```
  static String mapValidationException(ValidationException exception) {
    // Validation exceptions already have user-friendly messages
    return exception.message;
  }

  /// Maps a NetworkException to a user-friendly error message.
  ///
  /// Network exceptions indicate connectivity issues and provide appropriate
  /// guidance to the user.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await makeRequest();
  /// } on NetworkException catch (e) {
  ///   final message = ErrorMessageMapper.mapNetworkException(e);
  ///   showError(message);
  /// }
  /// ```
  static String mapNetworkException(NetworkException exception) {
    // Network exceptions already have user-friendly messages
    // But we can provide a fallback if needed
    if (exception.message.isNotEmpty) {
      return exception.message;
    }
    return ErrorMessages.networkError;
  }

  /// Maps a ServiceException to a user-friendly error message.
  ///
  /// Service exceptions indicate backend service issues and provide appropriate
  /// guidance to the user.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await callService();
  /// } on ServiceException catch (e) {
  ///   final message = ErrorMessageMapper.mapServiceException(e);
  ///   showError(message);
  /// }
  /// ```
  static String mapServiceException(ServiceException exception) {
    // Service exceptions already have user-friendly messages
    // But we can provide a fallback if needed
    if (exception.message.isNotEmpty) {
      return exception.message;
    }
    return ErrorMessages.serviceUnavailable;
  }

  /// Maps any exception to a user-friendly error message.
  ///
  /// This is a convenience method that handles all exception types and
  /// delegates to the appropriate specific mapper. Use this when you want
  /// to handle multiple exception types in a single catch block.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await performOperation();
  /// } catch (e) {
  ///   final message = ErrorMessageMapper.mapException(e);
  ///   showError(message);
  /// }
  /// ```
  static String mapException(Object exception) {
    if (exception is AuthException) {
      return mapAuthException(exception);
    } else if (exception is UserException) {
      return mapUserException(exception);
    } else if (exception is ValidationException) {
      return mapValidationException(exception);
    } else if (exception is NetworkException) {
      return mapNetworkException(exception);
    } else if (exception is ServiceException) {
      return mapServiceException(exception);
    } else {
      // Unknown exception type
      return ErrorMessages.unexpectedError;
    }
  }
}

/// Constants for user-friendly error messages.
///
/// These messages match the error handling strategy defined in the design
/// document and provide consistent messaging across the application.
class ErrorMessages {
  // Private constructor to prevent instantiation
  ErrorMessages._();

  // Authentication errors
  static const String emailAlreadyInUse =
      'This email is already registered. Please sign in instead.';
  static const String invalidCredentials = 'Invalid email or password.';
  static const String accountDisabled =
      'This account has been disabled. Please contact support.';
  static const String tooManyAttempts =
      'Too many failed attempts. Please try again later.';
  static const String operationNotAllowed =
      'This operation is not allowed. Please contact support.';

  // Validation errors
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String weakPassword =
      'Password must be at least 6 characters long.';

  // User metadata errors
  static const String accessDenied = 'Access denied. Please sign in again.';
  static const String userDataNotFound = 'User data not found.';
  static const String userDataLoadFailed =
      'Failed to load user data. Please try again.';

  // Network errors
  static const String networkError =
      'Network error. Please check your connection.';
  static const String requestTimeout =
      'Request timed out. Please check your connection.';

  // Service errors
  static const String serviceUnavailable =
      'Service temporarily unavailable. Please try again.';

  // Generic errors
  static const String unexpectedError =
      'An unexpected error occurred. Please try again.';
}
