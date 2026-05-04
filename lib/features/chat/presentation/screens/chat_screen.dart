import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/auth_providers.dart';
import 'group_chats_list_screen.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);

    if (authState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authState.user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view chats')),
      );
    }

    return GroupChatsListScreen(userId: authState.user!.userId);
  }
}
