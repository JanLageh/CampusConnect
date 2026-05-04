import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fullWidth = true,
  });

  final String text;

  final VoidCallback? onPressed;

  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final button = TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey.shade600,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      child: Text(text),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
