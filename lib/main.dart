// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package

// Import core services
import 'package:gamification_trivia/core/services/api/api_client.dart';
import 'package:gamification_trivia/core/services/local_storage.dart';

// Import data sources
import 'package:gamification_trivia/data/data_sources/auth_data_source.dart';
import 'package:gamification_trivia/data/data_sources/game_remote_data_source.dart';
import 'package:gamification_trivia/data/data_sources/local_data_source.dart'; // Import LocalDataSource
// TODO: Import other data sources if they are created (e.g., NotificationDataSource, UserRemoteDataSource)

// Import repositories
import 'package:gamification_trivia/data/repositories/auth_repository.dart';
import 'package:gamification_trivia/data/repositories/game_repository.dart';
import 'package:gamification_trivia/data/repositories/session_repository.dart';
// TODO: Import other repositories if they are created (e.g., NotificationRepository, UserRepository, LeaderboardRepository)

// Import application notifiers
// Ensure these files exist in the specified paths relative to your 'lib' directory
import 'package:gamification_trivia/features/auth/application/auth_notifier.dart';
import 'package:gamification_trivia/features/game/application/game_notifier.dart';
import 'package:gamification_trivia/features/session/application/session_notifier.dart';
import 'package:gamification_trivia/features/leaderboard/application/leaderboard_notifier.dart'; // Import LeaderboardNotifier
import 'package:gamification_trivia/features/profile/application/profile_notifier.dart';

// Import the main app widget
import 'package:gamification_trivia/app.dart';


void main() async {
  // Ensure Flutter binding is initialized before using any plugins (like SharedPreferences)
  WidgetsFlutterBinding.ensureInitialized();

  // --- Initialize Core Services ---
  final localStorage = LocalStorage();
  // ApiClient needs LocalStorage to potentially retrieve auth tokens for requests
  final apiClient = ApiClient(localStorage);

  // --- Initialize Data Sources ---
  // Data sources depend on core services like ApiClient or LocalStorage
  final authDataSource = AuthDataSource(apiClient);
  final gameRemoteDataSource = GameRemoteDataSource(apiClient);
  final localDataSource = LocalDataSource(localStorage); // LocalDataSource depends on LocalStorage
  // TODO: Initialize other data sources (e.g., NotificationDataSource(apiClient), UserRemoteDataSource(apiClient))

  // --- Initialize Repositories ---
  // Repositories depend on data sources to fetch/send data
  final authRepository = AuthRepository(authDataSource, localStorage); // AuthRepository also uses LocalStorage directly for token
  final gameRepository = GameRepository(gameRemoteDataSource);
  // SessionRepository currently uses GameRemoteDataSource for session-related calls
  final sessionRepository = SessionRepository(gameRemoteDataSource);
  // TODO: Initialize other repositories (e.g., NotificationRepository(notificationDataSource), UserRepository(userRemoteDataSource, localDataSource), LeaderboardRepository(gameRemoteDataSource or a dedicated source))

  // --- Initialize Notifiers ---
  // Notifiers depend on repositories to perform business logic and manage state
  final authNotifier = AuthNotifier(authRepository: authRepository);
  final gameNotifier = GameNotifier(gameRepository: gameRepository);
  // SessionNotifier needs both SessionRepository and AuthRepository to check user ownership/participation
  final sessionNotifier = SessionNotifier(sessionRepository: sessionRepository, authRepository: authRepository);
  // LeaderboardNotifier currently doesn't have dependencies based on the placeholder,
  // but would need a repository if fetching global/game leaderboards.
  final leaderboardNotifier = LeaderboardNotifier(); // Update constructor if dependencies are added
  // ProfileNotifier currently doesn't have dependencies based on the placeholder,
  // but would need a repository if fetching/updating additional profile data.
  final profileNotifier = ProfileNotifier(); // Update constructor if dependencies are added
  // NotificationNotifier currently doesn't have dependencies based on the placeholder,
  // but would need a repository if fetching notifications.


  // --- Initial Authentication Check ---
  // Check authentication status on app startup to determine the initial route
  await authNotifier.checkAuthStatus();


  // --- Run the Application ---
  runApp(
    // Use MultiProvider to provide multiple dependencies to the widget tree
    MultiProvider(
      providers: [
        // Provide repositories (often stateless, can be singletons)
        // Use Provider for instances that don't change
        Provider<AuthRepository>(create: (_) => authRepository),
        Provider<GameRepository>(create: (_) => gameRepository),
        Provider<SessionRepository>(create: (_) => sessionRepository),
        // TODO: Provide other repositories if initialized

        // Provide notifiers (stateful, use ChangeNotifierProvider)
        // Use ChangeNotifierProvider for instances that manage state and notify listeners
        ChangeNotifierProvider(create: (_) => authNotifier),
        ChangeNotifierProvider(create: (_) => gameNotifier),
        ChangeNotifierProvider(create: (_) => sessionNotifier),
        ChangeNotifierProvider(create: (_) => leaderboardNotifier),
        ChangeNotifierProvider(create: (_) => profileNotifier),
      ],
      child: MyApp(), // Your main application widget, which uses the provided dependencies
    ),
  );
}
