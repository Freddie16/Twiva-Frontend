// lib/data/models/game/question.dart
import 'answer.dart';

class Question {
  final int id;
  final int gameId;
  final String questionText;
  final int points;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.gameId,
    required this.questionText,
    required this.points,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      gameId: json['game_id'],
      questionText: json['question_text'],
      points: json['points'],
      answers: (json['answers'] as List)
          .map((answerJson) => Answer.fromJson(answerJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_id': gameId,
      'question_text': questionText,
      'points': points,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}