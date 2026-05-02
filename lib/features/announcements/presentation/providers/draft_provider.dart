import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/announcement_form_state.dart';

/// Service for persisting announcement drafts to SharedPreferences
class DraftService {
  static const String _draftKey = 'announcement_draft';

  /// Save draft to SharedPreferences
  Future<void> saveDraft(AnnouncementFormState state) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(state.toJson());
      await prefs.setString(_draftKey, json);
    } catch (e) {
      // Silently fail - draft saving is not critical
      // ignore: avoid_print
      print('Failed to save draft: $e');
    }
  }

  /// Load draft from SharedPreferences
  Future<AnnouncementFormState?> loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_draftKey);

      if (jsonString == null) {
        return null;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AnnouncementFormState.fromJson(json);
    } catch (e) {
      // Silently fail and return null
      // ignore: avoid_print
      print('Failed to load draft: $e');
      return null;
    }
  }

  /// Delete draft from SharedPreferences
  Future<void> deleteDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_draftKey);
    } catch (e) {
      // Silently fail
      // ignore: avoid_print
      print('Failed to delete draft: $e');
    }
  }

  /// Check if draft exists
  Future<bool> hasDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_draftKey);
    } catch (e) {
      return false;
    }
  }
}

/// Provider for DraftService
final draftServiceProvider = Provider<DraftService>((ref) {
  return DraftService();
});

/// Provider for checking if draft exists
final hasDraftProvider = FutureProvider<bool>((ref) async {
  final draftService = ref.watch(draftServiceProvider);
  return await draftService.hasDraft();
});
