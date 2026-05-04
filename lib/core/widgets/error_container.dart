import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum MessageType { error, warning, info, success }

class ErrorContainer extends StatelessWidget {
  const ErrorContainer({
    super.key,
    required this.message,
    this.type = MessageType.error,
    this.onDismiss,
  });

  final String message;

  final MessageType type;

  final VoidCallback? onDismiss;

  Color get _backgroundColor {
    final baseColor = _getBaseColor();
    return baseColor.withValues(alpha: 0.1);
  }

  Color _getBaseColor() {
    switch (type) {
      case MessageType.error:
        return AppTheme.error;
      case MessageType.warning:
        return AppTheme.warning;
      case MessageType.info:
        return AppTheme.info;
      case MessageType.success:
        return AppTheme.success;
    }
  }

  IconData get _icon {
    switch (type) {
      case MessageType.error:
        return Icons.error_outline;
      case MessageType.warning:
        return Icons.warning_amber_outlined;
      case MessageType.info:
        return Icons.info_outline;
      case MessageType.success:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = _getBaseColor();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_icon, size: 20, color: baseColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 13, color: baseColor),
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.close, size: 18, color: baseColor),
            ),
          ],
        ],
      ),
    );
  }
}
