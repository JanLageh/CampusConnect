import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _authRepository;

  const ResetPasswordUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<void> execute({required String email}) async {
    throw UnimplementedError(
      'ResetPasswordUseCase.execute() not yet implemented',
    );
  }
}
