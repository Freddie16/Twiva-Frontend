// lib/core/utils/formatters/date_formatter.dart
import 'package:intl/intl.dart'; // Import the intl package for date formatting

// A utility class for formatting DateTime objects into various string representations.
class DateFormatter {

  // Formats a DateTime object into a string using a specified pattern.
  // Defaults to 'yyyy-MM-dd HH:mm' (e.g., 2023-10-27 10:30).
  static String formatDateTime(DateTime dateTime, {String pattern = 'yyyy-MM-dd HH:mm'}) {
    // Use DateFormat from the intl package to format the date.
    // Ensure the DateTime is in the local time zone before formatting if needed,
    // or handle time zones explicitly based on requirements.
    return DateFormat(pattern).format(dateTime.toLocal());
  }

  // Formats a DateTime object to show only the date.
  // Defaults to 'yyyy-MM-dd' (e.g., 2023-10-27).
  static String formatDate(DateTime dateTime, {String pattern = 'yyyy-MM-dd'}) {
    return DateFormat(pattern).format(dateTime.toLocal());
  }

  // Formats a DateTime object to show only the time.
  // Defaults to 'HH:mm' (e.g., 10:30).
  static String formatTime(DateTime dateTime, {String pattern = 'HH:mm'}) {
    return DateFormat(pattern).format(dateTime.toLocal());
  }

  // Formats a DateTime object to a human-readable date and time string.
  // Example: 'October 27, 2023 10:30 AM'
  static String formatFriendlyDateTime(DateTime dateTime) {
    return DateFormat('MMMM d, yyyy h:mm a').format(dateTime.toLocal());
  }

   // Formats a DateTime object to a human-readable date string.
  // Example: 'October 27, 2023'
  static String formatFriendlyDate(DateTime dateTime) {
    return DateFormat('MMMM d, yyyy').format(dateTime.toLocal());
  }


  // Formats a DateTime object to a short date string.
  // Example: '10/27/2023'
  static String formatShortDate(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy').format(dateTime.toLocal());
  }

  // Formats a DateTime object to a relative time string (e.g., "2 hours ago", "just now").
  // This requires calculating the difference from the current time.
  // Note: A full relative time implementation can be complex and might require
  // a dedicated package or more extensive logic. This is a simplified example.
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      // For longer periods, fall back to a standard date format
      return formatDate(dateTime);
    }
  }

  // You can add more specific formatting methods as needed.
  // Example: format to ISO 8601 string
  static String formatIso8601(DateTime dateTime) {
    return dateTime.toIso8601String();
  }
}
