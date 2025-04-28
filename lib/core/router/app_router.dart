// lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/game/presentation/screens/game_list_screen.dart';
import '../../features/game/presentation/screens/game_create_screen.dart';
import '../../features/game/presentation/screens/game_detail_screen.dart';
import '../../features/session/presentation/screens/session_lobby_screen.dart';
import '../../features/session/presentation/screens/session_play_screen.dart';
import '../../features/session/presentation/screens/session_results_screen.dart';
import '../../features/leaderboard/presentation/leaderboard_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../constants/route_names.dart';
import 'route_guards.dart'; // Import the route guards

class AppRouter {
  // Define the GoRouter instance
  static final GoRouter router = GoRouter(
    // Root redirect for handling initial authentication check
    redirect: (context, state) => authGuard(context, state),
    
    // Define all application routes
    routes: [
      // Authentication Routes (no authentication required)
      _buildAuthRoutes(),
      
      // Core Feature Routes (authentication required)
      _buildGameRoutes(),
      _buildSessionRoutes(),
      _buildProfileRoutes(),
      
      // Error handling route
      _buildErrorRoute(),
    ],
    
    // Global error builder for navigation errors
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Navigation Error')),
      body: Center(child: Text('Could not navigate to the requested page: ${state.error}')),
    ),
  );
  
  // Authentication related routes
  static GoRoute _buildAuthRoutes() {
    return GoRoute(
      path: '/',
      builder: (_, __) => const SizedBox(), // Empty placeholder
      routes: [
        GoRoute(
          name: RouteNames.login,
          path: RouteNames.login.substring(1), // Remove leading slash
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
          name: RouteNames.register,
          path: RouteNames.register.substring(1), // Remove leading slash
          builder: (context, state) => RegisterScreen(),
        ),
      ],
    );
  }
  
  // Game related routes
  static GoRoute _buildGameRoutes() {
    return GoRoute(
      path: '/games',
      builder: (_, __) => const SizedBox(), // Empty placeholder
      redirect: (context, state) => authGuard(context, state),
      routes: [
        GoRoute(
          name: RouteNames.gameList,
          path: 'list',
          builder: (context, state) => GameListScreen(),
        ),
        GoRoute(
          name: RouteNames.gameCreate,
          path: 'create',
          builder: (context, state) => GameCreateScreen(),
        ),
        GoRoute(
          name: RouteNames.gameDetail,
          path: 'detail/:id',
          builder: (context, state) {
            final gameId = state.pathParameters['id'];
            if (gameId == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: const Center(child: Text('Game ID is missing.')),
              );
            }
            return GameDetailScreen(gameId: gameId);
          },
          redirect: (context, state) {
            final authRedirect = authGuard(context, state);
            if (authRedirect != null) return authRedirect;
            // TODO: Add game ownership guard here
            return null;
          },
        ),
      ],
    );
  }
  
  // Session related routes
  static GoRoute _buildSessionRoutes() {
    return GoRoute(
      path: '/sessions',
      builder: (_, __) => const SizedBox(), // Empty placeholder
      redirect: (context, state) => authGuard(context, state),
      routes: [
        GoRoute(
          name: RouteNames.sessionLobby,
          path: 'lobby/:id',
          builder: (context, state) {
            final sessionId = state.pathParameters['id'];
            if (sessionId == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: const Center(child: Text('Session ID is missing for Lobby.')),
              );
            }
            return SessionLobbyScreen(sessionId: sessionId);
          },
          redirect: (context, state) {
            final authRedirect = authGuard(context, state);
            if (authRedirect != null) return authRedirect;
            // TODO: Add session player/owner guard
            return null;
          },
        ),
        GoRoute(
          name: RouteNames.sessionPlay,
          path: 'play/:id',
          builder: (context, state) {
            final sessionId = state.pathParameters['id'];
            if (sessionId == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: const Center(child: Text('Session ID is missing for Play.')),
              );
            }
            return SessionPlayScreen(sessionId: sessionId);
          },
          redirect: (context, state) {
            final authRedirect = authGuard(context, state);
            if (authRedirect != null) return authRedirect;
            // TODO: Add session player guard
            return null;
          },
        ),
        GoRoute(
          name: RouteNames.sessionResults,
          path: 'results/:id',
          builder: (context, state) {
            final sessionId = state.pathParameters['id'];
            if (sessionId == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: const Center(child: Text('Session ID is missing for Results.')),
              );
            }
            return SessionResultsScreen(sessionId: sessionId);
          },
          redirect: (context, state) {
            final authRedirect = authGuard(context, state);
            if (authRedirect != null) return authRedirect;
            // TODO: Add session player/owner guard
            return null;
          },
        ),
        GoRoute(
          name: RouteNames.leaderboard,
          path: 'leaderboard/:id',
          builder: (context, state) {
            final sessionId = state.pathParameters['id'];
            if (sessionId == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: const Center(child: Text('Session ID is missing for Leaderboard.')),
              );
            }
            return LeaderboardScreen(sessionId: sessionId);
          },
          redirect: (context, state) {
            final authRedirect = authGuard(context, state);
            if (authRedirect != null) return authRedirect;
            // TODO: Add session player/owner guard
            return null;
          },
        ),
      ],
    );
  }
  
  // Profile related routes
  static GoRoute _buildProfileRoutes() {
    return GoRoute(
      name: RouteNames.profile,
      path: RouteNames.profile,
      builder: (context, state) => ProfileScreen(),
      redirect: (context, state) => authGuard(context, state),
    );
  }
  
  // Error handling route
  static GoRoute _buildErrorRoute() {
    return GoRoute(
      path: '/error',
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('An unexpected error occurred.')),
      ),
    );
  }
}