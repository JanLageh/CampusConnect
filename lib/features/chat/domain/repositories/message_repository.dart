import '../entities/message.dart';

/// Repository interface for message operations.
abstract class MessageRepository {
  /// Streams messages for a specific chat in real-time.
  Stream<List<Message>> streamMessages(String chatId, {int limit = 50});

  /// Sends a new message to a chat.
  Future<Message> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String content,
    String? attachmentUrl,
  });

  /// Soft-deletes a message (sets isDeleted to true).
  Future<void> deleteMessage(String chatId, String messageId);
}
