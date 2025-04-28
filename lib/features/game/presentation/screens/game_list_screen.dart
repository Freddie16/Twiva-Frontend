// lib/features/game/presentation/screens/game_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gamification_trivia/widgets/templates/base_screen.dart';
import 'package:gamification_trivia/widgets/shared/loading_indicator.dart';
import 'package:gamification_trivia/features/game/application/game_notifier.dart';
import 'package:gamification_trivia/features/session/application/session_notifier.dart'; // Import SessionNotifier
import 'package:gamification_trivia/features/game/widgets/game_card.dart';
// Corrected import path for RouteNames
import 'package:gamification_trivia/core/constants/route_names.dart'; // Assuming your package name is gamification_trivia
import 'package:go_router/go_router.dart';
import 'package:gamification_trivia/core/utils/extensions/build_context_extensions.dart';
// Corrected import path for DialogUtils
import 'package:gamification_trivia/core/utils/dialog_utils.dart'; // Assuming your package name is gamification_trivia
import 'package:gamification_trivia/core/utils/validators/form_validators.dart'; // Import FormValidators


class GameListScreen extends StatefulWidget {
  @override
  _GameListScreenState createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch games when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameNotifier>(context, listen: false).fetchGames();
    });
  }

  // Method to show a dialog to join a session using a code
  void _showJoinSessionDialog() async {
    // Example of using the Input Dialog from DialogUtils
    final sessionCode = await DialogUtils.showInputDialog(
      context: context,
      title: 'Join Session',
      hintText: 'Enter session code',
      validator: FormValidators.required, // Session code is required
      confirmButtonText: 'Join',
    );

    if (sessionCode != null && sessionCode.isNotEmpty) {
      final sessionNotifier = Provider.of<SessionNotifier>(context, listen: false);
      // Store the dismiss function from the loading dialog
      VoidCallback? dismissLoading;
      try {
        // Show loading indicator
        dismissLoading = await DialogUtils.showLoadingDialog(context: context, message: 'Joining session...');
        // Call SessionNotifier to join the session
        final session = await sessionNotifier.joinGameSession(sessionCode);
        // Dismiss loading indicator on success
        dismissLoading();
        // On successful join, navigate to the session lobby
        context.goNamed(RouteNames.sessionLobby, pathParameters: {'id': session.id.toString()});
      } catch (e) {
        // Dismiss loading indicator on error
        dismissLoading?.call(); // Use ?.call() for null safety
        // Show error if joining fails
        context.showSnackBar(e.toString(), backgroundColor: Colors.red);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final gameNotifier = Provider.of<GameNotifier>(context);

    return BaseScreen(
      appBar: AppBar(
        title: const Text('Trivia Games'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create New Game',
            onPressed: () {
              context.goNamed(RouteNames.gameCreate); // Navigate to create game screen
            },
          ),
           IconButton(
            icon: const Icon(Icons.group_add), // Icon for joining a session
            tooltip: 'Join Session',
            onPressed: _showJoinSessionDialog, // Show dialog to enter session code
          ),
        ],
      ),
      body: gameNotifier.isLoading
          ? const LoadingIndicator()
          : gameNotifier.games.isEmpty
              ? const Center(child: Text('No games found. Create one!'))
              : ListView.builder(
                  itemCount: gameNotifier.games.length,
                  itemBuilder: (context, index) {
                    final game = gameNotifier.games[index];
                    return GameCard(
                      game: game,
                      onTap: () {
                        // Navigate to game detail, passing the game ID
                        context.goNamed(RouteNames.gameDetail, pathParameters: {'id': game.id.toString()});
                      },
                    );
                  },
                ),
    );
  }
}
