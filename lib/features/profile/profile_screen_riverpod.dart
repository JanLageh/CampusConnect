import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/domain/entities/user_entity.dart';
import '../../auth/domain/user_display_name.dart';
import '../../providers/auth_providers.dart';
import 'edit_personal_info_screen.dart';

class ProfileScreenRiverpod extends ConsumerWidget {
  const ProfileScreenRiverpod({super.key});

  final Color primaryDarkBlue = const Color(0xFF091C31);
  final Color secondaryTeal = const Color(0xFF007A75);
  final Color fieldBackground = const Color(0xFFF3F4F6);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: TextStyle(
            color: primaryDarkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: primaryDarkBlue),
            onPressed: () async {
              final authService = ref.read(authServiceProvider);
              await authService.signOut();
            },
          ),
        ],
      ),
      body: authState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : authState.user == null
          ? const Center(child: Text('Not logged in'))
          : _buildProfileContent(context, ref, authState.user!),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    WidgetRef ref,
    UserEntity user,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: secondaryTeal.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, size: 50, color: secondaryTeal),
                ),
                const SizedBox(height: 16),
                Text(
                  user.displayName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Profile Options
          _buildProfileOption(
            context,
            icon: Icons.person_outline,
            title: 'Personal Information',
            subtitle: 'Update your personal details',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditPersonalInfoScreen(user: user),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildProfileOption(
            context,
            icon: Icons.lock_outline,
            title: 'Security',
            subtitle: 'Change password and security settings',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Security settings coming soon')),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildProfileOption(
            context,
            icon: Icons.notifications_none,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification settings coming soon'),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildProfileOption(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support coming soon')),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildProfileOption(
            context,
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'App version and information',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'CampusConnect',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 ACLC College of Mandaue',
              );
            },
          ),
          const SizedBox(height: 32),

          // Sign Out Button
          ElevatedButton(
            onPressed: () async {
              final authService = ref.read(authServiceProvider);
              await authService.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red.shade700,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, size: 20),
                SizedBox(width: 8),
                Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: fieldBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: secondaryTeal, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
