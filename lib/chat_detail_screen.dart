import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  ChatMessage({required this.text, required this.isMe, required this.time});
}

class ChatDetailScreen extends StatefulWidget {
  final String chatTitle;
  final Color chatColor;
  final IconData chatIcon;

  const ChatDetailScreen({
    super.key,
    required this.chatTitle,
    required this.chatColor,
    required this.chatIcon,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'Hello! Are we still meeting tomorrow?', isMe: false, time: '10:30 AM'),
    ChatMessage(text: 'Yes, same place.', isMe: true, time: '10:35 AM'),
    ChatMessage(text: 'Does anyone have the notes from last week?', isMe: false, time: '10:42 AM'),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: _messageController.text.trim(),
            isMe: true,
            time: _formatTime(DateTime.now()),
          ),
        );
      });
      _messageController.clear();
    }
  }

  String _formatTime(DateTime time) {
    int hour = time.hour;
    int minute = time.minute;
    String period = 'AM';
    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) hour -= 12;
    }
    if (hour == 0) hour = 12;
    String minuteStr = minute < 10 ? '0$minute' : minute.toString();
    return '$hour:$minuteStr $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: widget.chatColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.chatIcon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.chatTitle,
                style: const TextStyle(
                  color: Color(0xFF091C31),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
            
            // Input Area
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: Colors.grey.shade500),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        filled: true,
                        fillColor: const Color(0xFFF3F4F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF007A75),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: widget.chatColor.withOpacity(0.2),
              child: Icon(Icons.person, size: 16, color: widget.chatColor),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isMe ? const Color(0xFF007A75) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isMe ? 16 : 4),
                  bottomRight: Radius.circular(message.isMe ? 4 : 16),
                ),
                boxShadow: [
                  if (!message.isMe)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    )
                ],
              ),
              child: Column(
                crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMe ? Colors.white : const Color(0xFF1F2937),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.time,
                    style: TextStyle(
                      color: message.isMe ? Colors.white70 : Colors.grey.shade500,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isMe) ...[
            const SizedBox(width: 8),
            // Optional: User Avatar for their own messages
            // CircleAvatar(
            //   radius: 16,
            //   backgroundColor: Colors.grey.shade200,
            //   child: const Icon(Icons.person, size: 16, color: Colors.grey),
            // ),
          ],
        ],
      ),
    );
  }
}
