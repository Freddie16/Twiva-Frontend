// lib/features/profile/application/profile_notifier.dart
import 'package:flutter/material.dart';
// import '../../../data/repositories/user_repository.dart'; // Assuming a UserRepository for profile data

class ProfileNotifier with ChangeNotifier {
  // TODO: Implement ProfileNotifier if needed for fetching/updating additional profile data
  // beyond what's available in the AuthNotifier.
  // This might involve a separate UserRepository or methods in AuthRepository.

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;


  // Example method signature for fetching additional profile data
  // Future<void> fetchProfileData() async {
  //    _setLoading(true);
  //   try {
  //     // Fetch data from repository
  //      _setErrorMessage(null);
  //   } catch (e) {
  //      _setErrorMessage(e.toString());
  //   } finally {
  //     _setLoading(false);
  //   }
  // }


  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}