import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/appwrite_storage_service.dart';

/// Provider for Appwrite Storage Service
final appwriteStorageServiceProvider = Provider<AppwriteStorageService>((ref) {
  return AppwriteStorageService();
});
