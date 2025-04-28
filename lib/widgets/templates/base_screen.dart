// lib/widgets/templates/base_screen.dart
import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const BaseScreen({
    Key? key,
    required this.body,
    this.appBar,
    this.drawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: SafeArea( // Use SafeArea to avoid notches and system overlays
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add some padding around the content
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}