// lib/widgets/shared/loading_indicator.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? strokeWidth;

  const LoadingIndicator({
    Key? key,
    this.color,
    this.strokeWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary), // Use primary color from theme
        strokeWidth: strokeWidth ?? 4.0,
      ),
    );
  }
}