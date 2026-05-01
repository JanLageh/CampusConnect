import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/di/auth_dependencies.dart';
import '../auth/domain/exceptions/auth_exception.dart';
import '../auth/domain/exceptions/network_exception.dart';
import '../auth/domain/exceptions/service_exception.dart';
import '../auth/domain/exceptions/validation_exception.dart';

/// Provider for SignInUseCase
final signInUseCaseProvider = Provider((ref) {
  return AuthDependencies().signInUseCase;
});

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

  /// Sign in with email and password using SignInUseCase
  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final signInUseCase = ref.read(signInUseCaseProvider);
      await signInUseCase.execute(email: email, password: password);
      // Success - state will be updated by authStateProvider
      state = state.copyWith(isLoading: false);
    } on ValidationException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } on NetworkException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } on ServiceException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider for the login state notifier
final loginProvider = NotifierProvider<LoginNotifier, LoginState>(() {
  return LoginNotifier();
});
