import 'package:flutter/material.dart';
import '../auth/domain/auth_repository.dart';
import '../features/announcements/announcements_screen.dart';
import '../features/events/events_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/resources/resources_screen.dart';

class ProtectedModuleRouter extends StatefulWidget {
  final AuthRepository authRepository;
  const ProtectedModuleRouter({super.key, required this.authRepository});

  @override
  State<ProtectedModuleRouter> createState() => _ProtectedModuleRouterState();
}

class _ProtectedModuleRouterState extends State<ProtectedModuleRouter> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AnnouncementsScreen(),
    const EventsScreen(),
    const ChatScreen(),
    const ResourcesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign),
            label: 'Announcements',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'Resources',
          ),
        ],
      ),
    );
  }
}
