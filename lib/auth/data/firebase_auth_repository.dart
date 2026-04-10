import 'package:firebase_auth/firebase_auth.dart';
import '../domain/auth_repository.dart';
import '../models/auth_session.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  AuthSession? _mapUser(User? user) {
    if (user == null) return null;
    return AuthSession(
      uid: user.uid,
      email: user.email ?? '',
      isEmailVerified: user.emailVerified,
    );
  }

  @override
  Stream<AuthSession?> observeAuthState() {
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  @override
  Future<AuthSession> signIn({required String email, required String password}) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapUser(credential.user)!;
  }

  @override
  Future<AuthSession> signUp({required String email, required String password}) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapUser(credential.user)!;
  }

  @override
  Future<void> sendVerificationEmail() async {
    final user = _firebaseAuth.currentUser;
    await user?.sendEmailVerification();
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
