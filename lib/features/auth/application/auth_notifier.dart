// lib/features/auth/application/auth_notifier.dart
import 'package:flutter/material.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user/user.dart';

class AuthNotifier with ChangeNotifier {
  final AuthRepository _authRepository;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthNotifier({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      final authResponse = await _authRepository.login(email, password);
      _user = authResponse.user;
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
      _user = null; // Clear user on failed login
      rethrow; // Re-throw to be caught by the UI for error display
    } finally {
      _setLoading(false);
    }
  }

   Future<void> register(String name, String username, String email, String password) async {
    _setLoading(true);
    try {
      final authResponse = await _authRepository.register(name, username, email, password);
      _user = authResponse.user;
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
       _user = null; // Clear user on failed register
       rethrow; // Re-throw to be caught by the UI for error display
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
     _setLoading(true);
    try {
      await _authRepository.logout();
      _user = null; // Clear user on logout
       _setErrorMessage(null);
    } catch (e) {
       _setErrorMessage(e.toString());
        rethrow; // Re-throw to be caught by the UI for error display
    } finally {
      _setLoading(false);
    }
  }

  // Method to check authentication status on app startup
  Future<void> checkAuthStatus() async {
     _setLoading(true);
    try {
      _user = await _authRepository.getAuthenticatedUser();
       _setErrorMessage(null);
    } catch (e) {
       _setErrorMessage(e.toString());
       _user = null; // Ensure user is null if fetching fails
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}