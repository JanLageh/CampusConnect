import 'package:flutter/material.dart';
import '../../auth/domain/auth_repository.dart';
import '../../auth/models/auth_session.dart';

class EditPersonalInfoScreen extends StatefulWidget {
  final AuthRepository authRepository;
  final AuthSession user;

  const EditPersonalInfoScreen({
    super.key,
    required this.authRepository,
    required this.user,
  });

  @override
  State<EditPersonalInfoScreen> createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> {
  final Color primaryDarkBlue = const Color(0xFF091C31);
  final Color secondaryTeal = const Color(0xFF007A75);
  final Color fieldBackground = const Color(0xFFF3F4F6);
  final Color errorColor = const Color(0xFFba1a1a);

  late TextEditingController _displayNameController;
  late TextEditingController _photoURLController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _errorMessage;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text: widget.user.displayName ?? '',
    );
    _photoURLController = TextEditingController(
      text: widget.user.photoURL ?? '',
    );

    _displayNameController.addListener(_onFieldChanged);
    _photoURLController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final hasChanges =
        _displayNameController.text != (widget.user.displayName ?? '') ||
        _photoURLController.text != (widget.user.photoURL ?? '');

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _photoURLController.dispose();
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
      final displayName = _displayNameController.text.trim().isEmpty
          ? null
          : _displayNameController.text.trim();
      final photoURL = _photoURLController.text.trim().isEmpty
          ? null
          : _photoURLController.text.trim();

      await widget.authRepository.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
      );

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update profile: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Personal Information",
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
                // Profile Photo Preview
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _photoURLController.text.trim().isNotEmpty
                          ? CircleAvatar(
                              radius: 60,
                              backgroundColor: primaryDarkBlue.withValues(
                                alpha: 0.1,
                              ),
                              backgroundImage: NetworkImage(
                                _photoURLController.text.trim(),
                              ),
                              onBackgroundImageError: (_, __) {},
                            )
                          : CircleAvatar(
                              radius: 60,
                              backgroundColor: primaryDarkBlue.withValues(
                                alpha: 0.1,
                              ),
                              child: Text(
                                (_displayNameController.text.trim().isNotEmpty
                                        ? _displayNameController.text.trim()[0]
                                        : widget.user.name[0])
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: primaryDarkBlue,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    'Profile Photo Preview',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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

                // Email (Read-only)
                Text(
                  'Email Address',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        color: Colors.grey.shade500,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.user.email,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.lock_outline,
                        color: Colors.grey.shade400,
                        size: 18,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Email cannot be changed',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),

                const SizedBox(height: 24),

                // Display Name Field
                Text(
                  'Display Name',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your display name',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Colors.grey.shade500,
                      size: 20,
                    ),
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
                  ),
                  validator: (value) {
                    if (value != null &&
                        value.trim().isNotEmpty &&
                        value.trim().length < 2) {
                      return 'Display name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  'This is how your name will appear to others',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),

                const SizedBox(height: 24),

                // Photo URL Field
                Text(
                  'Profile Photo URL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _photoURLController,
                  decoration: InputDecoration(
                    hintText: 'https://example.com/photo.jpg',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.image_outlined,
                      color: Colors.grey.shade500,
                      size: 20,
                    ),
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
                  ),
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final uri = Uri.tryParse(value.trim());
                      if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
                        return 'Please enter a valid URL';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  'Enter a URL to your profile photo',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),

                const SizedBox(height: 40),

                // Save Button
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

                // Cancel Button
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
}
