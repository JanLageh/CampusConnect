import 'dart:async';
import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';
import '../data/firebase_auth_repository.dart';

class VerifyEmailScreen extends StatefulWidget {
  final AuthRepository? authRepository;

  const VerifyEmailScreen({super.key, this.authRepository});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  static const int _cooldownSeconds = 45;
  
  final Color primaryDarkBlue = const Color(0xFF001e40);
  final Color backgroundSurface = const Color(0xFFf8f9fa);
  final Color textDark = const Color(0xFF191c1d);

  late final AuthRepository _authRepository;
  
  int _secondsLeft = 0;
  Timer? _timer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? FirebaseAuthRepository();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    if (!mounted) return;
    setState(() => _secondsLeft = _cooldownSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          timer.cancel();
          _timer = null;
        }
      });
    });
  }

  Future<void> _handleResend() async {
    if (_secondsLeft > 0) return;

    setState(() => _isLoading = true);
    try {
      await _authRepository.sendVerificationEmail();
      _startCooldown();
    } catch (e) {
      // Intentionally swallow errors to prevent leaking auth state/rate limiting details on UI,
      // and default to starting cooldown so users avoid spamming.
      _startCooldown();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSignOut() async {
    await _authRepository.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundSurface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.mark_email_read, size: 80, color: primaryDarkBlue),
                  const SizedBox(height: 32),
                  Text(
                    'Verify your email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'We sent a verification link to your email address. Please verify your account to access Campus Connect modules.\n\nOnce verified, return here or login again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: _secondsLeft > 0 || _isLoading ? null : _handleResend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryDarkBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(
                            _secondsLeft > 0
                                ? 'Resend in $_secondsLeft s'
                                : 'Resend Verification Email',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _handleSignOut,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Return to Login', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
