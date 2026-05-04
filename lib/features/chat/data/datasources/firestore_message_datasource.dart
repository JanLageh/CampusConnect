import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

/// Firestore data source for message operations.
class FirestoreMessageDataSource {
  final FirebaseFirestore _firestore;

  FirestoreMessageDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Streams messages for a specific chat in real-time.
  Stream<List<MessageModel>> streamMessages(String chatId, {int limit = 50}) {
    try {
      return _firestore
          .collection('groupChats')
          .doc(chatId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => MessageModel.fromFirestore(doc, chatId))
                .toList(),
          );
    } catch (e) {
      throw Exception('Failed to stream messages: $e');
    }
  }

  /// Sends a new message to a chat.
  Future<MessageModel> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String content,
    String? attachmentUrl,
  }) async {
    try {
      final now = DateTime.now();
      final docRef = await _firestore
          .collection('groupChats')
          .doc(chatId)
          .collection('messages')
          .add({
            'senderId': senderId,
            'senderName': senderName,
            'content': content,
            'attachmentUrl': attachmentUrl,
            'isDeleted': false,
            'createdAt': Timestamp.fromDate(now),
          });

      final doc = await docRef.get();
      return MessageModel.fromFirestore(doc, chatId);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Soft-deletes a message (sets isDeleted to true).
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _firestore
          .collection('groupChats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({'isDeleted': true});
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }
}
