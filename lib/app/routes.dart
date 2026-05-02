import 'package:flutter/material.dart';
import '../auth/presentation/login_screen_riverpod.dart';
import '../auth/presentation/register_screen.dart';
import '../auth/presentation/reset_password_screen_riverpod.dart';
import '../home_screen.dart';
import '../features/announcements/presentation/screens/announcements_screen.dart';
import '../features/events/events_screen.dart';
import '../features/chat/presentation/screens/chat_screen.dart';
import '../features/resources/resources_screen.dart';
import '../features/profile/profile_screen_riverpod.dart';

/// Application route names
class AppRoutes {
  // Public routes (no authentication required)
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Protected routes (authentication required)
  static const String home = '/home';
  static const String announcements = '/announcements';
  static const String events = '/events';
  static const String chats = '/chats';
  static const String resources = '/resources';
  static const String profile = '/profile';
}

/// Route generator for the application
class AppRouteGenerator {
  /// Generate routes based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Public routes
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreenRiverpod(),
          settings: settings,
        );

      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ResetPasswordScreenRiverpod(),
          settings: settings,
        );

      // Protected routes
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case AppRoutes.announcements:
        return MaterialPageRoute(
          builder: (_) => const AnnouncementsScreen(),
          settings: settings,
        );

      case AppRoutes.events:
        return MaterialPageRoute(
          builder: (_) => const EventsScreen(),
          settings: settings,
        );

      case AppRoutes.chats:
        return MaterialPageRoute(
          builder: (_) => const ChatScreen(),
          settings: settings,
        );

      case AppRoutes.resources:
        return MaterialPageRoute(
          builder: (_) => const ResourcesScreen(),
          settings: settings,
        );

      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreenRiverpod(),
          settings: settings,
        );

      // Default route
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  /// List of protected route names that require authentication
  static const List<String> protectedRoutes = [
    AppRoutes.home,
    AppRoutes.announcements,
    AppRoutes.events,
    AppRoutes.chats,
    AppRoutes.resources,
    AppRoutes.profile,
  ];

  /// List of public route names that don't require authentication
  static const List<String> publicRoutes = [
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.forgotPassword,
  ];

  /// Check if a route is protected
  static bool isProtectedRoute(String? routeName) {
    return protectedRoutes.contains(routeName);
  }

  /// Check if a route is public
  static bool isPublicRoute(String? routeName) {
    return publicRoutes.contains(routeName);
  }
}
