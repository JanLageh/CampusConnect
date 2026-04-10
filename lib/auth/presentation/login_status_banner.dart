import 'package:flutter/material.dart';

class LoginStatusBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const LoginStatusBanner({
    super.key,
    required this.message,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF003366).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF003366).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.mark_email_unread_outlined, color: Color(0xFF003366)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF003366),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(Icons.close, size: 16, color: Color(0xFF003366)),
            ),
        ],
      ),
    );
  }
}
