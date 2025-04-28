// lib/data/models/game/game.dart
import 'question.dart';
import '../user/user.dart';

class Game {
  final int id;
  final User? creator; // Creator is included when loaded in the backend resource
  final String title;
  final String? description;
  final String status;
  final List<Question>? questions; // Questions are included when loaded
  final DateTime createdAt;
  final DateTime updatedAt;

  Game({
    required this.id,
    this.creator,
    required this.title,
    this.description,
    required this.status,
    this.questions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      creator: json['creator'] != null ? User.fromJson(json['creator']) : null,
      title: json['title'],
      description: json['description'],
      status: json['status'],
      questions: json['questions'] != null
          ? (json['questions'] as List)
              .map((questionJson) => Question.fromJson(questionJson))
              .toList()
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator': creator?.toJson(),
      'title': title,
      'description': description,
      'status': status,
      'questions': questions?.map((question) => question.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}