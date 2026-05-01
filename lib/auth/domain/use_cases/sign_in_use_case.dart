import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  const SignInUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  }) : _authRepository = authRepository,
       _userRepository = userRepository;

  Future<UserEntity> execute({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError('SignInUseCase.execute() not yet implemented');
  }
}
