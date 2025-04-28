// lib/features/session/presentation/screens/session_play_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gamification_trivia/widgets/templates/base_screen.dart';
import 'package:gamification_trivia/widgets/shared/loading_indicator.dart';
import 'package:gamification_trivia/widgets/shared/app_button.dart';
import 'package:gamification_trivia/features/session/application/session_notifier.dart';
import 'package:gamification_trivia/features/auth/application/auth_notifier.dart'; // Import AuthNotifier
import 'package:gamification_trivia/core/utils/extensions/build_context_extensions.dart';
// Corrected import path for RouteNames
import 'package:gamification_trivia/core/constants/route_names.dart'; // Assuming your package name is gamification_trivia
import 'package:go_router/go_router.dart';
import 'package:gamification_trivia/data/models/game/question.dart';
import 'package:gamification_trivia/data/models/game/answer.dart';
// Corrected import paths for AnswerTile and TimerWidget
import 'package:gamification_trivia/features/session/presentation/widgets/answer_tile.dart'; // Corrected import
import 'package:gamification_trivia/features/session/presentation/widgets/timer_widget.dart'; // Corrected import
// Corrected import path for DialogUtils
import 'package:gamification_trivia/core/utils/dialog_utils.dart'; // Assuming your package name is gamification_trivia


class SessionPlayScreen extends StatefulWidget {
  final String sessionId;

  const SessionPlayScreen({Key? key, required this.sessionId}) : super(key: key);

  @override
  _SessionPlayScreenState createState() => _SessionPlayScreenState();
}

class _SessionPlayScreenState extends State<SessionPlayScreen> {
  late SessionNotifier _sessionNotifier;
  int _currentQuestionIndex = 0;
  bool _hasAnswered = false;
  bool _showAnswerFeedback = false;
  bool? _lastAnswerCorrect;
  // Keep track of the selected answer ID for feedback
  int? _selectedAnswerId;
  // Timer key to reset the timer on each question
  Key _timerKey = UniqueKey();


  @override
  void initState() {
    super.initState();
    _sessionNotifier = Provider.of<SessionNotifier>(context, listen: false);
    // Fetch session details to get game and questions
     WidgetsBinding.instance.addPostFrameCallback((_) {
      _sessionNotifier.fetchSessionDetail(widget.sessionId);
    });
     // TODO: Implement real-time updates for game progress/next question using WebSockets or polling
  }

  void _submitAnswer(int questionId, int? answerId) async {
    if (_hasAnswered) return; // Prevent double submission

    setState(() {
      _hasAnswered = true;
      _selectedAnswerId = answerId; // Store the selected answer ID
      _showAnswerFeedback = true;
    });

    // Optional: Show a brief indicator or disable buttons while submitting
    // VoidCallback? dismissLoading;
    // try {
    //   dismissLoading = await DialogUtils.showLoadingDialog(context: context, message: 'Submitting answer...');
    // } catch (e) {
    //   // Handle error showing dialog if necessary
    // }


    try {
      final playerAnswer = await _sessionNotifier.submitAnswer(widget.sessionId, questionId, answerId);

       setState(() {
         _lastAnswerCorrect = playerAnswer.isCorrect;
       });

       // dismissLoading?.call(); // Dismiss loading indicator

       // Wait for feedback duration before moving to the next question
       Future.delayed(const Duration(seconds: 3), () { // Increased delay for feedback
         _nextQuestion();
       });

    } catch (e) {
       // dismissLoading?.call(); // Make sure dismissLoading is called even on error
       context.showSnackBar(e.toString(), backgroundColor: Colors.red);
       // On error, allow re-answering or move to next question?
       // For simplicity, let's reset state and allow re-answering if it was an API error.
       setState(() {
         _hasAnswered = false;
         _showAnswerFeedback = false;
         _lastAnswerCorrect = null;
         _selectedAnswerId = null;
       });
    }
  }

