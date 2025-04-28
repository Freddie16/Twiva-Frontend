// lib/features/auth/presentation/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Corrected import path for RouteNames
import '../../../../core/constants/route_names.dart';
import '../../../../widgets/shared/app_button.dart';
import '../../../../widgets/shared/app_text_field.dart';
import '../../../../widgets/templates/base_screen.dart';
import '../../../../core/utils/validators/form_validators.dart';
import '../../application/auth_notifier.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/extensions/build_context_extensions.dart';
import '../../../../core/utils/dialog_utils.dart'; // Import DialogUtils


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;


  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
       final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
      try {
        // Show loading indicator
        final dismissLoading = await DialogUtils.showLoadingDialog(context: context, message: 'Registering...');
        await authNotifier.register(
          _nameController.text,
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
        );
        dismissLoading(); // Dismiss loading indicator
        context.goNamed(RouteNames.gameList); // Navigate to game list on success
      } catch (e) {
         // Dismiss loading indicator and show error message
         // dismissLoading(); // Make sure dismissLoading is called even on error
         context.showSnackBar(e.toString(), backgroundColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context);

    return BaseScreen(
       appBar: AppBar(title: const Text('Register')),
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
                  'Create Your Account',
                  style: context.textTheme.headlineLarge,
                ),
                 const SizedBox(height: 20),
                AppTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  validator: FormValidators.required,
                   prefixIcon: const Icon(Icons.person),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _usernameController,
                  labelText: 'Username',
                  validator: FormValidators.required,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                const SizedBox(height: 16),
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
                  validator: FormValidators.password,
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
                const SizedBox(height: 16),
                AppTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  obscureText: !_isConfirmPasswordVisible,
                  validator: (value) => FormValidators.confirmPassword(value, _passwordController.text),
                   prefixIcon: const Icon(Icons.lock_reset),
                     suffixIcon: IconButton(
                     icon: Icon(
                       _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                     ),
                     onPressed: () {
                       setState(() {
                         _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                       });
                     },
                   ),
                ),
                const SizedBox(height: 24),
                 authNotifier.isLoading
                    ? const CircularProgressIndicator() // Use standard indicator within button or handle loading state in button
                    : AppButton(
                        text: 'Register',
                        onPressed: _register,
                        isLoading: authNotifier.isLoading, // Pass loading state to button
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    context.goNamed(RouteNames.login); // Navigate to login
                  },
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
