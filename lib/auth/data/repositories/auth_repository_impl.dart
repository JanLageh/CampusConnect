import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/firebase_auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _authDataSource;
  final UserRepository _userRepository;

  const AuthRepositoryImpl({
    required FirebaseAuthDataSource authDataSource,
    required UserRepository userRepository,
  }) : _authDataSource = authDataSource,
       _userRepository = userRepository;

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError('AuthRepositoryImpl.signIn() not yet implemented');
  }

  @override
  Future<String> register({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError(
      'AuthRepositoryImpl.register() not yet implemented',
    );
  }

  @override
  Future<void> signOut() async {
    throw UnimplementedError(
      'AuthRepositoryImpl.signOut() not yet implemented',
    );
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    throw UnimplementedError(
      'AuthRepositoryImpl.sendPasswordResetEmail() not yet implemented',
    );
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    throw UnimplementedError(
      'AuthRepositoryImpl.getCurrentUser() not yet implemented',
    );
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    throw UnimplementedError(
      'AuthRepositoryImpl.authStateChanges() not yet implemented',
    );
  }
}
