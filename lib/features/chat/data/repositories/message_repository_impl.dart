import '../../domain/entities/message.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/firestore_message_datasource.dart';

/// Implementation of MessageRepository using Firestore.
class MessageRepositoryImpl implements MessageRepository {
  final FirestoreMessageDataSource _dataSource;

  MessageRepositoryImpl({required FirestoreMessageDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Stream<List<Message>> streamMessages(String chatId, {int limit = 50}) {
    return _dataSource.streamMessages(chatId, limit: limit);
  }

  @override
  Future<Message> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String content,
    String? attachmentUrl,
  }) async {
    return await _dataSource.sendMessage(
      chatId: chatId,
      senderId: senderId,
      senderName: senderName,
      content: content,
      attachmentUrl: attachmentUrl,
    );
  }

  @override
  Future<void> deleteMessage(String chatId, String messageId) async {
    await _dataSource.deleteMessage(chatId, messageId);
  }
}
