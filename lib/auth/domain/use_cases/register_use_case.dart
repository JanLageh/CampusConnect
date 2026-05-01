import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  const RegisterUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  }) : _authRepository = authRepository,
       _userRepository = userRepository;

  Future<UserEntity> execute({
    required String fullName,
    required String email,
    required String studentId,
    required String password,
  }) async {
    throw UnimplementedError('RegisterUseCase.execute() not yet implemented');
  }
}
