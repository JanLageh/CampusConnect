import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Calendar')),
      body: const Center(
        child: Text('Events Placeholder\nTODO: Implement calendar and details', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
