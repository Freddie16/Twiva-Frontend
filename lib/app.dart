// lib/app.dart
import 'package:flutter/material.dart';
// Provider is no longer needed here as it's handled in main.dart
// import 'package:provider/provider.dart';
import 'core/router/app_router.dart'; // Import your app router
import 'core/theme/app_theme.dart'; // Import your app theme
// AuthNotifier is no longer provided here, it's provided in main.dart
// import 'features/auth/application/auth_notifier.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Added const constructor for better performance


  @override
  Widget build(BuildContext context) {
    // The MultiProvider is now defined in main.dart, wrapping the MyApp widget.
    // So, MyApp itself just needs to return the root Material app widget.
    return MaterialApp.router(
      title: 'Gamification Trivia', // App title
      theme: AppTheme.lightTheme, // Apply the custom defined theme
      routerConfig: AppRouter.router, // Use the defined GoRouter configuration
      debugShowCheckedModeBanner: false, // Hide the debug banner
    );
  }
}
