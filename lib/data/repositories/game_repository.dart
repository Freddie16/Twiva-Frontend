import '../data_sources/game_remote_data_source.dart';
import '../models/game/game.dart';
import '../models/game/question.dart';
// TODO: Import Invitation model if created
// import '../models/invitation/invitation.dart';

// Repository responsible for handling game-related data operations.
// It acts as an intermediary between the GameRemoteDataSource and the application logic (notifiers).
class GameRepository {
  final GameRemoteDataSource _remoteDataSource;

  // Constructor receives the remote data source dependency.
  GameRepository(this._remoteDataSource);

  // Fetches a list of all games from the remote data source.
  Future<List<Game>> getGames() async {
    try {
      return await _remoteDataSource.getGames();
    } catch (e) {
      // Re-throw the exception to be handled by the calling layer (notifier).
      rethrow;
    }
  }

  // Fetches the details of a specific game by its ID.
  Future<Game> getGameDetail(String gameId) async {
    try {
      return await _remoteDataSource.getGameDetail(gameId);
    } catch (e) {
      rethrow;
    }
  }

  // Creates a new game via the remote data source.
  Future<Game> createGame(Game game) async {
    try {
      return await _remoteDataSource.createGame(game);
    } catch (e) {
      rethrow;
    }
  }

  // Updates an existing game by its ID via the remote data source.
  Future<Game> updateGame(String gameId, Game game) async {
    try {
      return await _remoteDataSource.updateGame(gameId, game);
    } catch (e) {
      rethrow;
    }
  }

  // Deletes a game by its ID via the remote data source.
  Future<void> deleteGame(String gameId) async {
    try {
      await _remoteDataSource.deleteGame(gameId);
    } catch (e) {
      rethrow;
    }
  }

  // Adds a new question to a specific game via the remote data source.
  Future<Question> addQuestionToGame(String gameId, Question question) async {
    try {
      return await _remoteDataSource.addQuestionToGame(gameId, question);
    } catch (e) {
      rethrow;
    }
  }

  // Updates an existing question by its ID via the remote data source.
  Future<Question> updateQuestion(String questionId, Question question) async {
    try {
      return await _remoteDataSource.updateQuestion(questionId, question);
    } catch (e) {
      rethrow;
    }
  }

  // Deletes a question by its ID via the remote data source.
  Future<void> deleteQuestion(String questionId) async {
    try {
      await _remoteDataSource.deleteQuestion(questionId);
    } catch (e) {
      rethrow;
    }
  }

  // --- Invitation Methods ---
  // These methods are placeholders based on the "Invitation Module" feature.
  // Implement the actual logic once the backend API endpoints are available
  // and you have a corresponding InvitationDataSource.

  // Sends an invitation to a user for a specific game.
  // The recipient can be identified by email or username.
  Future<void> sendInvitation({required String gameId, required String recipientIdentifier}) async {
    // TODO: Implement actual API call using an InvitationDataSource
    // Example: await _invitationDataSource.sendInvitation(gameId: gameId, recipientIdentifier: recipientIdentifier);
    print('TODO: Implement sendInvitation for game $gameId to $recipientIdentifier'); // Placeholder print
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));
    // TODO: Handle API response (success/failure)
    // If the API returns an Invitation object, you might return it here.
    // return Invitation.fromJson({}); // Example return
  }

  // TODO: Add other invitation-related methods if they belong in the GameRepository
  // (e.g., get invitations sent for a game, revoke invitation)
}