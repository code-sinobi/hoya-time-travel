import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'services/auth_service.dart';
import '../../core/theme/era_theme.dart';
import '../../core/errors/error_handler.dart';
import '../../core/errors/app_exceptions.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  PasswordStrength _getPasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.none;
    if (password.length < 6) return PasswordStrength.weak;
    if (password.length < 10) return PasswordStrength.medium;

    // Check for mixed case and numbers
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));

    if (hasUppercase && hasLowercase && hasDigits) {
      return PasswordStrength.strong;
    }
    return PasswordStrength.medium;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    final auth = ref.read(authServiceProvider);

    try {
      if (_isLogin) {
        await auth.signIn(_emailController.text, _passwordController.text);
      } else {
        await auth.signUp(
          _emailController.text,
          _passwordController.text,
          _usernameController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created! Please sign in.'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            _isLogin = true;
            _passwordController.clear();
          });
        }
      }
    } on supabase.AuthApiException catch (e) {
      if (mounted) {
        ref
            .read(errorHandlerProvider.notifier)
            .handle(
              AuthException(
                '${_isLogin ? 'Login' : 'Sign up'} failed: ${e.message}',
                e,
              ),
              context: context,
            );
      }
    } catch (e) {
      if (mounted) {
        ref
            .read(errorHandlerProvider.notifier)
            .handleGeneric(
              e,
              context: context,
              message: 'An unexpected error occurred',
            );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<EraTheme>() ?? AncientEraTheme();

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [theme.backgroundColor, theme.surfaceColor],
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Icon(
                      Icons.hourglass_empty,
                      size: 80,
                      color: theme.primaryColor,
                    ).animate().scale(
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'HOYA',
                      style: theme.headlineStyle.copyWith(fontSize: 40),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 40),

                    // Form Container
                    Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: theme.surfaceColor.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: theme.primaryColor.withValues(alpha: 0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                _isLogin ? 'Welcome Back' : 'Begin Journey',
                                style: theme.headlineStyle.copyWith(
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Username field (signup only)
                              if (!_isLogin) ...[
                                TextFormField(
                                  controller: _usernameController,
                                  style: theme.bodyStyle,
                                  decoration: _inputDecoration(
                                    theme,
                                    'Username',
                                  ),
                                  validator: _validateUsername,
                                  enabled: !_isLoading,
                                ),
                                const SizedBox(height: 16),
                              ],

                              // Email field
                              TextFormField(
                                controller: _emailController,
                                style: theme.bodyStyle,
                                decoration: _inputDecoration(theme, 'Email'),
                                keyboardType: TextInputType.emailAddress,
                                validator: _validateEmail,
                                enabled: !_isLoading,
                              ),
                              const SizedBox(height: 16),

                              // Password field with visibility toggle
                              TextFormField(
                                controller: _passwordController,
                                style: theme.bodyStyle,
                                decoration: _inputDecoration(
                                  theme,
                                  'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: theme.primaryColor.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                obscureText: _obscurePassword,
                                validator: _validatePassword,
                                enabled: !_isLoading,
                                onChanged: (_) => setState(
                                  () {},
                                ), // For password strength update
                              ),

                              // Password strength indicator (signup only)
                              if (!_isLogin) ...[
                                const SizedBox(height: 8),
                                _PasswordStrengthIndicator(
                                  strength: _getPasswordStrength(
                                    _passwordController.text,
                                  ),
                                  theme: theme,
                                ),
                              ],

                              const SizedBox(height: 24),

                              // Submit button or loading indicator
                              if (_isLoading)
                                CircularProgressIndicator(
                                  color: theme.primaryColor,
                                )
                              else
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.primaryColor,
                                      foregroundColor: theme.surfaceColor,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: theme.buttonShape,
                                    ),
                                    child: Text(
                                      _isLogin ? 'ENTER' : 'JOIN',
                                      style: theme.headlineStyle.copyWith(
                                        fontSize: 18,
                                        color: theme.backgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                        .animate()
                        .slideY(begin: 0.2, end: 0, duration: 500.ms)
                        .fadeIn(),

                    const SizedBox(height: 20),

                    // Toggle login/signup
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => setState(() {
                              _isLogin = !_isLogin;
                              _formKey.currentState?.reset();
                            }),
                      child: Text(
                        _isLogin
                            ? 'New to Hoya? Create Account'
                            : 'Have an account? Login',
                        style: theme.bodyStyle.copyWith(
                          color: theme.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(
    EraTheme theme,
    String label, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: theme.bodyStyle.copyWith(color: Colors.white54),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      fillColor: Colors.black.withValues(alpha: 0.2),
    );
  }
}

// Password strength enums and widget
enum PasswordStrength { none, weak, medium, strong }

class _PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;
  final EraTheme theme;

  const _PasswordStrengthIndicator({
    required this.strength,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    if (strength == PasswordStrength.none) {
      return const SizedBox.shrink();
    }

    final strengthData = _getStrengthData();

    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: strengthData.progress,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(strengthData.color),
            minHeight: 4,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          strengthData.label,
          style: theme.bodyStyle.copyWith(
            fontSize: 12,
            color: strengthData.color,
          ),
        ),
      ],
    );
  }

  ({double progress, Color color, String label}) _getStrengthData() {
    return switch (strength) {
      PasswordStrength.weak => (
        progress: 0.33,
        color: Colors.red,
        label: 'Weak',
      ),
      PasswordStrength.medium => (
        progress: 0.66,
        color: Colors.orange,
        label: 'Medium',
      ),
      PasswordStrength.strong => (
        progress: 1.0,
        color: Colors.green,
        label: 'Strong',
      ),
      _ => (progress: 0.0, color: Colors.grey, label: ''),
    };
  }
}
