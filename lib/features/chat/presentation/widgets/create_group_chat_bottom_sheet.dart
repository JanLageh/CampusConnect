import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/auth_providers.dart';
import '../../providers/group_chat_provider.dart';

/// Bottom sheet for creating a new group chat.
class CreateGroupChatBottomSheet extends ConsumerStatefulWidget {
  const CreateGroupChatBottomSheet({super.key});

  /// Shows the create group chat bottom sheet.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const CreateGroupChatBottomSheet(),
    );
  }

  @override
  ConsumerState<CreateGroupChatBottomSheet> createState() =>
      _CreateGroupChatBottomSheetState();
}

class _CreateGroupChatBottomSheetState
    extends ConsumerState<CreateGroupChatBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPublic = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createGroupChat() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authState = ref.read(authStateNotifierProvider);
    if (authState.user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be logged in to create a group chat'),
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final service = ref.read(groupChatServiceProvider);
      await service.createGroupChat(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        memberIds: [authState.user!.userId], // Creator is the first member
        creatorId: authState.user!.userId,
        isPublic: _isPublic,
      );

      if (mounted) {
        // Invalidate the user group chats provider to refresh the list
        ref.invalidate(userGroupChatsProvider(authState.user!.userId));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Group chat created successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create group chat: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.group_add, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Create Group Chat',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                  hintText: 'Enter group name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.group),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a group name';
                  }
                  if (value.trim().length < 3) {
                    return 'Group name must be at least 3 characters';
                  }
                  return null;
                },
                enabled: !_isLoading,
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Enter group description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Public Group'),
                subtitle: Text(
                  _isPublic
                      ? 'Anyone can discover and join this group'
                      : 'Only invited members can join',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                value: _isPublic,
                onChanged: _isLoading
                    ? null
                    : (value) {
                        setState(() => _isPublic = value);
                      },
                secondary: Icon(_isPublic ? Icons.public : Icons.lock),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _createGroupChat,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add),
                label: Text(_isLoading ? 'Creating...' : 'Create Group Chat'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
