// lib/features/profile/presentation/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gamification_trivia/widgets/templates/base_screen.dart';
import 'package:gamification_trivia/widgets/shared/loading_indicator.dart';
import 'package:gamification_trivia/widgets/shared/app_button.dart';
import 'package:gamification_trivia/features/profile/application/profile_notifier.dart';
import 'package:gamification_trivia/features/auth/application/auth_notifier.dart'; // To access authenticated user info
import 'package:gamification_trivia/core/utils/extensions/build_context_extensions.dart';
// Corrected import path for RouteNames
import 'package:gamification_trivia/core/constants/route_names.dart'; // Assuming your package name is gamification_trivia
import 'package:go_router/go_router.dart';
// Corrected import path for DialogUtils
import 'package:gamification_trivia/core/utils/dialog_utils.dart'; // Assuming your package name is gamification_trivia
import 'package:gamification_trivia/core/utils/formatters/date_formatter.dart'; // Import DateFormatter


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // The user data should ideally be available in the AuthNotifier
    // We might not need to fetch it again specifically for the profile screen,
    // but a ProfileNotifier could be used for additional profile-specific data or actions.
    // For now, we'll rely on AuthNotifier.
  }

  void _logout() async {
    // Show confirmation dialog before logging out
    final confirmed = await DialogUtils.showConfirmationDialog(
      context: context,
      title: 'Logout',
      content: 'Are you sure you want to log out?',
      confirmButtonColor: Colors.red,
    );

    if (confirmed) {
      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
      // Store the dismiss function from the loading dialog
      VoidCallback? dismissLoading;
      try {
        // Show loading indicator
        dismissLoading = await DialogUtils.showLoadingDialog(context: context, message: 'Logging out...');
        await authNotifier.logout();
        // Dismiss loading indicator on success
        dismissLoading();
        context.goNamed(RouteNames.login); // Navigate back to login after logout
      } catch (e) {
         // Dismiss loading indicator on error
         dismissLoading?.call(); // Use ?.call() for null safety
         // Show error message
         context.showSnackBar(e.toString(), backgroundColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context);
    // You might use ProfileNotifier here if it fetches additional data
    // final profileNotifier = Provider.of<ProfileNotifier>(context);

    final user = authNotifier.user; // Get user from AuthNotifier


    return BaseScreen(
      appBar: AppBar(title: const Text('Profile')),
      body: authNotifier.isLoading
          ? const LoadingIndicator()
          : user == null
              ? const Center(child: Text('User not logged in.')) // Should not happen if protected by auth guard
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User Information', style: context.textTheme.headlineLarge),
                      const SizedBox(height: 24),
                      Text('Name: ${user.name}', style: context.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Username: ${user.username}', style: context.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Email: ${user.email}', style: context.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      // Using DateFormatter for a cleaner date display
                      Text('Member Since: ${DateFormatter.formatDate(user.createdAt)}', style: context.textTheme.titleMedium),
                      const SizedBox(height: 24),
                      // TODO: Add options for editing profile, viewing game history, etc.
                       Center(
                         child: AppButton(
                           text: 'Logout',
                           onPressed: _logout,
                           color: Colors.red,
                         ),
                       ),
                    ],
                  ),
                ),
    );
  }
}
