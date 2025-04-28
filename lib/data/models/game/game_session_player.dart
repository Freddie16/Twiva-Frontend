// lib/data/models/game/game_session_player.dart
import '../user/user.dart';

class GameSessionPlayer {
  final int id;
  final User? user; // User is included when loaded
  final int score;
  final DateTime joinedAt;

  GameSessionPlayer({
    required this.id,
    this.user,
    required this.score,
    required this.joinedAt,
  });

  factory GameSessionPlayer.fromJson(Map<String, dynamic> json) {
    return GameSessionPlayer(
      id: json['id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      score: json['score'],
      joinedAt: DateTime.parse(json['joined_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'score': score,
      'joined_at': joinedAt.toIso8601String(),
    };
  }
}