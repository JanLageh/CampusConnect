import 'package:flutter/foundation.dart';
import '../domain/auth_repository.dart';
import '../models/auth_session.dart';

class AuthSessionController {
  final AuthRepository _authRepository;
  final List<VoidCallback> _cleanupHooks = [];

  AuthSessionController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Stream<AuthSession?> observeAuthState() => _authRepository.observeAuthState();

  void registerCleanupHook(VoidCallback hook) {
    if (!_cleanupHooks.contains(hook)) {
      _cleanupHooks.add(hook);
    }
  }

  void removeCleanupHook(VoidCallback hook) {
    _cleanupHooks.remove(hook);
  }

  Future<void> signOut() async {
    for (final hook in _cleanupHooks) {
      try {
        hook();
      } catch (e) {
        debugPrint('Error running auth cleanup hook: $e');
      }
    }
    await _authRepository.signOut();
  }
}
