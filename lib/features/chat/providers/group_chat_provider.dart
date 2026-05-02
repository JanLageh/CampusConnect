import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/group_chat_service.dart';
import '../data/datasources/firestore_group_chat_datasource.dart';
import '../data/repositories/group_chat_repository_impl.dart';
import '../domain/entities/group_chat.dart';

/// Provider for GroupChatService.
final groupChatServiceProvider = Provider<GroupChatService>((ref) {
  final dataSource = FirestoreGroupChatDataSource();
  final repository = GroupChatRepositoryImpl(dataSource: dataSource);
  return GroupChatService(repository: repository);
});

/// Provider for fetching user's group chats.
final userGroupChatsProvider = FutureProvider.family<List<GroupChat>, String>((
  ref,
  userId,
) async {
  final service = ref.watch(groupChatServiceProvider);
  return await service.getUserChats(userId);
});

/// Provider for fetching a single group chat by ID.
final groupChatByIdProvider = FutureProvider.family<GroupChat, String>((
  ref,
  chatId,
) async {
  final service = ref.watch(groupChatServiceProvider);
  return await service.getGroupChatById(chatId);
});
