// lib/features/auth/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Corrected import path for RouteNames
import 'package:gamification_trivia/core/constants/route_names.dart'; // Assuming your package name is gamification_trivia
import 'package:gamification_trivia/widgets/shared/app_button.dart';
import 'package:gamification_trivia/widgets/shared/app_text_field.dart';
import 'package:gamification_trivia/widgets/templates/base_screen.dart';
import 'package:gamification_trivia/core/utils/validators/form_validators.dart';
import 'package:gamification_trivia/features/auth/application/auth_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:gamification_trivia/core/utils/extensions/build_context_extensions.dart';
// Corrected import path for DialogUtils
import 'package:gamification_trivia/core/utils/dialog_utils.dart'; // Assuming your package name is gamification_trivia


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
      // Store the dismiss function from the loading dialog
      VoidCallback? dismissLoading;
      try {
        // Show loading indicator
        dismissLoading = await DialogUtils.showLoadingDialog(context: context, message: 'Logging in...');
        await authNotifier.login(
          _emailController.text,
          _passwordController.text,
        );
        // Dismiss loading indicator on success
        dismissLoading();
        context.goNamed(RouteNames.gameList); // Navigate to game list on success
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

    return BaseScreen(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TODO: Add App Logo/Branding
                const SizedBox(height: 40),
                Text(
                  'Welcome Back!',
                  style: context.textTheme.headlineLarge,
                ),
                 const SizedBox(height: 20),
                AppTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: FormValidators.email,
                  prefixIcon: const Icon(Icons.email),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: !_isPasswordVisible,
                  validator: FormValidators.required,
                  prefixIcon: const Icon(Icons.lock),
                   suffixIcon: IconButton(
                     icon: Icon(
                       _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                     ),
                     onPressed: () {
                       setState(() {
                         _isPasswordVisible = !_isPasswordVisible;
                       });
                     },
                   ),
                ),
                const SizedBox(height: 24),
                // The loading state is now handled within the _login method using DialogUtils
                AppButton(
                  text: 'Login',
                  onPressed: authNotifier.isLoading ? () {} : _login, // Disable button while loading
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    context.goNamed(RouteNames.register); // Navigate to register
                  },
                  child: const Text('Don\'t have an account? Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
