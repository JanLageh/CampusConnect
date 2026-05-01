import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/announcement_providers.dart';
import '../widgets/standard_announcement_card.dart';
import '../widgets/urgent_announcement_card.dart';
import '../widgets/pinned_announcement_card.dart';

class AnnouncementsScreen extends ConsumerWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(announcementsStreamProvider);
    final selectedCategory = ref.watch(announcementCategoryProvider);
    final availableCategories = ref.watch(availableCategoriesProvider);
    final theme = Theme.of(context);

    // Hide filter chips when loading
    final showFilters = announcementsAsync.hasValue;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with category filter chips
          SliverAppBar(
            floating: true,
            snap: true,
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            title: Text(
              'Announcements',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            bottom: showFilters
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: availableCategories.map((category) {
                            final isSelected = category == selectedCategory;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(category),
                                selected: isSelected,
                                onSelected: (_) {
                                  ref
                                      .read(
                                        announcementCategoryProvider.notifier,
                                      )
                                      .setCategory(category);
                                },
                                backgroundColor: theme.colorScheme.surface,
                                selectedColor:
                                    theme.colorScheme.primaryContainer,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? theme.colorScheme.onPrimaryContainer
                                      : theme.colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.outline.withOpacity(
                                            0.3,
                                          ),
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
          // Announcements list
          announcementsAsync.when(
            data: (announcements) {
              if (announcements.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          size: 64,
                          color: theme.colorScheme.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No announcements yet',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check back later for updates',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Separate announcements by type
              final pinnedAnnouncements = announcements
                  .where((a) => a.isPinned)
                  .toList();
              final urgentAnnouncements = announcements
                  .where((a) => a.isUrgent && !a.isPinned)
                  .toList();
              final standardAnnouncements = announcements
                  .where((a) => !a.isUrgent && !a.isPinned)
                  .toList();

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Calculate which announcement to show based on index
                    if (index < pinnedAnnouncements.length) {
                      return PinnedAnnouncementCard(
                        announcement: pinnedAnnouncements[index],
                      );
                    }

                    final urgentIndex = index - pinnedAnnouncements.length;
                    if (urgentIndex < urgentAnnouncements.length) {
                      return UrgentAnnouncementCard(
                        announcement: urgentAnnouncements[urgentIndex],
                      );
                    }

                    final standardIndex =
                        urgentIndex - urgentAnnouncements.length;
                    if (standardIndex < standardAnnouncements.length) {
                      return StandardAnnouncementCard(
                        announcement: standardAnnouncements[standardIndex],
                      );
                    }

                    // Add bottom padding after last item
                    return const SizedBox(height: 16);
                  },
                  childCount:
                      pinnedAnnouncements.length +
                      urgentAnnouncements.length +
                      standardAnnouncements.length +
                      1, // +1 for bottom padding
                ),
              );
            },
            loading: () => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Loading announcements...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load announcements',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(announcementsStreamProvider);
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
