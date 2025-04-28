// lib/core/utils/validators/form_validators.dart
import 'package:flutter/material.dart';
// A collection of static methods for common form field validation logic.
// These methods return a String error message if the input is invalid,
// and null if the input is valid.
class FormValidators {

  // Validator for required fields.
  // Returns an error message if the value is null or empty.
  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null; // Input is valid
  }

  // Validator for email format.
  // Returns an error message if the value is not a valid email format.
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address'; // Required check
    }
    // Basic email format validation using a regular expression.
    // This regex is a common pattern but might not cover all edge cases
    // of valid email addresses according to strict RFC specifications.
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address'; // Invalid format
    }
    return null; // Input is valid
  }

  // Validator for password strength/length.
  // Returns an error message if the password is too short.
  // TODO: Add more password complexity rules if needed (e.g., require uppercase, lowercase, numbers, symbols)
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password'; // Required check
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long'; // Minimum length check
    }
    return null; // Input is valid (based on current rules)
  }

  // Validator to confirm if the value matches another password field.
  // Returns an error message if the value does not match the provided password.
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password'; // Required check
    }
    if (value != password) {
      return 'Passwords do not match'; // Match check
    }
    return null; // Input is valid
  }

  // Add this method inside the FormValidators class
static FormFieldValidator<String> compose(List<FormFieldValidator<String>> validators) {
  return (value) {
    for (var validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result; // Return the first error found
      }
    }
    return null; // No errors found
  };
}

  // Validator for minimum string length.
  // Returns an error message if the value's length is less than minLength.
  static String? minLength(String? value, int minLength) {
    if (value == null || value.isEmpty) {
      // Consider if an empty string should pass this validation if not required.
      // If required, use FormValidators.required first.
      return null; // Or return 'This field is required' if it should also handle requiredness
    }
    if (value.length < minLength) {
      return 'Must be at least $minLength characters long';
    }
    return null;
  }

  // Validator for maximum string length.
  // Returns an error message if the value's length is greater than maxLength.
  static String? maxLength(String? value, int maxLength) {
    if (value == null || value.isEmpty) {
      return null; // Empty string is valid for max length unless required
    }
    if (value.length > maxLength) {
      return 'Cannot exceed $maxLength characters';
    }
    return null;
  }

  // Validator to check if the value is a valid number (integer or double).
  // Returns an error message if the value cannot be parsed as a number.
  static String? isNumber(String? value) {
    if (value == null || value.isEmpty) {
       return null; // Empty string is not a number, but might be valid if not required
    }
    // Try parsing as double (covers integers too)
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

   // Validator to check if the value is a valid integer.
  // Returns an error message if the value cannot be parsed as an integer.
  static String? isInteger(String? value) {
    if (value == null || value.isEmpty) {
       return null; // Empty string is not an integer, but might be valid if not required
    }
    // Try parsing as integer
    if (int.tryParse(value) == null) {
      return 'Please enter a valid integer';
    }
    return null;
  }

  // Validator to check if the value is a positive number (greater than 0).
  // Assumes the value is already validated as a number using isNumber.
  static String? isPositiveNumber(String? value) {
     if (value == null || value.isEmpty) {
       return null; // Empty string is not a positive number, but might be valid if not required
     }
     final number = double.tryParse(value);
     if (number == null || number <= 0) {
       return 'Please enter a positive number';
     }
     return null;
  }

   // Validator to check if the value is a non-negative number (greater than or equal to 0).
  // Assumes the value is already validated as a number using isNumber.
  static String? isNonNegativeNumber(String? value) {
     if (value == null || value.isEmpty) {
       return null; // Empty string is not a non-negative number, but might be valid if not required
     }
     final number = double.tryParse(value);
     if (number == null || number < 0) {
       return 'Please enter a non-negative number';
     }
     return null;
  }

  // You can combine validators using logical operators (e.g., &&, ||)
  // or by creating a list of validators and iterating through them.
  // Example of combining:
  // static String? requiredEmail(String? value) {
  //   final requiredError = required(value);
  //   if (requiredError != null) return requiredError;
  //   return email(value);
  // }
}
