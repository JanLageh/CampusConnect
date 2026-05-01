import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home_screen.dart';

class ProtectedModuleRouterRiverpod extends ConsumerWidget {
  const ProtectedModuleRouterRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const HomeScreen();
  }
}
