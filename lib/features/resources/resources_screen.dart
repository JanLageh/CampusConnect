import 'package:flutter/material.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resources Library')),
      body: const Center(
        child: Text('Resources Placeholder\nTODO: Implement file sharing', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
