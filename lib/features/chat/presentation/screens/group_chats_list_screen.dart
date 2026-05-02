import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/group_chat_provider.dart';
import 'group_chat_detail_screen.dart';

/// Screen displaying the list of group chats for the current user.
class GroupChatsListScreen extends ConsumerWidget {
  final String userId;

  const GroupChatsListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupChatsAsync = ref.watch(userGroupChatsProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('Group Chats')),
      body: groupChatsAsync.when(
        data: (groupChats) {
          if (groupChats.isEmpty) {
            return const Center(
              child: Text(
                'No group chats yet.\nJoin or create a group to start chatting!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: groupChats.length,
            itemBuilder: (context, index) {
              final chat = groupChats[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    chat.name.isNotEmpty ? chat.name[0].toUpperCase() : '?',
                  ),
                ),
                title: Text(chat.name),
                subtitle: chat.description != null
                    ? Text(
                        chat.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text('${chat.memberIds.length} members'),
                trailing: chat.isPublic
                    ? const Icon(Icons.public, size: 16)
                    : const Icon(Icons.lock, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupChatDetailScreen(
                        chatId: chat.id,
                        chatName: chat.name,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Failed to load chats',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