  void _nextQuestion() {
    final questions = _sessionNotifier.sessionDetail?.game?.questions;
    if (questions != null && _currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _hasAnswered = false;
        _showAnswerFeedback = false;
        _lastAnswerCorrect = null;
        _selectedAnswerId = null;
        _timerKey = UniqueKey(); // Reset the timer by changing the key
      });
    } else {
      // End of game
      _finishGame();
    }
  }

   void _finishGame() async {
     // TODO: Handle game finish - if owner, call finish API, otherwise just navigate to results
     // For players, they just navigate to the results screen when the game ends.
     // The owner might need to call the finish API.
      final sessionNotifier = Provider.of<SessionNotifier>(context, listen: false);
      final authNotifier = Provider.of<AuthNotifier>(context, listen: false); // Need AuthNotifier to check if owner
      final session = sessionNotifier.sessionDetail;
      final currentUser = authNotifier.user;

      if (session != null && currentUser != null && session.game?.creator?.id == currentUser.id) {
         // If current user is the owner, call the finish game API
         // Store the dismiss function from the loading dialog
         VoidCallback? dismissLoading;
         try {
           // Show loading indicator
           dismissLoading = await DialogUtils.showLoadingDialog(context: context, message: 'Finishing game...');
           await sessionNotifier.finishGame(widget.sessionId);
            // Dismiss loading indicator on success
            dismissLoading();
            context.showSnackBar('Game finished!');
            context.goNamed(RouteNames.sessionResults, pathParameters: {'id': widget.sessionId}); // Navigate to results
         } catch (e) {
            // Dismiss loading indicator on error
            dismissLoading?.call(); // Use ?.call() for null safety
            // Show error message
            context.showSnackBar(e.toString(), backgroundColor: Colors.red);
             // Still navigate to results even if finishing API call fails? Depends on desired behavior.
             context.goNamed(RouteNames.sessionResults, pathParameters: {'id': widget.sessionId});
         }
      } else {
        // If not the owner, just navigate to the results screen
        context.goNamed(RouteNames.sessionResults, pathParameters: {'id': widget.sessionId});
      }
   }


  @override
  Widget build(BuildContext context) {
    final sessionNotifier = Provider.of<SessionNotifier>(context);
    final session = sessionNotifier.sessionDetail;
    final questions = session?.game?.questions;
    final currentQuestion = questions != null && questions.isNotEmpty && _currentQuestionIndex < questions.length
        ? questions[_currentQuestionIndex]
        : null;


    return BaseScreen(
      appBar: AppBar(title: Text(session?.game?.title ?? 'Playing Game')),
      body: sessionNotifier.isLoading || session == null || questions == null || currentQuestion == null
          ? const LoadingIndicator()
          : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Timer Widget
                     TimerWidget(
                       key: _timerKey, // Use key to reset timer
                       duration: const Duration(seconds: 20), // Example duration per question
                        onTimerEnd: () {
                          if (!_hasAnswered) {
                            _submitAnswer(currentQuestion.id, null); // Submit null answer if time runs out
                          }
                        },
                     ),
                     const SizedBox(height: 16),
                    Text(
                      'Question ${_currentQuestionIndex + 1}/${questions.length}',
                      style: context.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          currentQuestion.questionText,
                          style: context.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Answers:', style: context.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentQuestion.answers.length,
                        itemBuilder: (context, index) {
                          final answer = currentQuestion.answers[index];
                          return AnswerTile(
                            answer: answer,
                             onTap: _hasAnswered ? null : () => _submitAnswer(currentQuestion.id, answer.id),
                             showFeedback: _showAnswerFeedback,
                             isAnswered: _hasAnswered,
                             isSelected: _selectedAnswerId == answer.id, // Pass if this answer was selected
                             isCorrectAnswer: answer.isCorrect, // Pass if this is the correct answer
                          );
                        },
                      ),
                    ),
                    if (_showAnswerFeedback)
                       Padding(
                         padding: const EdgeInsets.symmetric(vertical: 16.0),
                         child: Center(
                           child: Text(
                             _lastAnswerCorrect == true ? 'Correct!' : (_lastAnswerCorrect == false ? 'Incorrect!' : 'Skipped'),
                             style: context.textTheme.headlineMedium!.copyWith(
                                color: _lastAnswerCorrect == true ? Colors.green : (_lastAnswerCorrect == false ? Colors.red : Colors.orange),
                             ),
                           ),
                         ),
                       ),
                    const SizedBox(height: 16),
                    // Skip button (only visible if not answered and not showing feedback)
                     if (!_hasAnswered && !_showAnswerFeedback)
                       AppButton(
                         text: 'Skip Question',
                         onPressed: () => _submitAnswer(currentQuestion.id, null),
                         color: Colors.orange,
                       ),
                  ],
                ),
    );
  }
}
