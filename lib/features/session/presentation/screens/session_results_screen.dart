// lib/features/session/presentation/screens/session_results_screen.dart
import 'package:flutter/material.dart';
// Corrected import
import 'package:provider/provider.dart';
import '../../../../widgets/templates/base_screen.dart';
import '../../../../widgets/shared/loading_indicator.dart';
import '../../../../widgets/shared/app_button.dart';
import '../../application/session_notifier.dart';
import '../../../../core/utils/extensions/build_context_extensions.dart';
import '../../../../core/router/route_names.dart';
// Corrected import
import 'package:go_router/go_router.dart';


class SessionResultsScreen extends StatefulWidget {
  final String sessionId;

  const SessionResultsScreen({Key? key, required this.sessionId}) : super(key: key);

  @override
  _SessionResultsScreenState createState() => _SessionResultsScreenState();
}

class _SessionResultsScreenState extends State<SessionResultsScreen> {
  late SessionNotifier _sessionNotifier;

  @override
  void initState() {
    super.initState();
    // This will work once the provider import is correct
    _sessionNotifier = Provider.of<SessionNotifier>(context, listen: false);
    // Fetch leaderboard results when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sessionNotifier.fetchLeaderboard(widget.sessionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This will work once the provider import is correct
    final sessionNotifier = Provider.of<SessionNotifier>(context);
    final leaderboard = sessionNotifier.leaderboard;


    return BaseScreen(
      appBar: AppBar(title: const Text('Game Results')),
      body: sessionNotifier.isLoading
          ? const LoadingIndicator()
          : leaderboard.isEmpty
              ? const Center(child: Text('No results available yet.'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Leaderboard', style: context.textTheme.headlineLarge),
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
                        text: 'Back to Games',
                        onPressed: () {
                          // This will work once the go_router import is correct
                          context.goNamed(RouteNames.gameList); // Navigate back to game list
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}