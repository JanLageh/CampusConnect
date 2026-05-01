import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/announcement_entity.dart';

/// Pinned announcement card with prominent background and CTA button
class PinnedAnnouncementCard extends StatelessWidget {
  final AnnouncementEntity announcement;
  final VoidCallback? onTap;

  const PinnedAnnouncementCard({
    required this.announcement,
    this.onTap,
    super.key,
  });

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.primaryContainer.withOpacity(0.7),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pin badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.push_pin_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'PINNED',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        announcement.category,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Header: Author info
                Row(
                  children: [
                    // Author avatar
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: theme.colorScheme.surface,
                      backgroundImage: announcement.authorAvatarUrl != null
                          ? NetworkImage(announcement.authorAvatarUrl!)
                          : null,
                      child: announcement.authorAvatarUrl == null
                          ? Text(
                              announcement.authorName[0].toUpperCase(),
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    // Author name and department
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            announcement.authorName,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          if (announcement.authorDepartment != null)
                            Text(
                              announcement.authorDepartment!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer
                                    .withOpacity(0.7),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  announcement.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 12),
                // Body
                Text(
                  announcement.body,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withOpacity(
                      0.9,
                    ),
                    height: 1.6,
                  ),
                ),
                // Attachment preview
                if (announcement.attachmentUrl != null) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      announcement.attachmentUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: theme.colorScheme.surface,
                          child: Icon(
                            Icons.image_not_supported,
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                // CTA Button
                if (announcement.ctaLabel != null &&
                    announcement.ctaUrl != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _launchUrl(announcement.ctaUrl!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            announcement.ctaLabel!,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                // Footer: Tags and timestamp
                Row(
                  children: [
                    // Tags
                    if (announcement.tags.isNotEmpty)
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: announcement.tags.take(3).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface.withOpacity(
                                  0.8,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '#$tag',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    // Timestamp
                    Text(
                      dateFormat.format(announcement.createdAt),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer.withOpacity(
                          0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
