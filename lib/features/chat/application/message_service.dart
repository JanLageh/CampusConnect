import '../domain/entities/message.dart';
import '../domain/repositories/message_repository.dart';

/// Service layer for message operations.
class MessageService {
  final MessageRepository _repository;

  MessageService({required MessageRepository repository})
    : _repository = repository;

  /// Streams messages for a specific chat in real-time.
  Stream<List<Message>> streamMessages(String chatId, {int limit = 50}) {
    try {
      return _repository.streamMessages(chatId, limit: limit);
    } catch (e) {
      throw Exception('Failed to stream messages: $e');
    }
  }

  /// Sends a new message to a chat.
  Future<Message> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String content,
    String? attachmentUrl,
  }) async {
    try {
      return await _repository.sendMessage(
        chatId: chatId,
        senderId: senderId,
        senderName: senderName,
        content: content,
        attachmentUrl: attachmentUrl,
      );
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Soft-deletes a message (sets isDeleted to true).
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _repository.deleteMessage(chatId, messageId);
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }
}
