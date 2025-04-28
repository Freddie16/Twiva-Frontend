// lib/features/game/presentation/widgets/game_card.dart
import 'package:flutter/material.dart';
import 'package:gamification_trivia/data/models/game/game.dart'; // Assuming your package name
import 'package:gamification_trivia/core/theme/app_colors.dart'; // Assuming your package name
import 'package:gamification_trivia/core/theme/app_text_styles.dart'; // Assuming your package name
import 'package:gamification_trivia/core/utils/formatters/date_formatter.dart'; // Assuming your package name


class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback onTap;

  const GameCard({
    Key? key,
    required this.game,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                game.title,
                // Updated to use titleLarge from the new text style scale
                style: AppTextStyles.titleLarge.copyWith(fontSize: 18), // Adjusted font size if needed
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                game.description ?? 'No description available',
                // Updated to use bodyMedium from the new text style scale
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status: ${game.status}',
                    // Updated to use bodyMedium from the new text style scale
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                   Text(
                    // Using DateFormatter to format the date
                    'Created: ${DateFormatter.formatDate(game.createdAt)}',
                    // Updated to use bodySmall from the new text style scale
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              // TODO: Add more game details if needed (e.g., number of questions)
            ],
          ),
        ),
      ),
    );
  }
}
