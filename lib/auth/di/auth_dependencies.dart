import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/data_sources/firebase_auth_data_source.dart';
import '../data/data_sources/firestore_user_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/use_cases/get_current_user_use_case.dart';
import '../domain/use_cases/register_use_case.dart';
import '../domain/use_cases/reset_password_use_case.dart';
import '../domain/use_cases/sign_in_use_case.dart';
import '../domain/use_cases/sign_out_use_case.dart';

class AuthDependencies {
  static final AuthDependencies _instance = AuthDependencies._internal();
  factory AuthDependencies() => _instance;
  AuthDependencies._internal();

  FirebaseAuth get _firebaseAuth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  FirebaseAuthDataSource? _authDataSource;
  FirebaseAuthDataSource get authDataSource {
    _authDataSource ??= FirebaseAuthDataSource(firebaseAuth: _firebaseAuth);
    return _authDataSource!;
  }

  FirestoreUserDataSource? _firestoreDataSource;
  FirestoreUserDataSource get firestoreDataSource {
    _firestoreDataSource ??= FirestoreUserDataSource(firestore: _firestore);
    return _firestoreDataSource!;
  }

  UserRepository? _userRepository;
  UserRepository get userRepository {
    _userRepository ??= UserRepositoryImpl(
      firestoreDataSource: firestoreDataSource,
    );
    return _userRepository!;
  }

  AuthRepository? _authRepository;
  AuthRepository get authRepository {
    _authRepository ??= AuthRepositoryImpl(
      authDataSource: authDataSource,
      userRepository: userRepository,
    );
    return _authRepository!;
  }

  SignInUseCase? _signInUseCase;
  SignInUseCase get signInUseCase {
    _signInUseCase ??= SignInUseCase(
      authRepository: authRepository,
      userRepository: userRepository,
    );
    return _signInUseCase!;
  }

  RegisterUseCase? _registerUseCase;
  RegisterUseCase get registerUseCase {
    _registerUseCase ??= RegisterUseCase(
      authRepository: authRepository,
      userRepository: userRepository,
    );
    return _registerUseCase!;
  }

  SignOutUseCase? _signOutUseCase;
  SignOutUseCase get signOutUseCase {
    _signOutUseCase ??= SignOutUseCase(authRepository: authRepository);
    return _signOutUseCase!;
  }

  ResetPasswordUseCase? _resetPasswordUseCase;
  ResetPasswordUseCase get resetPasswordUseCase {
    _resetPasswordUseCase ??= ResetPasswordUseCase(
      authRepository: authRepository,
    );
    return _resetPasswordUseCase!;
  }

  GetCurrentUserUseCase? _getCurrentUserUseCase;
  GetCurrentUserUseCase get getCurrentUserUseCase {
    _getCurrentUserUseCase ??= GetCurrentUserUseCase(
      authRepository: authRepository,
      userRepository: userRepository,
    );
    return _getCurrentUserUseCase!;
  }

  void reset() {
    _authDataSource = null;
    _firestoreDataSource = null;
    _userRepository = null;
    _authRepository = null;
    _signInUseCase = null;
    _registerUseCase = null;
    _signOutUseCase = null;
    _resetPasswordUseCase = null;
    _getCurrentUserUseCase = null;
  }
}
