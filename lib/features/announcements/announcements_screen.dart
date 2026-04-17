import 'package:flutter/material.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements Feed')),
      body: const Center(
        child: Text('Announcements Placeholder\nTODO: Implement real-time feed', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
