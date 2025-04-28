// lib/features/session/presentation/widgets/answer_tile.dart
import 'package:flutter/material.dart';
import '../../../../data/models/game/answer.dart';
import '../../../../core/theme/app_colors.dart';

class AnswerTile extends StatelessWidget {
  final Answer answer;
  final VoidCallback? onTap;
  final bool showFeedback;
  final bool isAnswered;
  final bool isSelected;
  final bool isCorrectAnswer;


  const AnswerTile({
    Key? key,
    required this.answer,
    this.onTap,
    this.showFeedback = false,
    this.isAnswered = false,
    this.isSelected = false,
    required this.isCorrectAnswer,
  }) : super(key: key);

  Color _getTileColor() {
    if (!isAnswered) {
      return Colors.white; // Default color before answering
    }

    if (showFeedback) {
      if (isCorrectAnswer) {
        return Colors.green.shade100; // Highlight correct answer
      } else if (isSelected && !isCorrectAnswer) {
        return Colors.red.shade100; // Highlight selected incorrect answer
      }
    }

    return Colors.white; // Default color
  }

  Color _getTextColor() {
    if (!isAnswered) {
       // Corrected: Use AppColors.textPrimary or textSecondary
      return AppColors.textPrimary; // Default text color
    }

    if (showFeedback) {
      if (isCorrectAnswer) {
        return Colors.green.shade800; // Darker text for correct answer feedback
      } else if (isSelected && !isCorrectAnswer) {
        return Colors.red.shade800; // Darker text for selected incorrect answer
      }
    }

    // Corrected: Use AppColors.textPrimary or textSecondary
    return AppColors.textPrimary; // Default text color for other cases
  }


  @override
  Widget build(BuildContext context) {
    Widget feedbackIcon;
    if (showFeedback) {
      if (isCorrectAnswer) {
        feedbackIcon = const Icon(Icons.check_circle, color: Colors.green);
      } else if (isSelected && !isCorrectAnswer) {
        feedbackIcon = const Icon(Icons.cancel, color: Colors.red); // Show 'x' for selected incorrect
      } else {
        feedbackIcon = const SizedBox.shrink(); // No icon for other answers
      }
    } else {
      feedbackIcon = const SizedBox.shrink(); // No icon if feedback is not shown
    }


    return Card(
      elevation: 1,
      color: _getTileColor(),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: isAnswered ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  answer.answerText,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: _getTextColor(), // Use corrected text color getter
                    fontWeight: showFeedback && isCorrectAnswer ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              feedbackIcon,
            ],
          ),
        ),
      ),
    );
  }
}