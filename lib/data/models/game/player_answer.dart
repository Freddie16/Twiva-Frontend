// lib/data/models/game/player_answer.dart
class PlayerAnswer {
  final int id;
  final int gameSessionPlayerId;
  final int questionId;
  final int? answerId; // Nullable if question was skipped
  final bool isCorrect;

  PlayerAnswer({
    required this.id,
    required this.gameSessionPlayerId,
    required this.questionId,
    this.answerId,
    required this.isCorrect,
  });

  factory PlayerAnswer.fromJson(Map<String, dynamic> json) {
    return PlayerAnswer(
      id: json['id'],
      gameSessionPlayerId: json['game_session_player_id'],
      questionId: json['question_id'],
      answerId: json['answer_id'],
      isCorrect: json['is_correct'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_session_player_id': gameSessionPlayerId,
      'question_id': questionId,
      'answer_id': answerId,
      'is_correct': isCorrect,
    };
  }
}