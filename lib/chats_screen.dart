import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final Color primaryDarkBlue = const Color(0xFF091C31);
  final Color secondaryTeal = const Color(0xFF007A75);
  final Color fieldBackground = const Color(0xFFF3F4F6);

  String _searchQuery = "";

  final List<Map<String, dynamic>> _allChats = [
    {
      "title": "Bio-Chemistry Study Group",
      "subtitle": "Sarah: Does anyone have the...",
      "time": "10:42 AM",
      "unreadCount": 2,
      "color": const Color(0xFF091C31),
      "icon": Icons.science,
      "imageUrl": "https://picsum.photos/seed/bio/200/200"
    },
    {
      "title": "CS Project",
      "subtitle": "Alex: Just pushed the latest...",
      "time": "8:15 AM",
      "unreadCount": 1,
      "color": const Color(0xFF1F2937),
      "icon": Icons.computer,
      "imageUrl": "https://picsum.photos/seed/cs/200/200"
    },
    {
      "title": "Tennis Club",
      "subtitle": "Marcus: Great practice today...",
      "time": "Yesterday",
      "unreadCount": 0,
      "color": const Color(0xFF2E6152),
      "icon": Icons.sports_tennis,
      "imageUrl": "https://picsum.photos/seed/tennis/200/200"
    },
    {
      "title": "Ethics in AI Seminar",
      "subtitle": "You: I'll share the reading list later...",
      "time": "Monday",
      "unreadCount": 0,
      "color": const Color(0xFF4A403A),
      "icon": Icons.psychology,
      "imageUrl": "https://picsum.photos/seed/ethics/200/200"
    },
    {
      "title": "Campus Housing",
      "subtitle": "Admin: Maintenance will be checkin...",
      "time": "2 days ago",
      "unreadCount": 0,
      "color": const Color(0xFF5E543D),
      "icon": Icons.house,
      "imageUrl": "https://picsum.photos/seed/house/200/200"
    },
  ];

  void _showNewGroupModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Create New Group",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryDarkBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: "Group Name",
                  filled: true,
                  fillColor: fieldBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Create", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewGroupModal(context),
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
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
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
              child: Builder(
                builder: (context) {
                  final filteredChats = _allChats.where((chat) {
                    final title = chat["title"].toString().toLowerCase();
                    return title.contains(_searchQuery.toLowerCase());
                  }).toList();

                  if (filteredChats.isEmpty) {
                    return Center(
                      child: Text(
                        "No conversations found.",
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: filteredChats.length + 1,
                    itemBuilder: (context, index) {
                      if (index == filteredChats.length) {
                        return const SizedBox(height: 80);
                      }
                      final chat = filteredChats[index];
                      return _buildChatItem(
                        context: context,
                        title: chat["title"],
                        subtitle: chat["subtitle"],
                        time: chat["time"],
                        unreadCount: chat["unreadCount"],
                        color: chat["color"],
                        icon: chat["icon"],
                        imageUrl: chat["imageUrl"],
                      );
                    },
                  );
                },
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
    String? imageUrl,
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
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                  image: imageUrl != null && imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: (imageUrl == null || imageUrl.isEmpty) ? Icon(icon, color: Colors.white, size: 24) : null,
              ),
              if (unreadCount > 0)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
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
