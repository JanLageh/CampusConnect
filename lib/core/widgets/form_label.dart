import 'package:flutter/material.dart';
import 'package:campusconnect/core/theme/app_theme.dart';

class FormLabel extends StatelessWidget {
  const FormLabel({super.key, required this.text, this.required = false});

  final String text;

  final bool required;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.primary,
        ),
        children: required
            ? [
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]
            : null,
      ),
    );
  }
}
