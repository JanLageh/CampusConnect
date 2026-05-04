import 'package:flutter/material.dart';
import 'package:campusconnect/core/theme/app_theme.dart';

enum CardVariant { white, gradient, dark }

class CardContainer extends StatelessWidget {
  const CardContainer({
    super.key,
    required this.child,
    this.variant = CardVariant.white,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 24,
    this.gradient,
    this.onTap,
  });

  final Widget child;

  final CardVariant variant;

  final EdgeInsets padding;

  final double borderRadius;

  final Gradient? gradient;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final BoxDecoration decoration = _buildDecoration();

    Widget cardContent = Container(
      padding: padding,
      decoration: decoration,
      child: child,
    );

    if (onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(padding: padding, child: child),
        ),
      );

      cardContent = Container(decoration: decoration, child: cardContent);
    }

    return cardContent;
  }

  BoxDecoration _buildDecoration() {
    switch (variant) {
      case CardVariant.white:
        return BoxDecoration(
          color: AppTheme.neutralLight,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        );

      case CardVariant.gradient:
        final Gradient effectiveGradient =
            gradient ??
            const LinearGradient(
              colors: [AppTheme.secondary, AppTheme.tertiary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            );

        Color shadowColor = AppTheme.secondary;
        if (gradient != null && gradient is LinearGradient) {
          final LinearGradient linearGradient = gradient as LinearGradient;
          if (linearGradient.colors.isNotEmpty) {
            shadowColor = linearGradient.colors.first;
          }
        }

        return BoxDecoration(
          gradient: effectiveGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withValues(alpha: 0.20),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        );

      case CardVariant.dark:
        return BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(borderRadius),
        );
    }
  }
}
