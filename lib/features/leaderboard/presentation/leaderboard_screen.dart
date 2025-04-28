// lib/features/leaderboard/presentation/leaderboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/templates/base_screen.dart';
import '../../../../widgets/shared/loading_indicator.dart';
import '../../../../widgets/shared/app_button.dart';
import '../../session/application/session_notifier.dart'; // Reusing SessionNotifier for session-specific leaderboard
import '../../../../core/utils/extensions/build_context_extensions.dart';
import '../../../../core/router/route_names.dart';
// Corrected import
import 'package:go_router/go_router.dart';
import '../../../../data/models/game/game_session_player.dart'; // Assuming this model is used for leaderboard entries

class LeaderboardScreen extends StatefulWidget {
  final String sessionId; // Assuming this screen will show leaderboard for a specific session

  const LeaderboardScreen({Key? key, required this.sessionId}) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late SessionNotifier _sessionNotifier; // Using SessionNotifier to fetch session leaderboard


  @override
  void initState() {
    super.initState();
    _sessionNotifier = Provider.of<SessionNotifier>(context, listen: false);
    // Fetch leaderboard results when the screen is initialized
    // This assumes the SessionNotifier can fetch leaderboard data independently.
    // If not, we might need a dedicated LeaderboardNotifier and Repository.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sessionNotifier.fetchLeaderboard(widget.sessionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionNotifier = Provider.of<SessionNotifier>(context);
    final leaderboard = sessionNotifier.leaderboard;


    return BaseScreen(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: sessionNotifier.isLoading
          ? const LoadingIndicator()
          : leaderboard.isEmpty
              ? const Center(child: Text('No leaderboard data available yet.'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Session Leaderboard', style: context.textTheme.headlineLarge), // Title indicates session leaderboard
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: leaderboard.length,
                        itemBuilder: (context, index) {
                          final player = leaderboard[index];
                          return ListTile(
                            leading: CircleAvatar(child: Text((index + 1).toString())), // Rank
                            title: Text(player.user?.name ?? 'Unknown Player'),
                            trailing: Text('${player.score} points', style: context.textTheme.titleMedium),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: AppButton(
                        text: 'Back to Session Results', // Button to go back to results or game list
                        onPressed: () {
                          // This will work once the go_router import is correct
                           context.goNamed(RouteNames.sessionResults, pathParameters: {'id': widget.sessionId}); // Navigate back
                        },
                      ),
                    ),
                    // TODO: Implement a way to view Global or Game-specific leaderboards if API supports it
                  ],
                ),
    );
  }
}