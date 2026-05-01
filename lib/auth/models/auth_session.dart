class AuthSession {
  final String uid;
  final String email;
  final bool isEmailVerified;
  final String? displayName;
  final String? photoURL;

  const AuthSession({
    required this.uid,
    required this.email,
    this.isEmailVerified = false,
    this.displayName,
    this.photoURL,
  });

  String get name => displayName ?? email.split('@').first;
}
