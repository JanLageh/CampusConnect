import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';
import '../domain/user_profile_repository.dart';
import 'auth_error_mapper.dart';

class LoginController extends ChangeNotifier {
  final AuthRepository _authRepository;
  final UserProfileRepository? _userProfileRepository;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  LoginController({
    required AuthRepository authRepository,
    UserProfileRepository? userProfileRepository,
  }) : _authRepository = authRepository,
       _userProfileRepository = userProfileRepository;

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.signIn(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = AuthErrorMapper.getFriendlyMessage(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final session = await _authRepository.signUp(
        email: email,
        password: password,
      );
      if (_userProfileRepository != null) {
        await _userProfileRepository.bootstrapUserProfile(
          uid: session.uid,
          email: session.email,
        );
      }
      await _authRepository.sendVerificationEmail();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = AuthErrorMapper.getFriendlyMessage(e);
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
