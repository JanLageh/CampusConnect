class AuthSession {
  final String uid;
  final String email;
  final bool isEmailVerified;

  const AuthSession({
    required this.uid,
    required this.email,
    this.isEmailVerified = false,
  });
}
