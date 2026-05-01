import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';

/// Authentication state representing the current user status
class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  /// User is authenticated
  bool get isAuthenticated => user != null;

  /// User is unauthenticated
  bool get isUnauthenticated => user == null && !isLoading;

  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          isLoading == other.isLoading &&
          error == other.error;

  @override
  int get hashCode => user.hashCode ^ isLoading.hashCode ^ error.hashCode;

  @override
  String toString() {
    return 'AuthState(user: $user, isLoading: $isLoading, error: $error)';
  }
}
