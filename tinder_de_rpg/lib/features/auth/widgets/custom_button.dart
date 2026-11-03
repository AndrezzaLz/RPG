import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

/// Medieval-themed orange button used for primary actions throughout the app.
class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.icon,
    this.width = double.infinity,
    this.height = 50.0,
  });

  /// Button label text.
  final String text;

  /// Callback executed when the button is tapped.
  final VoidCallback? onPressed;

  /// Whether a loading indicator should replace the label.
  final bool isLoading;

  /// Optional leading icon.
  final IconData? icon;

  /// Button width (defaults to full width).
  final double width;

  /// Button height.
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: AppColors.parchment,
          disabledBackgroundColor:
              AppColors.primaryOrange.withValues(alpha: 0.5),
          disabledForegroundColor: AppColors.parchment.withValues(alpha: 0.7),
          elevation: 4,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: AppColors.accentGold,
              width: 1,
            ),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.parchment,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: AppColors.parchment),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: AppColors.parchment,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
