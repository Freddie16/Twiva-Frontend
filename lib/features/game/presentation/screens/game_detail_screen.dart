// lib/features/game/presentation/screens/game_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gamification_trivia/widgets/templates/base_screen.dart';
import 'package:gamification_trivia/widgets/shared/loading_indicator.dart';
import 'package:gamification_trivia/features/game/application/game_notifier.dart';
import 'package:gamification_trivia/features/session/application/session_notifier.dart'; // Import SessionNotifier for creating sessions
import 'package:gamification_trivia/data/models/game/game.dart';
import 'package:gamification_trivia/data/models/game/question.dart';
import 'package:gamification_trivia/features/game/widgets/question_form.dart';
import 'package:gamification_trivia/core/utils/extensions/build_context_extensions.dart';
// Corrected import path for RouteNames
import 'package:gamification_trivia/core/constants/route_names.dart'; // Assuming your package name is gamification_trivia
import 'package:go_router/go_router.dart';
import 'package:gamification_trivia/widgets/shared/app_button.dart';
// Corrected import path for DialogUtils
import 'package:gamification_trivia/core/utils/dialog_utils.dart'; // Assuming your package name is gamification_trivia
import 'package:gamification_trivia/data/models/game/answer.dart'; // Import Answer model (needed by QuestionForm)


class GameDetailScreen extends StatefulWidget {
  final String gameId;

  const GameDetailScreen({Key? key, required this.gameId}) : super(key: key);

