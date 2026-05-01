import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/domain/exceptions/validation_exception.dart';
import '../auth/domain/exceptions/auth_exception.dart';
import '../auth/domain/exceptions/network_exception.dart';
import '../auth/domain/exceptions/service_exception.dart';
import '../auth/presentation/utils/error_message_mapper.dart';
import 'auth_providers.dart';

/// State class for reset password screen
class ResetPasswordState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const ResetPasswordState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  ResetPasswordState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return ResetPasswordState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// Notifier for managing reset password state and operations
class ResetPasswordNotifier extends Notifier<ResetPasswordState> {
  @override
  ResetPasswordState build() => const ResetPasswordState();

  /// Send password reset email using ResetPasswordUseCase
  Future<void> sendResetEmail(String email) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );

    try {
      final resetPasswordUseCase = ref.read(resetPasswordUseCaseProvider);
      await resetPasswordUseCase.execute(email: email);

      // Always show success (security best practice - don't reveal if email exists)
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
      );
    } on ValidationException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: ErrorMessageMapper.mapValidationException(e),
        isSuccess: false,
      );
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: ErrorMessageMapper.mapAuthException(e),
        isSuccess: false,
      );
    } on NetworkException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: ErrorMessageMapper.mapNetworkException(e),
        isSuccess: false,
      );
    } on ServiceException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: ErrorMessageMapper.mapServiceException(e),
        isSuccess: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: ErrorMessageMapper.mapException(e),
        isSuccess: false,
      );
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Reset state
  void reset() {
    state = const ResetPasswordState();
  }
}

/// Provider for the reset password state notifier
final resetPasswordProvider =
    NotifierProvider<ResetPasswordNotifier, ResetPasswordState>(() {
      return ResetPasswordNotifier();
    });
