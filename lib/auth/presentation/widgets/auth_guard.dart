import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_state_provider.dart';

class AuthGuard extends ConsumerStatefulWidget {
  final Widget child;

  final String loginRoute;

  final VoidCallback? onAuthenticationFailed;

  const AuthGuard({
    super.key,
    required this.child,
    this.loginRoute = '/login',
    this.onAuthenticationFailed,
  });

  @override
  ConsumerState<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends ConsumerState<AuthGuard> {
  bool _hasCheckedAuth = false;
  bool _isRedirecting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (previous?.isAuthenticated == true && next.isUnauthenticated) {
        _handleUnauthenticated(context);
      }
    });

    if (authState.isLoading && !_hasCheckedAuth) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_hasCheckedAuth) {
      _hasCheckedAuth = true;
    }

    if (authState.isUnauthenticated) {
      _handleUnauthenticated(context);

      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return widget.child;
  }

  void _handleUnauthenticated(BuildContext context) {
    if (_isRedirecting) {
      return;
    }

    _isRedirecting = true;

    widget.onAuthenticationFailed?.call();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(
        widget.loginRoute,
        arguments: {
          'message': 'Please sign in to access this page',
          'returnUrl': ModalRoute.of(context)?.settings.name,
        },
      );

      _isRedirecting = false;
    });
  }
}

class AuthGuardBuilder extends ConsumerWidget {
  final Widget Function(
    BuildContext context,
    bool isAuthenticated,
    dynamic user,
  )
  builder;

  final Widget? loadingWidget;

  const AuthGuardBuilder({
    super.key,
    required this.builder,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    if (authState.isLoading) {
      return loadingWidget ??
          const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return builder(context, authState.isAuthenticated, authState.user);
  }
}
