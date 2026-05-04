import '../domain/entities/user_entity.dart';
import '../domain/exceptions/auth_exception.dart';
import '../domain/exceptions/network_exception.dart';
import '../domain/exceptions/service_exception.dart';
import '../domain/exceptions/user_exception.dart';
import '../domain/exceptions/validation_exception.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/validators/auth_validator.dart';

class AuthService {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  const AuthService({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  }) : _authRepository = authRepository,
       _userRepository = userRepository;

  Stream<UserEntity?> authStateChanges() {
    return _authRepository.authStateChanges();
  }

  Future<UserEntity?> getCurrentUser() async {
    try {
      return await _authRepository.getCurrentUser();
    } on AuthException {
      rethrow;
    } on UserException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on ServiceException {
      rethrow;
    } catch (e) {
      throw AuthException('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final emailError = AuthValidator.validateEmail(email);
      if (emailError != null) {
        throw ValidationException(emailError, 'email');
      }

      final passwordError = AuthValidator.validatePassword(password);
      if (passwordError != null) {
        throw ValidationException(passwordError, 'password');
      }

      return await _authRepository.signIn(
        email: email.trim(),
        password: password,
      );
    } on ValidationException {
      rethrow;
    } on AuthException {
      rethrow;
    } on UserException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on ServiceException {
      rethrow;
    } catch (e) {
      throw AuthException('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<UserEntity> register({
    required String fullName,
    required String email,
    required String studentId,
    required String password,
  }) async {
    try {
      final fullNameError = AuthValidator.validateRequired(
        fullName,
        'Full name',
      );
      if (fullNameError != null) {
        throw ValidationException(fullNameError, 'fullName');
      }

      final emailError = AuthValidator.validateEmail(email);
      if (emailError != null) {
        throw ValidationException(emailError, 'email');
      }

      final studentIdError = AuthValidator.validateStudentId(studentId);
      if (studentIdError != null) {
        throw ValidationException(studentIdError, 'studentId');
      }

      final passwordError = AuthValidator.validatePassword(password);
      if (passwordError != null) {
        throw ValidationException(passwordError, 'password');
      }

      final userId = await _authRepository.register(
        email: email.trim(),
        password: password,
      );

      await _userRepository.createUserMetadata(
        userId: userId,
        fullName: fullName.trim(),
        email: email.trim(),
        studentId: studentId.trim(),
      );

      final user = await _authRepository.getCurrentUser();
      if (user == null) {
        throw AuthException('Failed to retrieve user after registration');
      }

      return user;
    } on ValidationException {
      rethrow;
    } on AuthException {
      rethrow;
    } on UserException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on ServiceException {
      rethrow;
    } catch (e) {
      throw AuthException('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
    } on AuthException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on ServiceException {
      rethrow;
    } catch (e) {
      throw AuthException(
        'An unexpected error occurred during sign out: ${e.toString()}',
      );
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      final emailError = AuthValidator.validateEmail(email);
      if (emailError != null) {
        throw ValidationException(emailError, 'email');
      }

      await _authRepository.sendPasswordResetEmail(email: email.trim());
    } on ValidationException {
      rethrow;
    } on AuthException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on ServiceException {
      rethrow;
    } catch (e) {
      throw AuthException('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> updateProfile({
    required String userId,
    required String fullName,
    required String studentId,
  }) async {
    final fullNameError = AuthValidator.validateRequired(fullName, 'Full name');
    if (fullNameError != null) {
      throw ValidationException(fullNameError, 'fullName');
    }

    final studentIdError = AuthValidator.validateStudentId(studentId);
    if (studentIdError != null) {
      throw ValidationException(studentIdError, 'studentId');
    }

    try {
      await _userRepository.updateUserMetadata(
        userId: userId,
        updates: {'fullName': fullName.trim(), 'studentId': studentId.trim()},
      );
    } on UserException {
      rethrow;
    } catch (e) {
      throw UserException('Failed to update profile: ${e.toString()}');
    }
  }
}
