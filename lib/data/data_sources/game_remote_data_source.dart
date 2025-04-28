// lib/data/data_sources/game_remote_data_source.dart
import '../../core/services/api/api_client.dart';
import '../../core/services/api/api_endpoints.dart';
import '../models/game/game.dart';
import '../models/game/game_session.dart';
import '../models/game/game_session_player.dart';
import '../models/game/question.dart';
import '../models/game/player_answer.dart';
// TODO: Import Invitation model if created
// import '../models/invitation/invitation.dart';
import 'package:dio/dio.dart';

// Remote data source for fetching and sending game and session related data from the API.
class GameRemoteDataSource {
  // Dependency on the ApiClient to make HTTP requests.
  final ApiClient _apiClient;

  // Constructor receives the ApiClient dependency.
  GameRemoteDataSource(this._apiClient);

  // Fetches a list of all games from the backend API.
  // Assumes the API returns a JSON structure with a 'success' boolean and a 'data' list of games.
  Future<List<Game>> getGames() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.games);
      // Check if the API response indicates success
      if (response.data['success'] == true) {
        // Map the list of game JSON objects to Game model objects
        return (response.data['data'] as List)
            .map((gameJson) => Game.fromJson(gameJson))
            .toList();
      } else {
        // Throw an exception with the error message from the API if success is false
        throw Exception('Failed to fetch games: ${response.data['message']}');
      }
    } on DioException catch (e) {
      // Catch Dio-specific errors (e.g., network issues, HTTP errors)
      throw Exception('Failed to fetch games: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      // Catch any other unexpected errors
      throw Exception('Failed to fetch games: $e');
    }
  }

  // Fetches the details of a specific game by its ID from the backend API.
  // Assumes the API returns a JSON structure with a 'success' boolean and a 'data' object for the game.
  Future<Game> getGameDetail(String gameId) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.gameDetail(gameId));
      if (response.data['success'] == true) {
        // Map the game JSON object to a Game model object
        return Game.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to fetch game detail: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch game detail: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to fetch game detail: $e');
    }
  }

  // Creates a new game by sending game data to the backend API.
  // Assumes the API returns a JSON structure with a 'success' boolean and a 'data' object for the created game.
  Future<Game> createGame(Game game) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.games,
        data: game.toJson(), // Send the game object as JSON in the request body
      );
      if (response.data['success'] == true) {
        // Map the created game JSON object to a Game model object
        return Game.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to create game: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to create game: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to create game: $e');
    }
  }

  // Updates an existing game by its ID by sending updated game data to the backend API.
  // Assumes the API returns a JSON structure with a 'success' boolean and a 'data' object for the updated game.
  Future<Game> updateGame(String gameId, Game game) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.gameDetail(gameId),
        data: game.toJson(), // Send the updated game object as JSON
      );
      if (response.data['success'] == true) {
        // Map the updated game JSON object to a Game model object
        return Game.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update game: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update game: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to update game: $e');
    }
  }

  // Deletes a game by its ID via the backend API.
  // Assumes successful deletion returns a 200 or 204 status code.
  Future<void> deleteGame(String gameId) async {
    try {
      await _apiClient.dio.delete(ApiEndpoints.gameDetail(gameId));
      // No need to check response data for success if the status code indicates success (200, 204)
    } on DioException catch (e) {
      throw Exception('Failed to delete game: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to delete game: $e');
    }
  }

  // Adds a new question to a specific game via the backend API.
  // Assumes the API returns a JSON structure with a 'success' boolean and a 'data' object for the created question.
  Future<Question> addQuestionToGame(String gameId, Question question) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.gameQuestions(gameId),
        data: question.toJson(), // Send the question object as JSON
      );
      if (response.data['success'] == true) {
        // Map the created question JSON object to a Question model object
        return Question.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to add question: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to add question: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to add question: $e');
    }
  }

  // Updates an existing question by its ID via the backend API.
  // Assumes the API returns a JSON structure with a 'success' boolean and a 'data' object for the updated question.
  Future<Question> updateQuestion(String questionId, Question question) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.questionDetail(questionId),
        data: question.toJson(), // Send the updated question object as JSON
      );
      if (response.data['success'] == true) {
        // Map the updated question JSON object to a Question model object
        return Question.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update question: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update question: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to update question: $e');
    }
  }

  // Deletes a question by its ID via the backend API.
  // Assumes successful deletion returns a 200 or 204 status code.
  Future<void> deleteQuestion(String questionId) async {
    try {
      await _apiClient.dio.delete(ApiEndpoints.questionDetail(questionId));
      // No need to check response data for success if the status code indicates success
    } on DioException catch (e) {
      throw Exception('Failed to delete question: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to delete question: $e');
    }
  }

  // Creates a new game session for a specific game via the backend API.
  // Assumes the API returns a JSON structure with 'session_id' and 'code'.
  Future<GameSession> createGameSession(String gameId) async {
    try {
      final response = await _apiClient.dio.post(ApiEndpoints.gameSessions(gameId));
      if (response.data['success'] == true) {
        // Construct a GameSession object from the response data
        return GameSession(
          id: response.data['session_id'],
          code: response.data['code'],
          status: 'waiting', // Assuming the initial status is 'waiting' as per backend logic
          createdAt: DateTime.now(), // Use current time or parse from response if available
          updatedAt: DateTime.now(), // Use current time or parse from response if available
        );
      } else {
        throw Exception('Failed to create game session: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to create game session: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to create game session: $e');
    }
  }

  // Allows a player to join an existing game session using a session code via the backend API.
  // Assumes the API returns a GameSessionResource object on success.
  Future<GameSession> joinGameSession(String sessionCode) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.joinSession,
        data: {'session_code': sessionCode}, // Send the session code in the request body
      );
      // Assuming the API returns the full GameSession resource directly on join
      return GameSession.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to join game session: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to join game session: $e');
    }
  }

  // Fetches the details of a specific game session by its ID from the backend API.
  // Assumes the API returns a GameSessionResource object on success.
  Future<GameSession> getGameSessionDetail(String sessionId) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.sessionDetail(sessionId));
      // Assuming the API returns the full GameSession resource
      return GameSession.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch game session detail: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to fetch game session detail: $e');
    }
  }

  // Starts a game session via the backend API (typically called by the session owner).
  // Assumes the API returns a JSON structure with a 'success' boolean and a 'session' object.
  Future<GameSession> startGameSession(String sessionId) async {
    try {
      final response = await _apiClient.dio.post(ApiEndpoints.startSession(sessionId));
      if (response.data['success'] == true) {
        // Assuming the API returns the updated GameSession resource
        return GameSession.fromJson(response.data['session']);
      } else {
        throw Exception('Failed to start game session: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to start game session: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to start game session: $e');
    }
  }

  // Finishes a game session via the backend API (typically called by the session owner).
  // Assumes the API returns a JSON structure with a 'success' boolean and a 'session' object.
  Future<GameSession> finishGameSession(String sessionId) async {
    try {
      final response = await _apiClient.dio.post(ApiEndpoints.finishSession(sessionId));
      if (response.data['success'] == true) {
        // Assuming the API returns the updated GameSession resource
        return GameSession.fromJson(response.data['session']);
      } else {
        throw Exception('Failed to finish game session: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to finish game session: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to finish game session: $e');
    }
  }

  // Submits a player's answer for a specific question within a session via the backend API.
  // Assumes the API returns a JSON structure with success status and potentially score info.
  // Note: The backend example didn't return a full PlayerAnswer object on submit.
  // This method constructs a PlayerAnswer based on the available response data.
  Future<PlayerAnswer> submitAnswer(String sessionId, int questionId, int? answerId) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.submitAnswer(sessionId),
        data: {
          'question_id': questionId,
          'answer_id': answerId, // Can be null if the question was skipped
        },
      );
      // Assuming the API returns success, is_correct, points_awarded, current_score
      if (response.data['success'] == true) {
        // Construct a PlayerAnswer object from the response data.
        // Note: 'id' and 'gameSessionPlayerId' might not be returned by the API on submit,
        // using placeholders or making them nullable in the model might be necessary.
        return PlayerAnswer(
          id: 0, // Placeholder, assuming ID is not returned on submit
          gameSessionPlayerId: 0, // Placeholder, assuming this ID is not returned on submit
          questionId: questionId,
          answerId: answerId,
          isCorrect: response.data['is_correct'] ?? false, // Default to false if not provided
          // You might want to include points_awarded and current_score in the PlayerAnswer model
          // or handle them directly in the SessionNotifier based on the API response.
        );
      } else {
        throw Exception('Failed to submit answer: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to submit answer: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to submit answer: $e');
    }
  }

  // Fetches the leaderboard for a specific game session from the backend API.
  // Assumes the API returns a JSON structure with a 'success' boolean and a 'leaderboard' list of players.
  Future<List<GameSessionPlayer>> getLeaderboard(String sessionId) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.sessionLeaderboard(sessionId));
      if (response.data['success'] == true) {
        // Map the list of player JSON objects to GameSessionPlayer model objects
        return (response.data['leaderboard'] as List)
            .map((playerJson) => GameSessionPlayer.fromJson(playerJson))
            .toList();
      } else {
        throw Exception('Failed to fetch leaderboard: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch leaderboard: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to fetch leaderboard: $e');
    }
  }

  // --- Invitation Methods ---
  // These methods are placeholders based on the "Invitation Module" feature from the PDF.
  // Implement the actual API calls once the backend endpoints are available.
  // Note: These methods could potentially be in a separate InvitationRemoteDataSource
  // if the invitation logic is distinct from general game/session data.

  // Sends an invitation to a user for a specific game.
  // Assumes a backend endpoint that accepts game_id and recipient identifier (email/username).
  Future<void> sendInvitation({required String gameId, required String recipientIdentifier}) async {
    try {
      // Assuming the API endpoint is ApiEndpoints.sendInvitation and accepts game_id and recipient_identifier
      final response = await _apiClient.dio.post(
        ApiEndpoints.sendInvitation,
        data: {
          'game_id': gameId,
          'recipient_identifier': recipientIdentifier,
        },
      );
      // Check API response for success. Adjust based on actual backend response.
      if (response.data['success'] == true) {
        print('Invitation sent successfully'); // Log success
        // TODO: Handle successful invitation (e.g., show a success message to the user)
      } else {
        throw Exception('Failed to send invitation: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to send invitation: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to send invitation: $e');
    }
  }

  // Accepts an invitation to a game session.
  // Assumes a backend endpoint that accepts the invitation ID.
  Future<void> acceptInvitation(String invitationId) async {
    try {
      // Assuming the API endpoint is ApiEndpoints.acceptInvitation(invitationId)
      final response = await _apiClient.dio.post(ApiEndpoints.acceptInvitation(invitationId));
      // Check API response for success. Adjust based on actual backend response.
      if (response.data['success'] == true) {
        print('Invitation accepted successfully'); // Log success
        // TODO: Handle successful acceptance (e.g., navigate to the session lobby)
      } else {
        throw Exception('Failed to accept invitation: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to accept invitation: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to accept invitation: $e');
    }
  }

  // Rejects an invitation to a game session.
  // Assumes a backend endpoint that accepts the invitation ID.
  Future<void> rejectInvitation(String invitationId) async {
    try {
      // Assuming the API endpoint is ApiEndpoints.rejectInvitation(invitationId)
      final response = await _apiClient.dio.post(ApiEndpoints.rejectInvitation(invitationId));
       // Check API response for success. Adjust based on actual backend response.
      if (response.data['success'] == true) {
        print('Invitation rejected successfully'); // Log success
        // TODO: Handle successful rejection (e.g., remove the invitation from the list)
      } else {
        throw Exception('Failed to reject invitation: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to reject invitation: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to reject invitation: $e');
    }
  }

  // TODO: Add other methods as needed for game/session interactions with the backend.
  // (e.g., fetching invitations received, getting game history, etc.)
}
