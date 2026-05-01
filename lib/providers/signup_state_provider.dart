import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart';

/// State class for sign up screen
class SignUpState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const SignUpState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  SignUpState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return SignUpState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// Notifier for managing sign up state and operations
class SignUpNotifier extends Notifier<SignUpState> {
  @override
  SignUpState build() => const SignUpState();

  /// Sign up with email and password
  Future<bool> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signUp(email: email, password: password);

      // Send verification email
      await authRepository.sendVerificationEmail();

      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _mapErrorToMessage(e),
        isSuccess: false,
      );
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Map exceptions to user-friendly messages
  String _mapErrorToMessage(Object error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('email-already-in-use')) {
      return 'An account with this email already exists.';
    } else if (errorString.contains('invalid-email')) {
      return 'Invalid email address format.';
    } else if (errorString.contains('weak-password')) {
      return 'Password is too weak. Please use a stronger password.';
    } else if (errorString.contains('network')) {
      return 'Network error. Please check your connection.';
    } else {
      return 'An error occurred during sign up. Please try again.';
    }
  }
}

/// Provider for the sign up state notifier
final signUpProvider = NotifierProvider<SignUpNotifier, SignUpState>(() {
  return SignUpNotifier();
});
