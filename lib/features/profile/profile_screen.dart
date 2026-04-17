import 'package:flutter/material.dart';
import '../../auth/domain/auth_repository.dart';

class ProfileScreen extends StatelessWidget {
  final AuthRepository authRepository;

  const ProfileScreen({super.key, required this.authRepository});

  final Color primaryDarkBlue = const Color(0xFF091C31);
  final Color secondaryTeal = const Color(0xFF007A75);
  final Color fieldBackground = const Color(0xFFF3F4F6);

  @override
  Widget build(BuildContext context) {
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryDarkBlue, const Color(0xFF1F2937)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryDarkBlue.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          backgroundImage: const NetworkImage("https://picsum.photos/seed/user/200/200"),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: secondaryTeal,
                            shape: BoxShape.circle,
                            border: Border.all(color: primaryDarkBlue, width: 3),
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 16),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Alex Student",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Computer Science, Class of '26",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              Text(
                "ACCOUNT SETTINGS",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildSettingsTile(
                icon: Icons.person_outline,
                title: "Personal Information",
                subtitle: "Update your name, bio, and contact info",
              ),
              _buildSettingsTile(
                icon: Icons.notifications_outlined,
                title: "Push Notifications",
                subtitle: "Manage what events you get alerted for",
              ),
              _buildSettingsTile(
                icon: Icons.security_outlined,
                title: "Privacy & Security",
                subtitle: "Biometrics and device management",
              ),
              _buildSettingsTile(
                icon: Icons.help_outline,
                title: "Help & Support",
                subtitle: "Contact administration",
              ),
              
              const SizedBox(height: 40),
              
              // Logout Button
              ElevatedButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout),
                label: const Text("Log Out"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 80), // Padding for Bottom Navbar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({required IconData icon, required String title, required String subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: fieldBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Icon(icon, color: primaryDarkBlue),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryDarkBlue,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 13,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    // Show a small loading indicator or confirmation dialog if desired
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    try {
      await authRepository.signOut();
      // The ProtectedModuleRouter's StreamBuilder will automatically react 
      // to the sign out and pop the navigator back to the Login Screen.
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // remove loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to log out. Please try again.")),
        );
      }
    }
  }
}
