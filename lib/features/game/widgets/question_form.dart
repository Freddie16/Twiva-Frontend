import 'package:flutter/material.dart';
import 'package:gamification_trivia/data/models/game/question.dart';
import 'package:gamification_trivia/data/models/game/answer.dart';
import 'package:gamification_trivia/widgets/shared/app_text_field.dart';
import 'package:gamification_trivia/widgets/shared/app_button.dart';
import 'package:gamification_trivia/core/utils/validators/form_validators.dart';

class QuestionForm extends StatefulWidget {
  final Question? initialQuestion;
  final ValueChanged<Question> onSave;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const QuestionForm({
    super.key,
    this.initialQuestion,
    required this.onSave,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionController;
  late final TextEditingController _pointsController;
  late List<TextEditingController> _answerControllers;
  late List<bool> _isCorrectList;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _questionController = TextEditingController(
      text: widget.initialQuestion?.questionText ?? ''
    );
    
    _pointsController = TextEditingController(
      text: widget.initialQuestion?.points.toString() ?? '10'
    );

    _answerControllers = widget.initialQuestion?.answers
        .map((a) => TextEditingController(text: a.answerText))
        .toList() ?? [TextEditingController(), TextEditingController()];

    _isCorrectList = widget.initialQuestion?.answers
        .map((a) => a.isCorrect)
        .toList() ?? [false, false];
  }

  @override
  void dispose() {
    _questionController.dispose();
    _pointsController.dispose();
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addAnswerField() => setState(() {
    _answerControllers.add(TextEditingController());
    _isCorrectList.add(false);
  });

  void _removeAnswerField(int index) => setState(() {
    _answerControllers.removeAt(index).dispose();
    _isCorrectList.removeAt(index);
  });

  void _toggleCorrectAnswer(int index) => setState(() {
    for (int i = 0; i < _isCorrectList.length; i++) {
      _isCorrectList[i] = i == index;
    }
  });

  void _saveQuestion() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(Question(
        id: widget.initialQuestion?.id ?? 0,
        gameId: widget.initialQuestion?.gameId ?? 0,
        questionText: _questionController.text,
        points: int.parse(_pointsController.text),
        answers: _buildAnswers(),
      ));
    }
  }

  List<Answer> _buildAnswers() {
    return List.generate(_answerControllers.length, (index) => Answer(
      id: widget.initialQuestion?.answers[index].id ?? 0,
      answerText: _answerControllers[index].text,
      isCorrect: _isCorrectList[index],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: _questionController,
            labelText: 'Question Text',
            validator: FormValidators.required,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _pointsController,
            labelText: 'Points',
            keyboardType: TextInputType.number,
            validator: FormValidators.compose([
              FormValidators.required,
              FormValidators.isPositiveNumber,
            ]),
          ),
          const SizedBox(height: 24),
          _buildAnswerFields(),
          const SizedBox(height: 16),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildAnswerFields() {
    return Column(
      children: [
        Text('Answers:', style: Theme.of(context).textTheme.titleMedium),
        ...List.generate(_answerControllers.length, (index) => 
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _answerControllers[index],
                    labelText: 'Answer ${index + 1}',
                    validator: FormValidators.required,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    color: _isCorrectList[index] ? Colors.green : Colors.grey,
                  ),
                  onPressed: () => _toggleCorrectAnswer(index),
                ),
                if (_answerControllers.length > 2)
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _removeAnswerField(index),
                  ),
              ],
            ),
          ),
        ),
        AppButton(
          text: 'Add Answer',
          onPressed: _addAnswerField,
          color: Colors.blueGrey,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppButton(
            text: 'Cancel',
            onPressed: widget.onCancel,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppButton(
            text: widget.initialQuestion == null ? 'Save' : 'Update',
            onPressed: _saveQuestion,
          ),
        ),
        if (widget.initialQuestion != null) ...[
          const SizedBox(width: 16),
          Expanded(
            child: AppButton(
              text: 'Delete',
              onPressed: widget.onDelete,
              color: Colors.red,
            ),
          ),
        ]
      ],
    );
  }
}