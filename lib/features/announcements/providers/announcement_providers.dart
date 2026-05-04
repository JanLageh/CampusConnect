import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data Sources
import '../data/datasources/announcement_firestore_ds.dart';

// Repositories
import '../domain/repositories/announcement_repository.dart';
import '../data/repositories/announcement_repo_impl.dart';

// Application Services
import '../application/announcement_service.dart';

// Import auth providers to get user info and firestore instance
import '../../../providers/auth_providers.dart';

// ============================================================================
// Data Sources
// ============================================================================

/// Provider for AnnouncementFirestoreDataSource
final announcementFirestoreDataSourceProvider =
    Provider<AnnouncementFirestoreDataSource>((ref) {
      final firestore = ref.watch(firebaseFirestoreProvider);
      return AnnouncementFirestoreDataSource(firestore: firestore);
    });

// ============================================================================
// Repositories
// ============================================================================

/// Provider for AnnouncementRepository
final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  final dataSource = ref.watch(announcementFirestoreDataSourceProvider);
  return AnnouncementRepositoryImpl(dataSource: dataSource);
});

// ============================================================================
// Application Services
// ============================================================================

/// Provider for the announcement application service
final announcementServiceProvider = Provider<AnnouncementService>((ref) {
  final repository = ref.watch(announcementRepositoryProvider);
  return AnnouncementService(repository: repository);
});
