import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart';

/// State class for login screen
class LoginState {
  final bool isLoading;
  final String? errorMessage;

  const LoginState({this.isLoading = false, this.errorMessage});

  LoginState copyWith({bool? isLoading, String? errorMessage}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// StateNotifier for managing login state and operations
class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signIn(email: email, password: password);
      // Success - state will be updated by authStateProvider
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapErrorToMessage(e),
      );
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Map exceptions to user-friendly messages
  String _mapErrorToMessage(Object error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('user-not-found')) {
      return 'No account found with this email address.';
    } else if (errorString.contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    } else if (errorString.contains('invalid-email')) {
      return 'Invalid email address format.';
    } else if (errorString.contains('user-disabled')) {
      return 'This account has been disabled.';
    } else if (errorString.contains('too-many-requests')) {
      return 'Too many failed attempts. Please try again later.';
    } else if (errorString.contains('network')) {
      return 'Network error. Please check your connection.';
    } else {
      return 'An error occurred. Please try again.';
    }
  }
}

/// Provider for the login state notifier
final loginProvider = NotifierProvider<LoginNotifier, LoginState>(() {
  return LoginNotifier();
});
