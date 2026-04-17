import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Chats')),
      body: const Center(
        child: Text('Chat Placeholder\nTODO: Implement real-time messaging', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
