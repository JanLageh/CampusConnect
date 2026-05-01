import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  const GetCurrentUserUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  }) : _authRepository = authRepository,
       _userRepository = userRepository;

  Future<UserEntity?> execute() async {
    throw UnimplementedError(
      'GetCurrentUserUseCase.execute() not yet implemented',
    );
  }
}
