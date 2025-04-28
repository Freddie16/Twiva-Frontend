// lib/features/session/application/session_notifier.dart
import 'package:flutter/material.dart';
import '../../../data/repositories/session_repository.dart';
import '../../../data/repositories/auth_repository.dart'; // Needed to check user ownership
import '../../../data/models/game/game_session.dart';
import '../../../data/models/game/game_session_player.dart';
import '../../../data/models/game/player_answer.dart';

class SessionNotifier with ChangeNotifier {
  final SessionRepository _sessionRepository;
  final AuthRepository _authRepository;

  GameSession? _sessionDetail;
  List<GameSessionPlayer> _leaderboard = [];
  bool _isLoading = false;
  String? _errorMessage;

  GameSession? get sessionDetail => _sessionDetail;
  List<GameSessionPlayer> get leaderboard => _leaderboard;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticatedUserOwner {
     if (_sessionDetail?.game?.creator == null) return false;
     // This requires the AuthRepository to know the current authenticated user's ID
     // We'll need to inject AuthRepository and compare user IDs.
     // For now, returning false as a placeholder.
     // TODO: Implement actual check using AuthRepository
      return false; // Placeholder
  }


  SessionNotifier({required SessionRepository sessionRepository, required AuthRepository authRepository})
      : _sessionRepository = sessionRepository,
        _authRepository = authRepository;


   Future<void> fetchSessionDetail(String sessionId) async {
    _setLoading(true);
    try {
      _sessionDetail = await _sessionRepository.getGameSessionDetail(sessionId);
       _setErrorMessage(null);
       // TODO: Check if the authenticated user is a player or owner and update isAuthenticatedUserOwner
       // This will require accessing the current user from AuthRepository
    } catch (e) {
      _setErrorMessage(e.toString());
       _sessionDetail = null; // Clear session detail on error
    } finally {
      _setLoading(false);
    }
  }

   Future<GameSession> createGameSession(String gameId) async {
     _setLoading(true);
     try {
       final session = await _sessionRepository.createGameSession(gameId);
        _setErrorMessage(null);
        return session; // Return the created session to navigate to lobby
     } catch (e) {
       _setErrorMessage(e.toString());
       rethrow;
     } finally {
       _setLoading(false);
     }
   }


  Future<GameSession> joinGameSession(String sessionCode) async {
     _setLoading(true);
     try {
       final session = await _sessionRepository.joinGameSession(sessionCode);
        _setErrorMessage(null);
         return session; // Return the joined session to navigate to lobby
     } catch (e) {
       _setErrorMessage(e.toString());
       rethrow;
     } finally {
       _setLoading(false);
     }
  }


  Future<void> startGame(String sessionId) async {
     _setLoading(true);
     try {
       await _sessionRepository.startGameSession(sessionId);
        // Refetch session details to update status and potentially players
        await fetchSessionDetail(sessionId);
        _setErrorMessage(null);
     } catch (e) {
       _setErrorMessage(e.toString());
       rethrow;
     } finally {
       _setLoading(false);
     }
  }

   Future<void> finishGame(String sessionId) async {
      _setLoading(true);
     try {
       await _sessionRepository.finishGameSession(sessionId);
        // Refetch session details or leaderboard after finishing
        await fetchSessionDetail(sessionId); // Or fetch leaderboard directly
        _setErrorMessage(null);
     } catch (e) {
       _setErrorMessage(e.toString());
       rethrow;
     } finally {
       _setLoading(false);
     }
   }


  Future<PlayerAnswer> submitAnswer(String sessionId, int questionId, int? answerId) async {
      _setLoading(true); // Optional: show loading while submitting answer
     try {
       final playerAnswer = await _sessionRepository.submitAnswer(sessionId, questionId, answerId);
        _setErrorMessage(null);
        // Optionally update the local session detail or player score
        // This might be complex depending on how real-time score updates are handled.
        // For now, we rely on fetching leaderboard at the end.
        return playerAnswer; // Return feedback to the UI
     } catch (e) {
       _setErrorMessage(e.toString());
       rethrow;
     } finally {
       _setLoading(false); // Optional: hide loading
     }
  }

   Future<void> fetchLeaderboard(String sessionId) async {
     _setLoading(true);
     try {
       _leaderboard = await _sessionRepository.getLeaderboard(sessionId);
        _setErrorMessage(null);
     } catch (e) {
       _setErrorMessage(e.toString());
        _leaderboard = []; // Clear leaderboard on error
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