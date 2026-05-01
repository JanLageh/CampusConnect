import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart';

/// State class for verify email screen
class VerifyEmailState {
  final bool isLoading;
  final int secondsLeft;

  const VerifyEmailState({this.isLoading = false, this.secondsLeft = 0});

  VerifyEmailState copyWith({bool? isLoading, int? secondsLeft}) {
    return VerifyEmailState(
      isLoading: isLoading ?? this.isLoading,
      secondsLeft: secondsLeft ?? this.secondsLeft,
    );
  }

  bool get canResend => secondsLeft == 0 && !isLoading;
}

/// Notifier for managing verify email state and operations
class VerifyEmailNotifier extends Notifier<VerifyEmailState> {
  static const int cooldownSeconds = 45;
  Timer? _timer;

  @override
  VerifyEmailState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return const VerifyEmailState();
  }

  /// Resend verification email
  Future<void> resendVerificationEmail() async {
    if (!state.canResend) return;

    state = state.copyWith(isLoading: true);

    try {
      // Note: Email verification is not part of the current AuthRepository interface
      // This functionality would need to be added if email verification is required
      // For now, we'll just start the cooldown to prevent spam
      _startCooldown();
    } catch (e) {
      // Intentionally swallow errors and start cooldown to prevent spam
      _startCooldown();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Start cooldown timer
  void _startCooldown() {
    state = state.copyWith(secondsLeft: cooldownSeconds);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsLeft > 0) {
        state = state.copyWith(secondsLeft: state.secondsLeft - 1);
      } else {
        timer.cancel();
        _timer = null;
      }
    });
  }

  /// Sign out
  Future<void> signOut() async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.signOut();
  }
}

/// Provider for the verify email state notifier
final verifyEmailProvider =
    NotifierProvider<VerifyEmailNotifier, VerifyEmailState>(() {
      return VerifyEmailNotifier();
    });
