// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // A more professional and engaging color palette

  // Primary color: A vibrant but not overly bright color for main elements
  static const Color primary = Color(0xFF6200EE); // Deep Purple

  // Secondary/Accent color: Complements the primary color, used for accents and interactive elements
  static const Color accent = Color(0xFF03DAC6); // Teal

  // Background colors: Subtle variations for screen backgrounds and card surfaces
  static const Color background = Color(0xFFF0F2F5); // Light Grey/Blue for screen background
  static const Color surface = Color(0xFFFFFFFF); // White for cards and surfaces

  // Text colors: High contrast for readability on different backgrounds
  static const Color textPrimary = Color(0xFF212121); // Dark Grey for primary text
  static const Color textSecondary = Color(0xFF757575); // Medium Grey for secondary text

  // Error color: Standard red for error messages and indicators
  static const Color error = Color(0xFFB00020); // Standard Material Red

  // Success color: Green for success messages and indicators
  static const Color success = Color(0xFF4CAF50); // Green

  // Warning color: Orange/Amber for warnings
  static const Color warning = Color(0xFFFFC107); // Amber

  // Additional colors for specific UI elements or states
  static const Color disabled = Color(0xFFE0E0E0); // Light grey for disabled elements
  static const Color divider = Color(0xFFBDBDBD); // Grey for dividers

  // You can add more specific colors as needed for your design
  // static const Color leaderboardGold = Color(0xFFFFD700);
  // static const Color leaderboardSilver = Color(0xFFC0C0C0);
  // static const Color leaderboardBronze = Color(0xFFCD7F32);
}
