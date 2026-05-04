import '../entities/group_chat.dart';

/// Repository interface for group chat operations.
abstract class GroupChatRepository {
  /// Fetches all group chats where the user is a member.
  Future<List<GroupChat>> getUserChats(String userId);

  /// Creates a new group chat.
  Future<GroupChat> createGroupChat({
    required String name,
    String? description,
    required List<String> memberIds,
    required String creatorId,
    required bool isPublic,
  });

  /// Fetches a single group chat by ID.
  Future<GroupChat> getGroupChatById(String chatId);

  /// Adds members to an existing group chat.
  Future<void> addMembers(String chatId, List<String> memberIds);
}
