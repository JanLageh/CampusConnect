import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/announcement_entity.dart';

/// Data model for announcements with Firestore serialization
class AnnouncementModel {
  final String id;
  final String title;
  final String body;
  final String category;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String? authorDepartment;
  final bool isUrgent;
  final bool isPinned;
  final List<String> targetAudience;
  final String? attachmentUrl;
  final String? attachmentType;
  final String? ctaLabel;
  final String? ctaUrl;

  const AnnouncementModel({
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

  /// Create model from Firestore document
  factory AnnouncementModel.fromJson(Map<String, dynamic> json, String id) {
    return AnnouncementModel(
      id: id,
      title: json['title'] as String,
      body: json['body'] as String,
      category: json['category'] as String,
      tags: List<String>.from(json['tags'] as List? ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      authorDepartment: json['authorDepartment'] as String?,
      isUrgent: json['isUrgent'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      targetAudience: List<String>.from(json['targetAudience'] as List? ?? []),
      attachmentUrl: json['attachmentUrl'] as String?,
      attachmentType: json['attachmentType'] as String?,
      ctaLabel: json['ctaLabel'] as String?,
      ctaUrl: json['ctaUrl'] as String?,
    );
  }

  /// Convert model to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'category': category,
      'tags': tags,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatarUrl': authorAvatarUrl,
      'authorDepartment': authorDepartment,
      'isUrgent': isUrgent,
      'isPinned': isPinned,
      'targetAudience': targetAudience,
      'attachmentUrl': attachmentUrl,
      'attachmentType': attachmentType,
      'ctaLabel': ctaLabel,
      'ctaUrl': ctaUrl,
    };
  }

  /// Convert model to domain entity
  AnnouncementEntity toEntity() {
    return AnnouncementEntity(
      id: id,
      title: title,
      body: body,
      category: category,
      tags: tags,
      createdAt: createdAt,
      updatedAt: updatedAt,
      authorId: authorId,
      authorName: authorName,
      authorAvatarUrl: authorAvatarUrl,
      authorDepartment: authorDepartment,
      isUrgent: isUrgent,
      isPinned: isPinned,
      targetAudience: targetAudience,
      attachmentUrl: attachmentUrl,
      attachmentType: attachmentType,
      ctaLabel: ctaLabel,
      ctaUrl: ctaUrl,
    );
  }

  /// Create model from domain entity
  factory AnnouncementModel.fromEntity(AnnouncementEntity entity) {
    return AnnouncementModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      category: entity.category,
      tags: entity.tags,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      authorId: entity.authorId,
      authorName: entity.authorName,
      authorAvatarUrl: entity.authorAvatarUrl,
      authorDepartment: entity.authorDepartment,
      isUrgent: entity.isUrgent,
      isPinned: entity.isPinned,
      targetAudience: entity.targetAudience,
      attachmentUrl: entity.attachmentUrl,
      attachmentType: entity.attachmentType,
      ctaLabel: entity.ctaLabel,
      ctaUrl: entity.ctaUrl,
    );
  }
}
