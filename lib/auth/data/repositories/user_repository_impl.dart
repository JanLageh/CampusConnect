import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/firestore_user_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final FirestoreUserDataSource _firestoreDataSource;

  const UserRepositoryImpl({
    required FirestoreUserDataSource firestoreDataSource,
  }) : _firestoreDataSource = firestoreDataSource;

  @override
  Future<void> createUserMetadata({
    required String userId,
    required String fullName,
    required String email,
    required String studentId,
  }) async {
    throw UnimplementedError(
      'UserRepositoryImpl.createUserMetadata() not yet implemented',
    );
  }

  @override
  Future<UserEntity?> getUserMetadata({required String userId}) async {
    throw UnimplementedError(
      'UserRepositoryImpl.getUserMetadata() not yet implemented',
    );
  }

  @override
  Future<void> updateUserMetadata({
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    throw UnimplementedError(
      'UserRepositoryImpl.updateUserMetadata() not yet implemented',
    );
  }
}
