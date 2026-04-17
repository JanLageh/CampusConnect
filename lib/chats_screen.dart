import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  final Color primaryDarkBlue = const Color(0xFF091C31);
  final Color secondaryTeal = const Color(0xFF007A75);
  final Color fieldBackground = const Color(0xFFF3F4F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF006B65),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: const Icon(Icons.group_add, color: Colors.white),
        label: const Text(
          "New Group",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(Icons.person, color: Colors.grey.shade500),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Group Chats",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryDarkBlue,
                    ),
                  ),
                ],
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                  filled: true,
                  fillColor: fieldBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            
            // Recent Conversations Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RECENT CONVERSATIONS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade500,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "3 New",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: secondaryTeal,
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            // Chat List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  _buildChatItem(
                    context: context,
                    title: "Bio-Chemistry Study Group",
                    subtitle: "Sarah: Does anyone have the...",
                    time: "10:42 AM",
                    unreadCount: 2,
                    color: primaryDarkBlue,
                    icon: Icons.science,
                  ),
                  _buildChatItem(
                    context: context,
                    title: "CS Project",
                    subtitle: "Alex: Just pushed the latest...",
                    time: "8:15 AM",
                    unreadCount: 1,
                    color: const Color(0xFF1F2937),
                    icon: Icons.computer,
                  ),
                  _buildChatItem(
                    context: context,
                    title: "Tennis Club",
                    subtitle: "Marcus: Great practice today...",
                    time: "Yesterday",
                    unreadCount: 0,
                    color: const Color(0xFF2E6152),
                    icon: Icons.sports_tennis,
                  ),
                  _buildChatItem(
                    context: context,
                    title: "Ethics in AI Seminar",
                    subtitle: "You: I'll share the reading list later...",
                    time: "Monday",
                    unreadCount: 0,
                    color: const Color(0xFF4A403A),
                    icon: Icons.psychology,
                  ),
                  _buildChatItem(
                    context: context,
                    title: "Campus Housing",
                    subtitle: "Admin: Maintenance will be checkin...",
                    time: "2 days ago",
                    unreadCount: 0,
                    color: const Color(0xFF5E543D),
                    icon: Icons.house,
                  ),
                  const SizedBox(height: 80), // Padding for FAB and BottomNav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String time,
    required int unreadCount,
    required Color color,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              chatTitle: title,
              chatColor: color,
              chatIcon: icon,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              if (unreadCount > 0)
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.green.shade500,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                )
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryDarkBlue,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: unreadCount > 0 ? Colors.grey.shade800 : Colors.grey.shade500,
                          fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF007A75),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
