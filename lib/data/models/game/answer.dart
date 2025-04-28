// lib/data/models/game/answer.dart
class Answer {
  final int id;
  final String answerText;
  final bool isCorrect;

  Answer({
    required this.id,
    required this.answerText,
    required this.isCorrect,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      answerText: json['answer_text'],
      isCorrect: json['is_correct'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answer_text': answerText,
      'is_correct': isCorrect,
    };
  }
}