// lib/core/services/api/api_endpoints.dart
class ApiEndpoints {
  // Authentication Endpoints
  static const String register = '/register'; // Endpoint for user registration
  static const String login = '/login'; // Endpoint for user login
  static const String logout = '/logout'; // Endpoint for user logout
  static const String user = '/user'; // Endpoint to get authenticated user details

  // Game Endpoints
  static const String games = '/games'; // Endpoint to list and create games
  static String gameDetail(String id) => '/games/$id'; // Endpoint for a specific game (GET, PUT, DELETE)

  // Session Endpoints
  static String gameSessions(String gameId) => '/games/$gameId/sessions'; // Endpoint to create a session for a specific game
  static const String joinSession = '/game-sessions/join'; // Endpoint for a player to join a session using a code
  static String sessionDetail(String id) => '/game-sessions/$id'; // Endpoint for a specific game session (GET)
  static String startSession(String id) => '/game-sessions/$id/start'; // Endpoint to start a game session (by owner)
  static String finishSession(String id) => '/game-sessions/$id/finish'; // Endpoint to finish a game session (by owner)
  static String submitAnswer(String sessionId) => '/game-sessions/$sessionId/answer'; // Endpoint for a player to submit an answer during a session
  static String sessionLeaderboard(String id) => '/game-sessions/$id/leaderboard'; // Endpoint to get the leaderboard for a finished session

  // Question Endpoints (assuming nested under games or separate as per backend structure)
  static String gameQuestions(String gameId) => '/games/$gameId/questions'; // Endpoint to list and store questions for a specific game
  static String questionDetail(String questionId) => '/questions/$questionId'; // Endpoint for a specific question (GET, PUT, DELETE)

  // Invitation Endpoints (Based on PDF feature list - placeholders)
  // These endpoints are based on the "Invitation Module" mentioned in the PDF.
  // Adjust paths based on actual backend implementation.
  static const String invitations = '/invitations'; // Endpoint to list invitations (e.g., received)
  static const String sendInvitation = '/invitations'; // Endpoint to send an invitation (e.g., POST with game_id and recipient_email/username)
  static String invitationDetail(String id) => '/invitations/$id'; // Endpoint for a specific invitation (GET, DELETE)
  static String acceptInvitation(String id) => '/invitations/$id/accept'; // Endpoint to accept an invitation
  static String rejectInvitation(String id) => '/invitations/$id/reject'; // Endpoint to reject an invitation


  // Notification Endpoints (Based on PDF feature list - placeholders)
  // These endpoints are based on the "Notifications" feature mentioned in the PDF.
  // Adjust paths based on actual backend implementation.
  static const String notifications = '/notifications'; // Endpoint to list notifications for the authenticated user
  static String notificationDetail(String id) => '/notifications/$id'; // Endpoint for a specific notification (GET)
  static String markNotificationAsRead(String id) => '/notifications/$id/mark-as-read'; // Endpoint to mark a specific notification as read
  static const String markAllNotificationsAsRead = '/notifications/mark-all-as-read'; // Endpoint to mark all notifications as read


  // TODO: Add other endpoints as the backend API evolves (e.g., for user profiles, game history, global leaderboard if separate)
}
