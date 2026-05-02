import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/message_service.dart';
import '../data/datasources/firestore_message_datasource.dart';
import '../data/repositories/message_repository_impl.dart';
import '../domain/entities/message.dart';

/// Provider for MessageService.
final messageServiceProvider = Provider<MessageService>((ref) {
  final dataSource = FirestoreMessageDataSource();
  final repository = MessageRepositoryImpl(dataSource: dataSource);
  return MessageService(repository: repository);
});

/// Provider for streaming messages for a specific chat.
final messagesStreamProvider = StreamProvider.family<List<Message>, String>((
  ref,
  chatId,
) {
  final service = ref.watch(messageServiceProvider);
  return service.streamMessages(chatId);
});
