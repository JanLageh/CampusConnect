import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Appwrite project configuration
class AppwriteConfig {
  static String get projectId => dotenv.env['APPWRITE_PROJECT_ID'] ?? '';
  static String get projectName => dotenv.env['APPWRITE_PROJECT_NAME'] ?? '';
  static String get endpoint => dotenv.env['APPWRITE_ENDPOINT'] ?? '';

  /// Singleton instance of Appwrite Client
  static Client? _client;

  /// Get the Appwrite client instance
  static Client get client {
    _client ??= Client()
        .setEndpoint(endpoint)
        .setProject(projectId)
        .setSelfSigned(
          status: true,
        ); // Only for development with self-signed certificates
    return _client!;
  }

  /// Initialize Appwrite services
  static Account get account => Account(client);
  static Storage get storage => Storage(client);
  static Databases get databases => Databases(client);

  /// Ping Appwrite server to verify connectivity
  static Future<void> ping() async {
    try {
      // Simple connection test - just verify we can reach the endpoint
      final account = Account(client);

      try {
        await account.get();
        // ignore: avoid_print
        print('✅ Appwrite connection successful - User authenticated');
      } catch (error) {
        // If we get a 401, connection still works but user not logged in
        if (error.toString().contains('401') ||
            error.toString().contains('unauthorized') ||
            error.toString().contains('Missing scope')) {
          // ignore: avoid_print
          print('✅ Appwrite connection successful (not authenticated)');
        } else {
          rethrow;
        }
      }

      // ignore: avoid_print
      print('📦 Project: $projectName ($projectId)');
      // ignore: avoid_print
      print('🌐 Endpoint: $endpoint');
    } catch (e) {
      // ignore: avoid_print
      print('❌ Appwrite connection failed: $e');
      rethrow;
    }
  }
}
