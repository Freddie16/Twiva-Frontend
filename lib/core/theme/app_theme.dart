// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // Light Theme Configuration
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light, // Indicate this is a light theme
    primaryColor: AppColors.primary, // Use primary color
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent, // Use accent color as secondary
      surface: AppColors.surface, // Use surface color for cards, sheets, etc.
      background: AppColors.background, // Use background color for scaffold
      error: AppColors.error, // Use error color
      onPrimary: Colors.white, // Color for text/icons on primary
      onSecondary: Colors.black, // Color for text/icons on secondary
      onSurface: AppColors.textPrimary, // Color for text/icons on surface
      onBackground: AppColors.textPrimary, // Color for text/icons on background
      onError: Colors.white, // Color for text/icons on error
    ),
    scaffoldBackgroundColor: AppColors.background, // Apply background color
    cardColor: AppColors.surface, // Apply surface color to cards
    dividerColor: AppColors.divider, // Apply divider color

    // Configure AppBar theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary, // AppBar background color
      foregroundColor: Colors.white, // Color of icons and text in AppBar
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: Colors.white), // Use a title style for AppBar title
      elevation: 4.0, // Add a subtle shadow
    ),

    // Configure Text Theme using AppTextStyles
    textTheme: AppTextStyles.getTextTheme(), // Use the helper to apply all text styles

    // Configure Button themes
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.primary, // Deprecated, use ElevatedButtonTheme
      textTheme: ButtonTextTheme.primary, // Deprecated, use ElevatedButtonTheme
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary, // Button background color
        foregroundColor: Colors.white, // Button text/icon color
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        textStyle: AppTextStyles.labelLarge, // Use labelLarge for button text
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary, // Text button color
        textStyle: AppTextStyles.labelLarge, // Use labelLarge for button text
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
       style: OutlinedButton.styleFrom(
         foregroundColor: AppColors.primary, // Outlined button text/icon color
         side: const BorderSide(color: AppColors.primary), // Border color
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
           shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          textStyle: AppTextStyles.labelLarge, // Use labelLarge for button text
       ),
    ),


    // Configure Input Field theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface, // Use surface color for input fields
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none, // No border by default
      ),
       enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.divider, width: 1), // Subtle border when enabled
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.accent, width: 2), // Accent color border when focused
      ),
       errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.error, width: 2), // Error color border
      ),
       focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.error, width: 2), // Error color border when focused
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: AppTextStyles.bodyMedium, // Style for label text
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary), // Style for hint text
    ),

    // Add other theme configurations as needed (e.g., iconTheme, dialogTheme)
  );

  // Dark Theme Configuration
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark, // Indicate this is a dark theme
    primaryColor: AppColors.primary, // Primary color can be the same or a dark variant
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary, // Use primary color
      secondary: AppColors.accent, // Use accent color
      surface: const Color(0xFF303030), // Darker surface color
      background: const Color(0xFF121212), // Very dark background
      error: const Color(0xFFCF6679), // Dark theme error color
      onPrimary: Colors.white, // Color for text/icons on primary
      onSecondary: Colors.black, // Color for text/icons on secondary
      onSurface: Colors.white70, // Lighter text on dark surface
      onBackground: Colors.white70, // Lighter text on dark background
      onError: Colors.black, // Color for text/icons on error
    ),
     scaffoldBackgroundColor: const Color(0xFF121212), // Apply dark background color
    cardColor: const Color(0xFF303030), // Apply dark surface color to cards
    dividerColor: Colors.white12, // Lighter divider for dark theme

    // Configure AppBar theme for dark mode
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF212121), // Darker AppBar background
      foregroundColor: Colors.white, // Color of icons and text
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: Colors.white), // Use title style
      elevation: 4.0,
    ),

    // Configure Text Theme for dark mode (colors adjusted for dark background)
    textTheme: AppTextStyles.getTextTheme(Colors.white70), // Use helper, providing lighter text color

    // Configure Button themes for dark mode
     elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary, // Button background color
        foregroundColor: Colors.white, // Button text/icon color
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        textStyle: AppTextStyles.labelLarge, // Use labelLarge for button text
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accent, // Text button color (often accent in dark mode)
        textStyle: AppTextStyles.labelLarge, // Use labelLarge for button text
      ),
    ),
     outlinedButtonTheme: OutlinedButtonThemeData(
       style: OutlinedButton.styleFrom(
         foregroundColor: AppColors.accent, // Outlined button text/icon color
         side: const BorderSide(color: AppColors.accent), // Border color
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
           shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          textStyle: AppTextStyles.labelLarge, // Use labelLarge for button text
       ),
    ),

    // Configure Input Field theme for dark mode
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF424242), // Darker fill color for input fields
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
       enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white12, width: 1), // Subtle border
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.accent, width: 2), // Accent color border
      ),
       errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCF6679), width: 2), // Dark theme error color border
      ),
       focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCF6679), width: 2), // Dark theme error color border
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white70), // Style for label text
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white38), // Style for hint text
    ),

    // Add other dark theme configurations
  );
}
