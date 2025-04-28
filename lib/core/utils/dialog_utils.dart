// lib/core/utils/dialog_utils.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart'; // Import AppColors
import '../theme/app_text_styles.dart'; // Import AppTextStyles
import '../../widgets/shared/loading_indicator.dart'; // Import LoadingIndicator
import 'dart:async';

class DialogUtils {
  // Private method to show a generic dialog
  static Future<T?> _showAppDialog<T>({
    required BuildContext context,
    required Widget content,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners for dialogs
        ),
        backgroundColor: AppColors.surface, // Use surface color for dialog background
        content: content,
        actions: actions,
        // Optional: Add titlePadding, contentPadding, actionsPadding for fine-tuning
      ),
    );
  }


  // Shows a basic alert dialog with a single confirmation button.
  static Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmButtonText = 'OK',
    VoidCallback? onConfirm,
  }) async {
    await _showAppDialog(
      context: context,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleLarge, // Use a title style for the title
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: AppTextStyles.bodyMedium, // Use a body style for the content
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss the dialog
            if (onConfirm != null) {
              onConfirm(); // Execute the confirmation callback
            }
          },
          child: Text(
            confirmButtonText,
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary), // Use label style with primary color
          ),
        ),
      ],
    );
  }

  // Shows a confirmation dialog with 'Cancel' and 'Confirm' buttons.
  // Returns true if confirmed, false if canceled or dismissed.
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String cancelButtonText = 'Cancel',
    String confirmButtonText = 'Confirm',
    Color confirmButtonColor = AppColors.primary,
  }) async {
    final result = await _showAppDialog<bool>(
      context: context,
      content: Column(
        mainAxisSize: MainAxisSize.min,
         crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            title,
            style: AppTextStyles.titleLarge, // Use a title style
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: AppTextStyles.bodyMedium, // Use a body style
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Dismiss and return false (canceled)
          },
          child: Text(
            cancelButtonText,
             style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary), // Use secondary text color for cancel
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Dismiss and return true (confirmed)
          },
          child: Text(
            confirmButtonText,
            style: AppTextStyles.labelLarge.copyWith(color: confirmButtonColor), // Use specified confirm button color
          ),
        ),
      ],
    );
    return result ?? false; // Return false if the dialog was dismissed without tapping a button
  }

  // Shows a loading dialog that prevents user interaction.
  // Returns a function to dismiss the dialog.
  static Future<VoidCallback> showLoadingDialog({
    required BuildContext context,
    String message = 'Loading...',
  }) async {
    // Use a Completer to get the Navigator pop function after the dialog is shown
    final completer = Completer<VoidCallback>();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        // Complete the completer with the pop function once the dialog is built
        if (!completer.isCompleted) {
          completer.complete(() => Navigator.of(context).pop());
        }
        return AlertDialog(
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(10),
           ),
           backgroundColor: AppColors.surface,
           content: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               const LoadingIndicator(), // Use your custom loading indicator
               const SizedBox(height: 16),
               Text(
                 message,
                 style: AppTextStyles.bodyMedium,
               ),
             ],
           ),
        );
      },
    );

    // Return the pop function from the completer
    return completer.future;
  }

  // Shows an input dialog to get text input from the user.
  // Returns the entered text, or null if canceled or dismissed.
  static Future<String?> showInputDialog({
    required BuildContext context,
    required String title,
    String? hintText,
    String? initialValue,
    String cancelButtonText = 'Cancel',
    String confirmButtonText = 'Submit',
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) async {
    final TextEditingController controller = TextEditingController(text: initialValue);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final result = await _showAppDialog<String>(
      context: context,
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
           crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              title,
              style: AppTextStyles.titleLarge, // Use a title style
            ),
            const SizedBox(height: 16),
            TextFormField( // Use TextFormField for validation
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                 // Use styles from InputDecorationTheme defined in AppTheme
              ),
              keyboardType: keyboardType,
              obscureText: obscureText,
              validator: validator,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(null); // Dismiss and return null (canceled)
          },
          child: Text(
            cancelButtonText,
             style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.of(context).pop(controller.text); // Dismiss and return the entered text
            }
          },
          child: Text(
            confirmButtonText,
             style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );

    controller.dispose(); // Dispose the controller
    return result;
  }

  // Helper to dismiss a loading dialog (used with showLoadingDialog)
   static void dismissDialog(VoidCallback dismissFunction) {
     dismissFunction();
   }
}
