// lib/widgets/shared/app_button.dart
import 'package:flutter/material.dart';
import 'package:gamification_trivia/core/theme/app_colors.dart'; // Assuming your package name
import 'package:gamification_trivia/core/theme/app_text_styles.dart'; // Assuming your package name

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final Color? color;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final String? tooltip; // Added tooltip for disabled state


  const AppButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.color,
    this.textStyle,
    this.padding,
    this.borderRadius,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap the button in a Tooltip if a tooltip is provided and the button is disabled
    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primary, // Use primary color from theme
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
         disabledBackgroundColor: (color ?? AppColors.primary).withOpacity(0.5), // Dim color when disabled
         // Use the textStyle provided, or default to labelLarge from AppTextStyles
         textStyle: textStyle ?? AppTextStyles.labelLarge.copyWith(color: Colors.white),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white, // Loading indicator color
                strokeWidth: 3,
              ),
            )
          : Text(
              text,
              // The text style is now applied via ElevatedButton.styleFrom
              // This ensures consistency with other ElevatedButton properties
              // style: textStyle ?? AppTextStyles.labelLarge.copyWith(color: Colors.white),
            ),
    );

    if (isLoading && tooltip != null) {
       return Tooltip(
         message: tooltip!,
         child: button, // Wrap the button
       );
    }

    return button; // Return the button directly if not loading or no tooltip
  }
}
