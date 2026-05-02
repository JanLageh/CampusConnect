import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/domain/entities/user_entity.dart';
import '../../auth/domain/exceptions/user_exception.dart';
import '../../auth/domain/exceptions/validation_exception.dart';
import '../../auth/domain/user_display_name.dart';
import '../../auth/domain/validators/auth_validator.dart';
import '../../providers/auth_providers.dart';
import '../../core/widgets/widgets.dart';

class EditPersonalInfoScreen extends ConsumerStatefulWidget {
  final UserEntity user;

  const EditPersonalInfoScreen({super.key, required this.user});

  @override
  ConsumerState<EditPersonalInfoScreen> createState() =>
      _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState
    extends ConsumerState<EditPersonalInfoScreen> {
  final Color primaryDarkBlue = const Color(0xFF091C31);

  late final TextEditingController _fullNameController;
  late final TextEditingController _studentIdController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _errorMessage;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _studentIdController = TextEditingController(text: widget.user.studentId);

    _fullNameController.addListener(_onFieldChanged);
    _studentIdController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final hasChanges =
        _fullNameController.text.trim() != widget.user.fullName.trim() ||
        _studentIdController.text.trim() != widget.user.studentId.trim();

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_hasChanges) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);

      await authService.updateProfile(
        userId: widget.user.userId,
        fullName: _fullNameController.text,
        studentId: _studentIdController.text,
      );

      await ref.read(authStateNotifierProvider.notifier).refresh();

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on ValidationException catch (e) {
      _showError(e.message);
    } on UserException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Failed to update profile: ${e.toString()}');
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Personal Information',
          style: TextStyle(
            color: primaryDarkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryDarkBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: primaryDarkBlue.withValues(alpha: 0.1),
                    child: Text(
                      widget.user.displayName[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: primaryDarkBlue,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),

                if (_errorMessage != null) ...[
                  ErrorContainer(
                    message: _errorMessage!,
                    type: MessageType.error,
                  ),
                  const SizedBox(height: 16),
                ],

                FormLabel(text: 'Email Address'),
                const SizedBox(height: 8),
                _buildReadOnlyField(
                  icon: Icons.email_outlined,
                  value: widget.user.email,
                ),
                const SizedBox(height: 4),
                Text(
                  'Email cannot be changed',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 24),

                FormLabel(text: 'Full Name'),
                const SizedBox(height: 8),
                FormInputField(
                  controller: _fullNameController,
                  hintText: 'Enter your full name',
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    return AuthValidator.validateRequired(
                      value ?? '',
                      'Full name',
                    );
                  },
                ),
                const SizedBox(height: 24),

                FormLabel(text: 'Student ID'),
                const SizedBox(height: 8),
                FormInputField(
                  controller: _studentIdController,
                  hintText: 'Enter your student ID',
                  prefixIcon: Icons.badge_outlined,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    return AuthValidator.validateStudentId(value ?? '');
                  },
                ),
                const SizedBox(height: 40),

                PrimaryButton(
                  text: _hasChanges ? 'Save Changes' : 'No Changes',
                  onPressed: _isLoading ? null : _handleSave,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),

                SecondaryButton(
                  text: 'Cancel',
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({required IconData icon, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade500, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
          ),
          Icon(Icons.lock_outline, color: Colors.grey.shade400, size: 18),
        ],
      ),
    );
  }
}
