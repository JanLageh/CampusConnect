import 'package:equatable/equatable.dart';

/// Domain entity representing an announcement with denormalized author data
class AnnouncementEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final String category; // e.g., "Campus", "Academic", "Events"
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Denormalized author data to avoid N+1 reads
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String? authorDepartment;

  // UI flags
  final bool isUrgent;
  final bool isPinned;

  // Audience targeting
  final List<String> targetAudience; // e.g., ["student", "faculty", "admin"]

  // Optional attachment (Appwrite storage)
  final String? attachmentUrl;
  final String? attachmentType; // e.g., "image", "pdf"

  // Optional CTA for pinned announcements
  final String? ctaLabel;
  final String? ctaUrl;

  const AnnouncementEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.tags,
    required this.createdAt,
    this.updatedAt,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    this.authorDepartment,
    this.isUrgent = false,
    this.isPinned = false,
    required this.targetAudience,
    this.attachmentUrl,
    this.attachmentType,
    this.ctaLabel,
    this.ctaUrl,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    category,
    tags,
    createdAt,
    updatedAt,
    authorId,
    authorName,
    authorAvatarUrl,
    authorDepartment,
    isUrgent,
    isPinned,
    targetAudience,
    attachmentUrl,
    attachmentType,
    ctaLabel,
    ctaUrl,
  ];
}
