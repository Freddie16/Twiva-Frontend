// lib/data/models/game/game_session.dart
import 'game.dart';
import 'game_session_player.dart';

class GameSession {
  final int id;
  final Game? game; // Game is included when loaded
  final String code;
  final String status;
  final List<GameSessionPlayer>? players; // Players are included when loaded
  final DateTime createdAt;
  final DateTime updatedAt;

  GameSession({
    required this.id,
    this.game,
    required this.code,
    required this.status,
    this.players,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GameSession.fromJson(Map<String, dynamic> json) {
    return GameSession(
      id: json['id'],
      game: json['game'] != null ? Game.fromJson(json['game']) : null,
      code: json['code'],
      status: json['status'],
      players: json['players'] != null
          ? (json['players'] as List)
              .map((playerJson) => GameSessionPlayer.fromJson(playerJson))
              .toList()
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game': game?.toJson(),
      'code': code,
      'status': status,
      'players': players?.map((player) => player.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}