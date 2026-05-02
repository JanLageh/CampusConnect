import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/announcement_model.dart';
import '../../domain/exceptions/announcement_exceptions.dart';

class AnnouncementFirestoreDataSource {
  final FirebaseFirestore _firestore;

  AnnouncementFirestoreDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get announcements stream filtered by user roles and optional category
  /// Returns real-time updates via Firestore snapshots
  /// Admins and moderators see all announcements regardless of targetAudience
  Stream<List<AnnouncementModel>> getAnnouncementsStream({
    required List<String> userRoles,
    String? category,
    int limit = 50,
  }) {
    try {
      // Check if user is admin or moderator
      final isAdmin =
          userRoles.contains('admin') || userRoles.contains('moderator');

      Query<Map<String, dynamic>> query = _firestore
          .collection('announcements')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      // Only filter by targetAudience if user is not admin/moderator
      if (!isAdmin && userRoles.isNotEmpty) {
        query = _firestore
            .collection('announcements')
            .where('targetAudience', arrayContainsAny: userRoles)
            .orderBy('createdAt', descending: true)
            .limit(limit);
      }

      if (category != null && category.isNotEmpty && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          try {
            return AnnouncementModel.fromJson(doc.data(), doc.id);
          } catch (e) {
            developer.log(
              'Error parsing announcement ${doc.id}: $e',
              name: 'AnnouncementFirestoreDataSource',
            );
            rethrow;
          }
        }).toList();
      });
    } catch (e) {
      developer.log(
        'Error creating announcements stream: $e',
        name: 'AnnouncementFirestoreDataSource',
      );
      throw AnnouncementNetworkException(
        message: 'Failed to fetch announcements',
        originalError: e,
      );
    }
  }

  /// Get a single announcement by ID
  Future<AnnouncementModel> getAnnouncementById(String id) async {
    try {
      final doc = await _firestore.collection('announcements').doc(id).get();

      if (!doc.exists) {
        throw const AnnouncementNotFoundException();
      }

      return AnnouncementModel.fromJson(doc.data()!, doc.id);
    } catch (e) {
      if (e is AnnouncementNotFoundException) {
        rethrow;
      }
      developer.log(
        'Error fetching announcement $id: $e',
        name: 'AnnouncementFirestoreDataSource',
      );
      throw AnnouncementNetworkException(
        message: 'Failed to fetch announcement',
        originalError: e,
      );
    }
  }

  /// Create a new announcement
  Future<void> createAnnouncement(AnnouncementModel announcement) async {
    try {
      await _firestore
          .collection('announcements')
          .doc(announcement.id)
          .set(announcement.toJson());
    } catch (e) {
      developer.log(
        'Error creating announcement: $e',
        name: 'AnnouncementFirestoreDataSource',
      );
      throw AnnouncementNetworkException(
        message: 'Failed to create announcement',
        originalError: e,
      );
    }
  }

  /// Update an existing announcement
  Future<void> updateAnnouncement(AnnouncementModel announcement) async {
    try {
      await _firestore
          .collection('announcements')
          .doc(announcement.id)
          .update(announcement.toJson());
    } catch (e) {
      developer.log(
        'Error updating announcement: $e',
        name: 'AnnouncementFirestoreDataSource',
      );
      throw AnnouncementNetworkException(
        message: 'Failed to update announcement',
        originalError: e,
      );
    }
  }

  /// Delete an announcement
  Future<void> deleteAnnouncement(String id) async {
    try {
      await _firestore.collection('announcements').doc(id).delete();
    } catch (e) {
      developer.log(
        'Error deleting announcement: $e',
        name: 'AnnouncementFirestoreDataSource',
      );
      throw AnnouncementNetworkException(
        message: 'Failed to delete announcement',
        originalError: e,
      );
    }
  }
}