  @override
  _GameDetailScreenState createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  late GameNotifier _gameNotifier;
  // State to manage adding/editing questions
  Question? _editingQuestion;
  bool _isAddingQuestion = false;
  // GlobalKey for the QuestionForm when adding/editing
  final GlobalKey<FormState> _questionFormKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _gameNotifier = Provider.of<GameNotifier>(context, listen: false);
    // Fetch game details when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gameNotifier.fetchGameDetail(widget.gameId);
    });
  }

  void _updateGameStatus(String? status) async {
     if (_gameNotifier.gameDetail == null || status == null || status == _gameNotifier.gameDetail!.status) return;
    // Show confirmation dialog if changing status away from draft
     bool confirmed = true;
     if (_gameNotifier.gameDetail!.status == 'draft' && status != 'draft') {
       confirmed = await DialogUtils.showConfirmationDialog(
         context: context,
         title: 'Publish Game',
         content: 'Are you sure you want to change the status to "$status"?',
       );
     }

     if (confirmed) {
       // Store the dismiss function from the loading dialog
       VoidCallback? dismissLoading;
       try {
         // Show loading indicator
         dismissLoading = await DialogUtils.showLoadingDialog(context: context, message: 'Updating status...');
         // Create a copy of the game with the updated status
         final updatedGame = Game(
           id: _gameNotifier.gameDetail!.id,
           creator: _gameNotifier.gameDetail!.creator,
           title: _gameNotifier.gameDetail!.title,
           description: _gameNotifier.gameDetail!.description,
           status: status, // Update the status
           questions: _gameNotifier.gameDetail!.questions, // Keep existing questions
           createdAt: _gameNotifier.gameDetail!.createdAt,
           updatedAt: DateTime.now(), // Update updated timestamp
         );

         await _gameNotifier.updateGame(widget.gameId, updatedGame);
         // Dismiss loading indicator on success
         dismissLoading();
          context.showSnackBar('Game status updated to $status');
       } catch (e) {
          // Dismiss loading indicator on error
          dismissLoading?.call(); // Use ?.call() for null safety
          // Show error message
          context.showSnackBar(e.toString(), backgroundColor: Colors.red);
       }
     }
  }

  void _deleteGame() async {
     // Show confirmation dialog before deleting
     final confirmed = await DialogUtils.showConfirmationDialog(
       context: context,
       title: 'Delete Game',
       content: 'Are you sure you want to delete this game? This action cannot be undone.',
       confirmButtonColor: Colors.red,
     );

     if (confirmed) {
       // Store the dismiss function from the loading dialog
       VoidCallback? dismissLoading;
       try {
         // Show loading indicator
         dismissLoading = await DialogUtils.showLoadingDialog(context: context, message: 'Deleting game...');
         await _gameNotifier.deleteGame(widget.gameId);
         // Dismiss loading indicator on success
         dismissLoading();
         context.showSnackBar('Game deleted successfully');
         context.goNamed(RouteNames.gameList); // Navigate back to game list
       } catch (e) {
         // Dismiss loading indicator on error
         dismissLoading?.call(); // Use ?.call() for null safety
         // Show error message
         context.showSnackBar(e.toString(), backgroundColor: Colors.red);
       }
     }
  }

   void _startAddingQuestion() {
     setState(() {
       _editingQuestion = null; // Not editing an existing question
       _isAddingQuestion = true;
        // Reset the form key to ensure a fresh form state for a new question
       _questionFormKey.currentState?.reset();
     });
   }

   void _startEditingQuestion(Question question) {
     setState(() {
       _editingQuestion = question; // Set the question to be edited
       _isAddingQuestion = true; // Show the form for editing
        // Reset the form key to ensure a fresh form state for editing
       _questionFormKey.currentState?.reset();
     });
   }

   void _cancelEditing() {
     setState(() {
       _editingQuestion = null;
       _isAddingQuestion = false;
     });
   }


   void _saveQuestion(Question question) async {
     // Validate the question form
     if (_questionFormKey.currentState != null && !_questionFormKey.currentState!.validate()) {
       context.showSnackBar('Please complete question details correctly', backgroundColor: Colors.orange);
       return;
     }

      // Ensure the question has at least one correct answer before saving
     if (!question.answers.any((answer) => answer.isCorrect)) {
        context.showSnackBar('Each question must have at least one correct answer', backgroundColor: Colors.orange);
        return;
     }


     // Store the dismiss function from the loading dialog
     VoidCallback? dismissLoading;
     try {
       // Show loading indicator
       dismissLoading = await DialogUtils.showLoadingDialog(context: context, message: 'Saving question...');
       if (_editingQuestion == null) {
         // Add new question
         await _gameNotifier.addQuestionToGame(widget.gameId, question);
         context.showSnackBar('Question added successfully!');
       } else {
         // Update existing question
         await _gameNotifier.updateQuestion(_editingQuestion!.id.toString(), question);
          context.showSnackBar('Question updated successfully!');
       }
       // Dismiss loading indicator on success
       dismissLoading();
       _cancelEditing(); // Hide the form
     } catch (e) {
       // Dismiss loading indicator on error
       dismissLoading?.call(); // Use ?.call() for null safety
       // Show error message
       context.showSnackBar(e.toString(), backgroundColor: Colors.red);
     }
   }

   void _deleteQuestion(Question question) async {
      // Show confirmation dialog before deleting
     final confirmed = await DialogUtils.showConfirmationDialog(
       context: context,
       title: 'Delete Question',
       content: 'Are you sure you want to delete this question?',
       confirmButtonColor: Colors.red,
     );

     if (confirmed) {
       // Store the dismiss function from the loading dialog
       VoidCallback? dismissLoading;
       try {
         // Show loading indicator
         dismissLoading = await DialogUtils.showLoadingDialog(context: context, message: 'Deleting question...');
         await _gameNotifier.deleteQuestion(question.id.toString());
         // Dismiss loading indicator on success
         dismissLoading();
         context.showSnackBar('Question deleted successfully!');
         _cancelEditing(); // Hide the form if the deleted question was being edited
       } catch (e) {
         // Dismiss loading indicator on error
         dismissLoading?.call(); // Use ?.call() for null safety
         // Show error message
         context.showSnackBar(e.toString(), backgroundColor: Colors.red);
       }
     }
   }


   void _createSession() async {
     if (_gameNotifier.gameDetail == null) return;

      // Check if the game is published before creating a session
     if (_gameNotifier.gameDetail!.status != 'published') {
       DialogUtils.showAlertDialog(
         context: context,
         title: 'Cannot Create Session',
         content: 'Only published games can have sessions.',
       );
       return;
     }

      // Check if the game has questions before creating a session
     if (_gameNotifier.gameDetail!.questions == null || _gameNotifier.gameDetail!.questions!.isEmpty) {
       DialogUtils.showAlertDialog(
         context: context,
         title: 'Cannot Create Session',
         content: 'A game must have at least one question to create a session.',
       );
       return;
     }


     // Store the dismiss function from the loading dialog
     VoidCallback? dismissLoading;
     try {
       // Show loading indicator
       dismissLoading = await DialogUtils.showLoadingDialog(context: context, message: 'Creating session...');
       // Call SessionNotifier to create a new session
       final sessionNotifier = Provider.of<SessionNotifier>(context, listen: false);
       final newSession = await sessionNotifier.createGameSession(widget.gameId);
       // Dismiss loading indicator on success
       dismissLoading();
       context.showSnackBar('Session created! Code: ${newSession.code}');
       // On successful creation, navigate to the session lobby screen
       context.goNamed(RouteNames.sessionLobby, pathParameters: {'id': newSession.id.toString()});
     } catch (e) {
       // Dismiss loading indicator on error
       dismissLoading?.call(); // Use ?.call() for null safety
       // Show error message
       context.showSnackBar(e.toString(), backgroundColor: Colors.red);
     }
   }


  @override
  Widget build(BuildContext context) {
    final gameNotifier = Provider.of<GameNotifier>(context);
    final game = gameNotifier.gameDetail;

    return BaseScreen(
      appBar: AppBar(title: Text(game?.title ?? 'Game Details')),
      body: gameNotifier.isLoading && game == null // Show loading only if game is null and loading
          ? const LoadingIndicator()
          : game == null
              ? const Center(child: Text('Game not found.'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text('Description:', style: context.textTheme.titleMedium),
                       const SizedBox(height: 8),
                       Text(game.description ?? 'No description provided', style: context.textTheme.bodyMedium),
                       const SizedBox(height: 16),
                       Text('Status: ${game.status}', style: context.textTheme.titleMedium),
                       const SizedBox(height: 16),

                       // Show the QuestionForm for adding/editing questions
                       if (_isAddingQuestion)
                         Card(
                           margin: const EdgeInsets.symmetric(vertical: 8),
                           child: Padding(
                             padding: const EdgeInsets.all(16.0),
                             child: QuestionForm(
                               key: _questionFormKey, // Assign key for validation
                               initialQuestion: _editingQuestion,
                               onSave: _saveQuestion,
                               onDelete: () {
                                 if (_editingQuestion != null) {
                                   _deleteQuestion(_editingQuestion!);
                                 } else {
                                   _cancelEditing(); // Just cancel if adding a new question
                                 }
                               },
                               onCancel: _cancelEditing, // Add a cancel button to the form
                             ),
                           ),
                         ),

                       if (!_isAddingQuestion) // Only show questions list and actions if not adding/editing
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text('Questions:', style: context.textTheme.titleLarge),
                             const SizedBox(height: 16),
                             if (game.questions == null || game.questions!.isEmpty)
                                const Text('No questions added yet.'),
                             if (game.questions != null)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: game.questions!.length,
                                itemBuilder: (context, index) {
                                  final question = game.questions![index];
                                  return Card(
                                     margin: const EdgeInsets.symmetric(vertical: 4),
                                     child: ListTile(
                                       title: Text(question.questionText),
                                       subtitle: Text('${question.points} points'),
                                       trailing: Row(
                                         mainAxisSize: MainAxisSize.min,
                                         children: [
                                           IconButton(
                                             icon: const Icon(Icons.edit),
                                             tooltip: 'Edit Question',
                                             onPressed: () => _startEditingQuestion(question),
                                           ),
                                            IconButton(
                                             icon: const Icon(Icons.delete, color: Colors.red),
                                              tooltip: 'Delete Question',
                                             onPressed: () => _deleteQuestion(question),
                                           ),
                                         ],
                                       ),
                                       // TODO: Optionally display answers in the ListTile or a separate view
                                     ),
                                   );
                                },
                              ),
                              const SizedBox(height: 24),
                             Text('Actions:', style: context.textTheme.titleLarge),
                             const SizedBox(height: 16),
                             Center(
                               child: AppButton(
                                 text: 'Add New Question',
                                 onPressed: _startAddingQuestion,
                                  color: Colors.green,
                                ),
                             ),
                             const SizedBox(height: 16),
                             Center(
                               child: AppButton(
                                 text: 'Create Game Session',
                                 onPressed: _createSession,
                                 color: Colors.blue,
                               ),
                             ),
                             const SizedBox(height: 16),
                             DropdownButtonFormField<String>(
                              value: game.status,
                               decoration: const InputDecoration(labelText: 'Update Status'),
                               items: ['draft', 'published', 'archived']
                                  .map((status) => DropdownMenuItem(
                                     value: status,
                                     child: Text(status),
                                   ))
                                  .toList(),
                               onChanged: (newStatus) {
                                 if (newStatus != null) {
                                   _updateGameStatus(newStatus);
                                 }
                               },
                             ),
                             const SizedBox(height: 16),
                             Center(
                               child: AppButton(
                                 text: 'Delete Game',
                                 onPressed: _deleteGame,
                                 color: Colors.red,
                               ),
                             ),
                           ],
                         ),
                    ],
                  ),
                ),
    );
  }
}
