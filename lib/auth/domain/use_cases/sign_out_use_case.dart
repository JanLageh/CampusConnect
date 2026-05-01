import '../repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;

  const SignOutUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<void> execute() async {
    throw UnimplementedError('SignOutUseCase.execute() not yet implemented');
  }
}
