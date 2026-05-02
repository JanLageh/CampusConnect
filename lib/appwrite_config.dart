import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Appwrite project configuration
class AppwriteConfig {
  static String get projectId => dotenv.env['APPWRITE_PROJECT_ID'] ?? '';
  static String get projectName => dotenv.env['APPWRITE_PROJECT_NAME'] ?? '';
  static String get endpoint => dotenv.env['APPWRITE_ENDPOINT'] ?? '';
  static String get chatAttachmentsBucketId =>
      dotenv.env['APPWRITE_CHAT_ATTACHMENTS_BUCKET_ID'] ?? 'chat_attachments';

  // Reuse chat_attachments bucket for announcements (free tier has 1 bucket limit)
  static String get announcementAttachmentsBucketId => chatAttachmentsBucketId;

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
        print('Appwrite connection successful - User authenticated');
      } catch (error) {
        // If we get a 401, connection still works but user not logged in
        if (error.toString().contains('401') ||
            error.toString().contains('unauthorized') ||
            error.toString().contains('Missing scope')) {
          // ignore: avoid_print
          print('Appwrite connection successful (not authenticated)');
        } else {
          rethrow;
        }
      }

      // ignore: avoid_print
      print('Project: $projectName ($projectId)');
      // ignore: avoid_print
      print('Endpoint: $endpoint');
    } catch (e) {
      // ignore: avoid_print
      print('Appwrite connection failed: $e');
      rethrow;
    }
  }

  /// Call this after Firebase sign-in. Creates an anonymous session so that
  /// Appwrite recognises the device as a "User" and permits file uploads to
  /// buckets that require the Users role.
  ///
  /// If a session already exists the method is a no-op.
  static Future<void> ensureSession() async {
    try {
      // If a session already exists this will succeed — nothing to do.
      await account.get();
      // ignore: avoid_print
      print('Appwrite session already active');
    } on AppwriteException catch (e) {
      // 401 means no active session — create an anonymous one.
      if (e.code == 401) {
        try {
          await account.createAnonymousSession();
          // ignore: avoid_print
          print('Appwrite anonymous session created');
        } catch (createError) {
          // ignore: avoid_print
          print('Appwrite session creation failed: $createError');
        }
      } else {
        // ignore: avoid_print
        print('Appwrite session check failed: $e');
      }
    }
  }

  /// Deletes the current Appwrite session.
  ///
  /// Call this on Firebase sign-out to keep the two auth states in sync.
  static Future<void> deleteSession() async {
    try {
      await account.deleteSession(sessionId: 'current');
      // ignore: avoid_print
      print('Appwrite session deleted');
    } catch (e) {
      // ignore: avoid_print
      print('Appwrite session deletion failed (may already be gone): $e');
    }
  }
}
