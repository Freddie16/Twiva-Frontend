// lib/data/repositories/session_repository.dart
import '../data_sources/game_remote_data_source.dart'; // Assuming session operations are within GameRemoteDataSource
import '../models/game/game_session.dart';
import '../models/game/game_session_player.dart';
import '../models/game/player_answer.dart';
// TODO: Import Invitation model if created
// import '../models/invitation/invitation.dart';

// Repository responsible for handling game session-related data operations.
// It interacts with the GameRemoteDataSource for session data.
class SessionRepository {
  final GameRemoteDataSource _remoteDataSource;

  // Constructor receives the remote data source dependency.
  SessionRepository(this._remoteDataSource);

  // Creates a new game session for a specific game.
  Future<GameSession> createGameSession(String gameId) async {
    try {
      return await _remoteDataSource.createGameSession(gameId);
    } catch (e) {
      rethrow;
    }
  }

  // Allows a player to join an existing game session using a session code.
  Future<GameSession> joinGameSession(String sessionCode) async {
    try {
      return await _remoteDataSource.joinGameSession(sessionCode);
    } catch (e) {
      rethrow;
    }
  }

  // Fetches the details of a specific game session by its ID.
  Future<GameSession> getGameSessionDetail(String sessionId) async {
    try {
      return await _remoteDataSource.getGameSessionDetail(sessionId);
    } catch (e) {
      rethrow;
    }
  }

  // Starts a game session (typically called by the session owner).
  Future<GameSession> startGameSession(String sessionId) async {
    try {
      return await _remoteDataSource.startGameSession(sessionId);
    } catch (e) {
      rethrow;
    }
  }

  // Finishes a game session (typically called by the session owner).
  Future<GameSession> finishGameSession(String sessionId) async {
    try {
      return await _remoteDataSource.finishGameSession(sessionId);
    } catch (e) {
      rethrow;
    }
  }

  // Submits a player's answer for a specific question within a session.
  Future<PlayerAnswer> submitAnswer(String sessionId, int questionId, int? answerId) async {
    try {
      return await _remoteDataSource.submitAnswer(sessionId, questionId, answerId);
    } catch (e) {
      rethrow;
    }
  }

  // Fetches the leaderboard for a specific game session.
  Future<List<GameSessionPlayer>> getLeaderboard(String sessionId) async {
    try {
      return await _remoteDataSource.getLeaderboard(sessionId);
    } catch (e) {
      rethrow;
    }
  }

  // --- Invitation Methods ---
  // These methods are placeholders based on the "Invitation Module" feature.
  // They are included here as session joining can be related to invitations.
  // Implement the actual logic once the backend API endpoints are available
  // and you have a corresponding InvitationDataSource or methods in GameRemoteDataSource.

  // Accepts an invitation to a game session.
  // This might be called when a user accepts an invitation received via notifications or a list.
  Future<void> acceptInvitation(String invitationId) async {
     // TODO: Implement actual API call using an InvitationDataSource or GameRemoteDataSource
     // Example: await _invitationDataSource.acceptInvitation(invitationId);
     print('TODO: Implement acceptInvitation for invitation $invitationId'); // Placeholder print
     // Simulate a network delay
     await Future.delayed(const Duration(seconds: 1));
     // TODO: Handle API response and potential navigation to the session lobby
  }

  // Rejects an invitation to a game session.
  Future<void> rejectInvitation(String invitationId) async {
     // TODO: Implement actual API call using an InvitationDataSource or GameRemoteDataSource
     // Example: await _invitationDataSource.rejectInvitation(invitationId);
     print('TODO: Implement rejectInvitation for invitation $invitationId'); // Placeholder print
     // Simulate a network delay
     await Future.delayed(const Duration(seconds: 1));
     // TODO: Handle API response
  }


  // TODO: Add other invitation-related methods if they belong in the SessionRepository
  // (e.g., get invitations received) - Note: Getting received invitations might be better in a separate InvitationRepository.
}
