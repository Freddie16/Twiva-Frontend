// lib/features/session/presentation/screens/session_lobby_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gamification_trivia/widgets/templates/base_screen.dart';
import 'package:gamification_trivia/widgets/shared/loading_indicator.dart';
import 'package:gamification_trivia/widgets/shared/app_button.dart';
import 'package:gamification_trivia/features/session/application/session_notifier.dart';
import 'package:gamification_trivia/core/utils/extensions/build_context_extensions.dart';
// Corrected import path for RouteNames
import 'package:gamification_trivia/core/constants/route_names.dart'; // Assuming your package name is gamification_trivia
import 'package:go_router/go_router.dart';
// Corrected import path for DialogUtils
import 'package:gamification_trivia/core/utils/dialog_utils.dart'; // Assuming your package name is gamification_trivia
import 'package:gamification_trivia/features/auth/application/auth_notifier.dart'; // Import AuthNotifier to check current user
import 'package:gamification_trivia/data/models/user/user.dart'; // Import User model
import 'package:gamification_trivia/data/models/game/game_session.dart'; // Import GameSession model


class SessionLobbyScreen extends StatefulWidget {
  final String sessionId;

  const SessionLobbyScreen({Key? key, required this.sessionId}) : super(key: key);

  @override
  _SessionLobbyScreenState createState() => _SessionLobbyScreenState();
}

class _SessionLobbyScreenState extends State<SessionLobbyScreen> {
  late SessionNotifier _sessionNotifier;
  late AuthNotifier _authNotifier; // To get the current user


  @override
  void initState() {
    super.initState();
    _sessionNotifier = Provider.of<SessionNotifier>(context, listen: false);
    _authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    // Fetch session details when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sessionNotifier.fetchSessionDetail(widget.sessionId);
    });
     // TODO: Implement real-time updates for player list using WebSockets or polling
  }


   // Async function to handle starting the game
   void _startGame() async {
     // Store the dismiss function from the loading dialog
     VoidCallback? dismissLoading;
     try {
       // Show loading indicator
       dismissLoading = await DialogUtils.showLoadingDialog(context: context, message: 'Starting game...');
       await _sessionNotifier.startGame(widget.sessionId);
       // Dismiss loading indicator on success
       dismissLoading();
        // Navigate to play screen after starting
       context.goNamed(RouteNames.sessionPlay, pathParameters: {'id': widget.sessionId});
     } catch (e) {
        // Dismiss loading indicator on error
        dismissLoading?.call(); // Use ?.call() for null safety
        // Show error message
        context.showSnackBar(e.toString(), backgroundColor: Colors.red);
     }
   }

   // Non-async function to be assigned to onPressed.
   // It checks conditions before calling the async _startGame.
   void _handleStartGame() {
      final session = _sessionNotifier.sessionDetail;
      // Add the player count check here before calling the async function
      if (session != null && (session.players?.length ?? 0) > 1) {
         _startGame();
      } else {
         // Optionally show a message if the button was somehow pressed without enough players
         context.showSnackBar('Need at least 2 players to start', backgroundColor: Colors.orange);
      }
   }


   // Helper to check if the current user is the session owner
   bool _isCurrentUserOwner(GameSession? session, User? currentUser) {
     if (session == null || currentUser == null || session.game?.creator == null) {
       return false;
     }
     return session.game!.creator!.id == currentUser.id;
   }


  @override
  Widget build(BuildContext context) {
    final sessionNotifier = Provider.of<SessionNotifier>(context);
    final authNotifier = Provider.of<AuthNotifier>(context); // Watch AuthNotifier for user changes
    final session = sessionNotifier.sessionDetail;
    final currentUser = authNotifier.user; // Get the current authenticated user

    // Check if the current user is the owner based on fetched session details and current user
    final isCurrentUserOwner = _isCurrentUserOwner(session, currentUser);

    // Determine if the button should be enabled based on ownership and status.
    // The player count check is now handled inside _handleStartGame.
    final bool enableStartButton = session != null &&
                                   isCurrentUserOwner &&
                                   session.status == 'waiting';


    return BaseScreen(
      appBar: AppBar(title: Text(session?.game?.title ?? 'Session Lobby')),
      body: sessionNotifier.isLoading && session == null // Show loading only if session is null and loading
          ? const LoadingIndicator()
          : session == null
              ? const Center(child: Text('Session not found.'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Session Code: ${session.code}', style: context.textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    Text('Status: ${session.status}', style: context.textTheme.titleMedium),
                    const SizedBox(height: 16),
                     Text('Players:', style: context.textTheme.titleLarge),
                     const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: session.players?.length ?? 0,
                        itemBuilder: (context, index) {
                          final player = session.players![index];
                          return ListTile(
                            leading: CircleAvatar(child: Text(player.user?.name[0].toUpperCase() ?? '?')), // Player initial
                            title: Text(player.user?.name ?? 'Unknown Player'),
                            subtitle: Text('Score: ${player.score}'),
                            // TODO: Add more player info if needed (e.g., if they are the owner)
                             trailing: isCurrentUserOwner && player.user?.id != currentUser?.id
                                ? IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                    tooltip: 'Remove Player',
                                    onPressed: () {
                                      // TODO: Implement logic to remove player (if API supports it)
                                       context.showSnackBar('Remove player not implemented');
                                    },
                                  )
                                : null,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (isCurrentUserOwner && session.status == 'waiting')
                       Center(
                         child: AppButton(
                           text: 'Start Game',
                           // Assign _handleStartGame if the button is enabled, otherwise null
                           onPressed: enableStartButton ? _handleStartGame : () {}, // Provide an empty function when disabled
                           isLoading: sessionNotifier.isLoading,
                            // Show tooltip if not enough players (check session.players directly)
                           tooltip: (session.players?.length ?? 0) < 2 ? 'Need at least 2 players to start' : null,
                         ),
                       ),
                       if (session.status == 'active')
                        Center(
                          child: Text('Game is in progress...', style: context.textTheme.titleMedium),
                        ),
                        if (session.status == 'finished')
                         Center(
                           child: Column(
                             children: [
                               Text('Game Finished!', style: context.textTheme.headlineSmall),
                               const SizedBox(height: 16),
                               AppButton(
                                 text: 'View Leaderboard',
                                 onPressed: () {
                                   context.goNamed(RouteNames.leaderboard, pathParameters: {'id': widget.sessionId});
                                 },
                               ),
                             ],
                           ),
                         ),
                  ],
                ),
    );
  }
}
