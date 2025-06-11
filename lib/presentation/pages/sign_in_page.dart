import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_panel_flutter/domain/usecases/auth_service.dart';
import 'package:responsive_admin_panel_flutter/presentation/widgets/custom_button.dart';
import 'package:responsive_admin_panel_flutter/presentation/widgets/custom_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  /// Creates the state of the `SignInPage` widget.
  ///
  /// Returns a `_SignInPageState` object.
  ///
  /// This function is called when the `SignInPage` widget is inserted into the
  /// tree. It is responsible for creating the state object that will be used by
  /// the widget.
  ///
  /// The state object is used to store the state of the widget, including the
  /// values of the form fields, the validation state of the form, and any other
  /// state that needs to be preserved between frames.
  ///
  /// The state object is also used to notify the parent widget when the state
  /// of the widget changes, such as when the user enters a new email address or
  /// password.
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;

  @override
  /// Initializes the state of the `SignInPage` widget.
  ///
  /// This function is called when the `SignInPage` widget is inserted into the
  /// tree. It is responsible for initializing the state of the widget, including
  /// setting the values of the form fields for demo purposes.
  ///
  /// The email and password fields are initialized with demo values to make it
  /// easier for developers to test the sign-in feature.
  ///
  /// The `super.initState()` call is necessary to ensure that the parent's state
  /// is properly initialized.
  @override
  void initState() {
    super.initState();
    // Isi dengan email dan password demo untuk kemudahan pengujian
    _emailController.text = 'demo@example.com';
    _passwordController.text = 'password';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final success = await authService.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password. Not found!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  /// Builds the sign-in screen.
  ///
  /// This widget displays the sign-in UI, including the email and password
  /// input fields, sign-in button, social sign-in buttons, and registration
  /// link. It also manages the state of these components, such as loading
  /// indicators and validation messages.
  ///
  /// The screen features a responsive layout that adapts to different screen
  /// sizes and includes decorative background elements.
  ///
  /// The `build` method uses the `AuthService` provider to check the loading
  /// state and handle sign-in logic. It also adapts the UI to the current
  /// theme, supporting light and dark modes.
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final isLoading = authService.isLoading;
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background pattern
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: size.width > 600 ? 500 : double.infinity,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo and App Name
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.white12
                                : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.flutter_dash,
                            size: 60,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome Back',
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue to your dashboard',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                              label: 'Email',
                              hint: 'Enter your email',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@') || !value.contains('.')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            CustomTextField(
                              label: 'Password',
                              hint: 'Enter your password',
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              focusNode: _passwordFocusNode,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _signIn(),
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Theme.of(context).hintColor,
                                ),
                                onPressed: _togglePasswordVisibility,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Implementasi lupa password
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            CustomButton(
                              text: 'Sign In',
                              isLoading: isLoading,
                              onPressed: _signIn,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'OR',
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Social Sign In Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildSocialButton(
                                  icon: Icons.g_mobiledata,
                                  color: Colors.red,
                                  onTap: () {},
                                ),
                                const SizedBox(width: 20),
                                _buildSocialButton(
                                  icon: Icons.facebook,
                                  color: Colors.blue,
                                  onTap: () {},
                                ),
                                const SizedBox(width: 20),
                                _buildSocialButton(
                                  icon: Icons.apple,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                  onTap: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // Register Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account? ',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Implementasi register
                                  },
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a social sign in button.
  ///
  /// A button is provided that will trigger [onTap] when pressed. The button
  /// displays [icon] in [color].
  ///
  /// The button is elevated and has a shadow.
  ///
  /// The button is a rounded rectangle with a radius of 12.
  ///
  /// The button is white in light theme and black in dark theme.
  ///
  /// The button is suitable for use in a [Row] or [Column].
  ///
  /// Example:
  ///
  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode ? Theme.of(context).cardColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: 30,
        ),
      ),
    );
  }
}
