// lib/features/game/presentation/screens/game_create_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gamification_trivia/widgets/templates/base_screen.dart';
import 'package:gamification_trivia/widgets/shared/app_text_field.dart';
import 'package:gamification_trivia/widgets/shared/app_button.dart';
import 'package:gamification_trivia/core/utils/validators/form_validators.dart';
import 'package:gamification_trivia/data/models/game/game.dart';
import 'package:gamification_trivia/data/models/game/question.dart';
import 'package:gamification_trivia/features/game/application/game_notifier.dart';
import 'package:gamification_trivia/core/constants/route_names.dart';
import 'package:gamification_trivia/core/utils/extensions/build_context_extensions.dart';
import 'package:gamification_trivia/core/utils/dialog_utils.dart';
import 'package:gamification_trivia/features/game/widgets/question_form.dart';

class GameCreateScreen extends StatefulWidget {
  @override
  _GameCreateScreenState createState() => _GameCreateScreenState();
}

class _GameCreateScreenState extends State<GameCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<Question> _questions = [];
  List<GlobalKey<FormState>> _questionFormKeys = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _questionFormKeys.clear();
    super.dispose();
  }

  void _addQuestionForm() {
    setState(() {
      _questions.add(Question(id: 0, gameId: 0, questionText: '', points: 0, answers: []));
      _questionFormKeys.add(GlobalKey<FormState>());
    });
  }

  void _updateQuestion(int index, Question updatedQuestion) {
    setState(() {
      _questions[index] = updatedQuestion;
    });
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
      _questionFormKeys.removeAt(index);
    });
  }

  void _createGame() async {
    if (!_formKey.currentState!.validate()) {
      context.showSnackBar('Please fill in game details', backgroundColor: Colors.orange);
      return;
    }

    bool allQuestionsValid = _questionFormKeys.every((key) => key.currentState?.validate() ?? false);
    if (!allQuestionsValid) {
      context.showSnackBar('Please complete all question details correctly', backgroundColor: Colors.orange);
      return;
    }

    if (_questions.isEmpty) {
      context.showSnackBar('Please add at least one question to the game', backgroundColor: Colors.orange);
      return;
    }

    bool hasCorrectAnswer = _questions.every((q) => q.answers.any((a) => a.isCorrect));
    if (!hasCorrectAnswer) {
      context.showSnackBar('Each question must have at least one correct answer', backgroundColor: Colors.orange);
      return;
    }

    final newGame = Game(
      id: 0,
      title: _titleController.text,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      status: 'draft',
      questions: _questions,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final gameNotifier = Provider.of<GameNotifier>(context, listen: false);
    VoidCallback? dismissLoading;

    try {
      dismissLoading = await DialogUtils.showLoadingDialog(context: context, message: 'Creating game...');
      await gameNotifier.createGame(newGame);
      dismissLoading();
      context.showSnackBar('Game created successfully!');
      context.goNamed(RouteNames.gameList);
    } catch (e) {
      dismissLoading?.call();
      context.showSnackBar(e.toString(), backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameNotifier = Provider.of<GameNotifier>(context);
    return BaseScreen(
      appBar: AppBar(title: const Text('Create New Game')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(
                    controller: _titleController,
                    labelText: 'Game Title',
                    validator: FormValidators.required,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _descriptionController,
                    labelText: 'Game Description (Optional)',
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Questions', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _questions.length,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: QuestionForm(
                    key: _questionFormKeys[index],
                    initialQuestion: _questions[index],
                    onSave: (updatedQuestion) => _updateQuestion(index, updatedQuestion),
                    onDelete: () => _deleteQuestion(index),
                    onCancel: () { // Add this line
    // Add logic here if needed, e.g., remove the question
    // _deleteQuestion(index); // Uncomment if cancel means delete
  },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: AppButton(
                text: 'Add Question',
                onPressed: _addQuestionForm,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: gameNotifier.isLoading
                  ? const CircularProgressIndicator()
                  : AppButton(
                      text: 'Create Game',
                      onPressed: _createGame,
                      isLoading: gameNotifier.isLoading,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}