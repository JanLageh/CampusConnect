import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';
import 'auth_error_mapper.dart';

class LoginController extends ChangeNotifier {
  final AuthRepository _authRepository;
  
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  LoginController({required AuthRepository authRepository}) : _authRepository = authRepository;

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
}
