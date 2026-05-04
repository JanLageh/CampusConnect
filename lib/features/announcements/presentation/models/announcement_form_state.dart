import 'package:equatable/equatable.dart';

/// Form state model for announcement creation and editing
class AnnouncementFormState extends Equatable {
  // Step 1: Basics
  final String title;
  final String body;
  final bool isUrgent;
  final bool isPinned;

  // Step 2: Targeting
  final String? categoryId;
  final String? categoryName;
  final List<String> targetAudience; // ['student', 'faculty'] - admins see all

  // Step 3: Extras
  final List<String> tags;
  final String? attachmentUrl;
  final String? ctaLabel;
  final String? ctaUrl;

  // Form metadata
  final int currentStep;
  final bool isLoading;
  final String? errorMessage;

  const AnnouncementFormState({
    this.title = '',
    this.body = '',
    this.isUrgent = false,
    this.isPinned = false,
    this.categoryId,
    this.categoryName,
    this.targetAudience = const [],
    this.tags = const [],
    this.attachmentUrl,
    this.ctaLabel,
    this.ctaUrl,
    this.currentStep = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  AnnouncementFormState copyWith({
    String? title,
    String? body,
    bool? isUrgent,
    bool? isPinned,
    String? categoryId,
    String? categoryName,
    List<String>? targetAudience,
    List<String>? tags,
    String? attachmentUrl,
    String? ctaLabel,
    String? ctaUrl,
    int? currentStep,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AnnouncementFormState(
      title: title ?? this.title,
      body: body ?? this.body,
      isUrgent: isUrgent ?? this.isUrgent,
      isPinned: isPinned ?? this.isPinned,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      targetAudience: targetAudience ?? this.targetAudience,
      tags: tags ?? this.tags,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      ctaLabel: ctaLabel ?? this.ctaLabel,
      ctaUrl: ctaUrl ?? this.ctaUrl,
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Clear nullable fields (for removing attachment, CTA, etc.)
  AnnouncementFormState clearAttachment() {
    return copyWith(attachmentUrl: '');
  }

  AnnouncementFormState clearCTA() {
    return copyWith(ctaLabel: '', ctaUrl: '');
  }

  AnnouncementFormState clearError() {
    return copyWith(errorMessage: '');
  }

  /// Validation methods
  bool get isStep1Valid {
    return title.trim().isNotEmpty &&
        body.trim().isNotEmpty &&
        body.length <= 500;
  }

  bool get isStep2Valid {
    return categoryId != null &&
        categoryId!.isNotEmpty &&
        targetAudience.isNotEmpty;
  }

  bool get isStep3Valid {
    // Step 3 is optional, always valid
    // But if CTA fields are present, both must be filled
    if (isPinned && (ctaLabel != null || ctaUrl != null)) {
      return (ctaLabel?.trim().isNotEmpty ?? false) &&
          (ctaUrl?.trim().isNotEmpty ?? false);
    }
    return true;
  }

  bool get isFormValid {
    return isStep1Valid && isStep2Valid && isStep3Valid;
  }

  /// Convert to JSON for draft persistence
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'isUrgent': isUrgent,
      'isPinned': isPinned,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'targetAudience': targetAudience,
      'tags': tags,
      'attachmentUrl': attachmentUrl,
      'ctaLabel': ctaLabel,
      'ctaUrl': ctaUrl,
      'currentStep': currentStep,
    };
  }

  /// Create from JSON for draft restoration
  factory AnnouncementFormState.fromJson(Map<String, dynamic> json) {
    return AnnouncementFormState(
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      isUrgent: json['isUrgent'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      targetAudience:
          (json['targetAudience'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      attachmentUrl: json['attachmentUrl'] as String?,
      ctaLabel: json['ctaLabel'] as String?,
      ctaUrl: json['ctaUrl'] as String?,
      currentStep: json['currentStep'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    title,
    body,
    isUrgent,
    isPinned,
    categoryId,
    categoryName,
    targetAudience,
    tags,
    attachmentUrl,
    ctaLabel,
    ctaUrl,
    currentStep,
    isLoading,
    errorMessage,
  ];
}
