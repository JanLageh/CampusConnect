import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/announcement_entity.dart';
import '../../providers/announcement_providers.dart';
import '../../../../providers/auth_providers.dart';

// ============================================================================
// Category Filter State
// ============================================================================

/// Notifier for managing active announcement category filter
class AnnouncementCategoryNotifier extends Notifier<String> {
  @override
  String build() {
    return 'All'; // Default to showing all categories
  }

  /// Set the active category filter
  void setCategory(String category) {
    state = category;
  }

  /// Reset to show all categories
  void reset() {
    state = 'All';
  }
}

/// Provider for announcement category filter
final announcementCategoryProvider =
    NotifierProvider<AnnouncementCategoryNotifier, String>(
      AnnouncementCategoryNotifier.new,
    );

// ============================================================================
// Announcements Stream
// ============================================================================

/// StreamProvider for announcements feed
/// Automatically filters based on current user's roles and selected category
final announcementsStreamProvider = StreamProvider<List<AnnouncementEntity>>((
  ref,
) {
  final service = ref.watch(announcementServiceProvider);
  final user = ref.watch(currentUserProvider);
  final category = ref.watch(announcementCategoryProvider);

  // If user is not authenticated, return empty stream
  if (user == null) {
    return Stream.value([]);
  }

  // Get user roles from user entity
  final userRoles = [user.role];

  // Return filtered stream based on category
  return service.getAnnouncementsStream(
    userId: user.userId,
    userRoles: userRoles,
    category: category == 'All' ? null : category,
    limit: 50,
  );
});

// ============================================================================
// Convenience Providers
// ============================================================================

/// Provider to get pinned announcements from the stream
final pinnedAnnouncementsProvider = Provider<List<AnnouncementEntity>>((ref) {
  final announcementsAsync = ref.watch(announcementsStreamProvider);

  return announcementsAsync.when(
    data: (announcements) => announcements.where((a) => a.isPinned).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
});

/// Provider to get urgent announcements from the stream
final urgentAnnouncementsProvider = Provider<List<AnnouncementEntity>>((ref) {
  final announcementsAsync = ref.watch(announcementsStreamProvider);

  return announcementsAsync.when(
    data: (announcements) =>
        announcements.where((a) => a.isUrgent && !a.isPinned).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
});

/// Provider to get standard announcements from the stream
final standardAnnouncementsProvider = Provider<List<AnnouncementEntity>>((ref) {
  final announcementsAsync = ref.watch(announcementsStreamProvider);

  return announcementsAsync.when(
    data: (announcements) =>
        announcements.where((a) => !a.isUrgent && !a.isPinned).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
});

/// Provider to get available categories from current announcements
final availableCategoriesProvider = Provider<List<String>>((ref) {
  final announcementsAsync = ref.watch(announcementsStreamProvider);

  return announcementsAsync.when(
    data: (announcements) {
      // If no announcements, return empty list (hide filters)
      if (announcements.isEmpty) {
        return [];
      }

      final categories = announcements.map((a) => a.category).toSet().toList();
      categories.sort();
      return ['All', ...categories];
    },
    loading: () => [],
    error: (_, _) => [],
  );
});
