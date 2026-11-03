import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

/// Reusable parchment-styled container card with medieval aesthetics.
///
/// Features a parchment-colored background, rounded corners, and elevated shadows.
/// Serves as the base container for player and campaign swipe cards.
class ParchmentCard extends StatelessWidget {
  const ParchmentCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.onTap,
  });

  /// The widget content displayed inside the card.
  final Widget child;

  /// Internal padding for the card contents.
  final EdgeInsetsGeometry padding;

  /// External margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Optional fixed width for the card.
  final double? width;

  /// Optional fixed height for the card.
  final double? height;

  /// Corner radius for the card border and shadow.
  final BorderRadiusGeometry borderRadius;

  /// Optional tap handler for the card.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: borderRadius,
        border: Border.all(
          color: AppColors.parchmentDim,
          width: 1.5,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 12,
            offset: Offset(0, 6),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Color(0x332C1A12),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius is BorderRadius
              ? borderRadius as BorderRadius
              : BorderRadius.circular(16),
          child: Padding(
            padding: padding,
            child: DefaultTextStyle.merge(
              style: const TextStyle(
                color: AppColors.textDark,
                fontFamilyFallback: <String>['serif'],
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
