import 'package:flutter/material.dart';
import '../auth/domain/auth_repository.dart';
import '../auth/models/auth_session.dart';
import '../auth/presentation/verify_email_screen.dart';
import '../features/events/events_screen.dart';
import '../chats_screen.dart';
import '../home_screen.dart';
import '../features/resources/resources_screen.dart';
import '../features/profile/profile_screen.dart';
import '../login_screen.dart';

class ProtectedModuleRouter extends StatefulWidget {
  final AuthRepository authRepository;
  const ProtectedModuleRouter({super.key, required this.authRepository});

  @override
  State<ProtectedModuleRouter> createState() => _ProtectedModuleRouterState();
}

class _ProtectedModuleRouterState extends State<ProtectedModuleRouter> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    const DashboardTab(),
    const EventsScreen(),
    const ChatsScreen(),
    const ResourcesScreen(),
    ProfileScreen(authRepository: widget.authRepository),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthSession?>(
      stream: widget.authRepository.observeAuthState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) =>
                      LoginScreen(authRepository: widget.authRepository),
                ),
                (route) => false,
              );
            }
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data!;
        if (!session.isEmailVerified) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) =>
                      VerifyEmailScreen(authRepository: widget.authRepository),
                ),
                (route) => false,
              );
            }
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0D000000), // 0.05 opacity
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.campaign_outlined, "Announcements"),
                    _buildNavItem(1, Icons.calendar_month_outlined, "Events"),
                    _buildNavItem(2, Icons.chat_bubble_outline_rounded, "Chats"),
                    _buildNavItem(3, Icons.folder_outlined, "Resources"),
                    _buildNavItem(4, Icons.person_outline, "Profile"),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _currentIndex == index;
    Color primaryTeal = const Color(0xFF007A75);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryTeal : Colors.grey.shade400,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? primaryTeal : Colors.grey.shade400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
