import 'package:flutter/material.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../data/models/game/game.dart';
import '../../../data/models/game/question.dart'; // Make sure Question model is imported

class GameNotifier with ChangeNotifier {
  final GameRepository _gameRepository;

  List<Game> _games = [];
  Game? _gameDetail; // This can be null
  bool _isLoading = false;
  String? _errorMessage;

  List<Game> get games => _games;
  Game? get gameDetail => _gameDetail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Constructor - inject the GameRepository dependency
  GameNotifier({required GameRepository gameRepository}) : _gameRepository = gameRepository;

  // Helper methods to set loading state and error message, and notify listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // ===================================================
  // Methods for fetching and managing entire Games
  // ===================================================

  // Fetch a list of all games
  Future<void> fetchGames() async {
    _setLoading(true);
    try {
      _games = await _gameRepository.getGames();
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
      _games = []; // Clear games on error
    } finally {
      _setLoading(false);
    }
  }

  // Fetch details for a specific game
  Future<void> fetchGameDetail(String gameId) async {
    _setLoading(true);
    try {
      _gameDetail = await _gameRepository.getGameDetail(gameId);
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
      _gameDetail = null; // Clear game detail on error
    } finally {
      _setLoading(false);
    }
  }

  // Create a new game
  Future<void> createGame(Game game) async {
    _setLoading(true);
    try {
      final createdGame = await _gameRepository.createGame(game);
      // Optionally update the games list after creating a game
      _games.add(createdGame); // Add to the local list
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
      rethrow; // Re-throw to be caught by the UI
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing game
  Future<void> updateGame(String gameId, Game game) async {
    _setLoading(true);
    try {
      final updatedGame = await _gameRepository.updateGame(gameId, game);
      // Optionally update the game in the local list and game detail
      final index = _games.indexWhere((g) => g.id.toString() == gameId);
      if (index != -1) {
        _games[index] = updatedGame;
      }
      if (_gameDetail?.id.toString() == gameId) {
        _gameDetail = updatedGame;
      }
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
      rethrow; // Re-throw to be caught by the UI
    } finally {
      _setLoading(false);
    }
  }

  // Delete a game
  Future<void> deleteGame(String gameId) async {
    _setLoading(true);
    try {
      await _gameRepository.deleteGame(gameId);
      // Remove the game from the local list
      _games.removeWhere((g) => g.id.toString() == gameId);
      _gameDetail = null; // Clear game detail if the deleted game was being viewed
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
      rethrow; // Re-throw to be caught by the UI
    } finally {
      _setLoading(false);
    }
  }

  // ===================================================
  // Methods for managing Questions within a Game (via gameDetail)
  // ===================================================

  // Add a new question to a game (usually called after creating it)
  Future<void> addQuestionToGame(String gameId, Question question) async {
    // This would typically be called from the GameDetailScreen or GameCreateScreen
    _setLoading(true);
    try {
      final addedQuestion = await _gameRepository.addQuestionToGame(gameId, question);
      // Optionally update the gameDetail with the new question
      // This might require refetching the game detail or manually adding the question
      await fetchGameDetail(gameId); // Refetch for simplicity to ensure state is correct
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing question within the current gameDetail
  Future<void> updateQuestion(String questionId, Question question) async {
    _setLoading(true);
    try {
      final updatedQuestion = await _gameRepository.updateQuestion(questionId, question);

      // Safely update the question within the loaded gameDetail if it exists
      final questionsList = _gameDetail?.questions; // Get the questions list safely
      if (questionsList != null) { // Check if the list itself exists
        final questionIndex = questionsList.indexWhere((q) => q.id.toString() == questionId);
        if (questionIndex != -1) {
          // Update the question in the list
          questionsList[questionIndex] = updatedQuestion;
          // Since List is mutable, this updates the list instance within _gameDetail
          // Depending on your state management, you MIGHT need to trigger a deeper update
          // For Provider, calling notifyListeners() might be enough to rebuild consumers
          notifyListeners(); // Notify listeners that state MIGHT have changed
        }
      }

      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
      rethrow; // Re-throw to be caught by the UI
    } finally {
      _setLoading(false);
    }
  }

  // Delete an existing question from the current gameDetail
  Future<void> deleteQuestion(String questionId) async {
    _setLoading(true);
    try {
      await _gameRepository.deleteQuestion(questionId);

      // Safely remove the question from the loaded gameDetail if it exists
      final questionsList = _gameDetail?.questions; // Get the questions list safely
      if (questionsList != null) { // Check if the list itself exists
        // Remove the question from the list
        questionsList.removeWhere((q) => q.id.toString() == questionId);
        // Since List is mutable, this updates the list instance within _gameDetail
      }

      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
      rethrow; // Re-throw to be caught by the UI
    } finally {
      _setLoading(false);
    }
  }
}
