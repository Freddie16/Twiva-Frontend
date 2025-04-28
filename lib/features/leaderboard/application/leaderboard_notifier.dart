// lib/features/leaderboard/application/leaderboard_notifier.dart
import 'package:flutter/material.dart';
// import '../../../data/repositories/leaderboard_repository.dart'; // Assuming a separate repo for leaderboard

class LeaderboardNotifier with ChangeNotifier {
  // TODO: Implement LeaderboardNotifier if needed for global or game-specific leaderboards
  // Currently, session leaderboard is handled by SessionNotifier.

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;


  // Example method signature if fetching global leaderboard
  // Future<void> fetchGlobalLeaderboard() async {
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