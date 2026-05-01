import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/domain/entities/user_entity.dart';
import '../../auth/domain/exceptions/user_exception.dart';
import '../../auth/domain/exceptions/validation_exception.dart';
import '../../auth/domain/user_display_name.dart';
import '../../auth/domain/validators/auth_validator.dart';
import '../../providers/auth_providers.dart';

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
  final Color secondaryTeal = const Color(0xFF007A75);
  final Color fieldBackground = const Color(0xFFF3F4F6);
  final Color errorColor = const Color(0xFFba1a1a);

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
                const SizedBox(height: 32),

                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: errorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: errorColor, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: errorColor, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                Text(
                  'Email Address',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryDarkBlue,
                  ),
                ),
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

                _buildLabel('Full Name'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _fullNameController,
                  decoration: _inputDecoration(
                    hintText: 'Enter your full name',
                    icon: Icons.person_outline,
                  ),
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

                _buildLabel('Student ID'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _studentIdController,
                  decoration: _inputDecoration(
                    hintText: 'Enter your student ID',
                    icon: Icons.badge_outlined,
                  ),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    return AuthValidator.validateStudentId(value ?? '');
                  },
                ),
                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryDarkBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _hasChanges ? 'Save Changes' : 'No Changes',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primaryDarkBlue,
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

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
      prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 20),
      filled: true,
      fillColor: fieldBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: secondaryTeal, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }
}
