// lib/core/router/route_guards.dart
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../features/auth/application/auth_notifier.dart';
import '../../features/game/application/game_notifier.dart'; // Import GameNotifier for game ownership check
import '../../features/session/application/session_notifier.dart'; // Import SessionNotifier for session participation check
import '../constants/route_names.dart';
import '../../data/models/game/game.dart'; // Import Game model
import '../../data/models/game/game_session.dart'; // Import GameSession model


// Basic authentication guard
// Redirects unauthenticated users to login and authenticated users from login/register to game list.
String? authGuard(BuildContext context, GoRouterState state) {
  // Use listen: true here because the redirect needs to react to changes in auth status
  // However, redirects should ideally not cause rebuilds of the widget tree they are redirecting from.
  // A common pattern is to use a ListenableProvider or a separate AuthStatusListener widget
  // wrapping the Router to handle initial redirection based on auth state.
  // For simplicity in this example, we'll use listen: false in the redirect itself,
  // assuming the initial check in main.dart sets the correct starting route.
  // The actual check within the guard logic should be robust.

  final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
  final isAuthenticated = authNotifier.isAuthenticated;

  // Check if the user is trying to access authentication pages (login or register)
  final isAuthenticating = state.matchedLocation == RouteNames.login || state.matchedLocation == RouteNames.register;

  // If authenticated and trying to access auth pages, redirect to game list
  if (isAuthenticated && isAuthenticating) {
    return RouteNames.gameList;
  }

  // If not authenticated and trying to access non-auth pages, redirect to login
  if (!isAuthenticated && !isAuthenticating) {
    return RouteNames.login;
  }

  // Otherwise, allow navigation
  return null;
}

// Guard to check if the authenticated user is the owner of a game
// This guard should be applied to routes like game detail (for editing/deleting)
String? gameOwnerGuard(BuildContext context, GoRouterState state) {
  final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
  final gameNotifier = Provider.of<GameNotifier>(context, listen: false); // Access GameNotifier
  final gameId = state.pathParameters['id'];

  // Ensure gameId is available and user is authenticated
  if (gameId == null || !authNotifier.isAuthenticated || authNotifier.user == null) {
    // If no gameId, not authenticated, or no user, redirect to game list or login
    return authGuard(context, state) ?? RouteNames.gameList;
  }

  // Get the game detail from the notifier (assuming it's already fetched or available)
  // In a real app, you might need to ensure the game detail is loaded here or handle loading state.
  final game = gameNotifier.gameDetail;

  // Check if the game exists and the authenticated user is the creator
  if (game != null && game.id.toString() == gameId && game.creator?.id == authNotifier.user!.id) {
    return null; // Allow navigation if the user is the owner
  } else {
    // If not the owner, redirect to game list or an unauthorized page
    // You might want a specific unauthorized page or show a message.
    // For simplicity, redirecting to game list.
    return RouteNames.gameList;
  }
}

// Guard to check if the authenticated user is a player or the owner of a session
// This guard can be applied to session lobby, play, and results screens.
String? sessionPlayerOwnerGuard(BuildContext context, GoRouterState state) {
  final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
  final sessionNotifier = Provider.of<SessionNotifier>(context, listen: false); // Access SessionNotifier
  final sessionId = state.pathParameters['id'];

  // Ensure sessionId is available and user is authenticated
  if (sessionId == null || !authNotifier.isAuthenticated || authNotifier.user == null) {
    // If no sessionId, not authenticated, or no user, redirect to game list or login
     return authGuard(context, state) ?? RouteNames.gameList; // Redirect to game list or login
  }

  // Get the session detail from the notifier (assuming it's already fetched or available)
  final session = sessionNotifier.sessionDetail;

  // Check if the session exists and the authenticated user is a player or the game creator
  if (session != null && session.id.toString() == sessionId) {
    final isPlayer = session.players?.any((player) => player.user?.id == authNotifier.user!.id) ?? false;
    final isOwner = session.game?.creator?.id == authNotifier.user!.id;

    if (isPlayer || isOwner) {
      return null; // Allow navigation if the user is a player or the owner
    }
  }

  // If not a player or owner, redirect to game list or an unauthorized page
   return RouteNames.gameList; // Redirect to game list
}


// Guard to check if the authenticated user is a player of a session
// This guard can be applied specifically to the session play screen.
String? sessionPlayerGuard(BuildContext context, GoRouterState state) {
  final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
  final sessionNotifier = Provider.of<SessionNotifier>(context, listen: false); // Access SessionNotifier
  final sessionId = state.pathParameters['id'];

  // Ensure sessionId is available and user is authenticated
  if (sessionId == null || !authNotifier.isAuthenticated || authNotifier.user == null) {
    // If no sessionId, not authenticated, or no user, redirect to game list or login
     return authGuard(context, state) ?? RouteNames.gameList; // Redirect to game list or login
  }

  // Get the session detail from the notifier (assuming it's already fetched or available)
  final session = sessionNotifier.sessionDetail;

  // Check if the session exists and the authenticated user is a player
  if (session != null && session.id.toString() == sessionId) {
    final isPlayer = session.players?.any((player) => player.user?.id == authNotifier.user!.id) ?? false;

    if (isPlayer) {
      return null; // Allow navigation if the user is a player
    }
  }

  // If not a player, redirect to the session lobby or an unauthorized page
   return RouteNames.sessionLobby.replaceFirst(':id', sessionId); // Redirect to the session lobby
}
