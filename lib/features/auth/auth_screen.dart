import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../core/errors/app_exceptions.dart';
import '../../core/errors/error_handler.dart';
import '../../core/router/routes.dart';
import '../../core/theme/galactic_colors.dart';
import '../../core/widgets/galactic_background.dart';
import '../../core/widgets/glass_morphic_card.dart';
import '../../core/widgets/sci_fi_text_field.dart';
import 'services/auth_service.dart';

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
  bool _isEntryMode = true;
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _onFieldChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {}); // Trigger rebuild for password strength
        _formKey.currentState?.validate();
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    final auth = ref.read(authServiceProvider);

    try {
      if (_isEntryMode) {
        await auth.signIn(_emailController.text, _passwordController.text);
        if (mounted) context.go(AppRoutes.portal); // Manual navigation
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
            _isEntryMode = true;
            _passwordController.clear();
          });
        }
      }
    } on supabase.AuthException catch (e) {
      if (mounted) {
        ref.read(errorHandlerProvider.notifier).handle(
              AuthException(
                '${_isEntryMode ? 'Enter' : 'Sign up'} failed: ${e.message}',
                e,
              ),
              context: context,
            );
      }
    } on Object catch (e) {
      if (mounted) {
        ref.read(errorHandlerProvider.notifier).handleGeneric(
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
    // Basic theme access if needed, but we use GalacticColors directly for strong theming

    return Scaffold(
      body: Stack(
        children: [
          // Enhanced Galactic Background is already good, we add Particles
          const GalacticBackground(),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Raw Lottie Animation
                    Animate(
                      effects: [
                        ScaleEffect(duration: 800.ms, curve: Curves.elasticOut),
                      ],
                      child: Lottie.asset(
                        'assets/lottie/temporal-ring.json',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 24),

                    AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          'TEMPORAL WISDOM ARCHIVE',
                          textStyle: GoogleFonts.orbitron(
                            fontSize: 14,
                            color: GalacticColors.etherealCyan,
                            letterSpacing: 2,
                          ),
                          speed: const Duration(milliseconds: 50),
                        ),
                      ],
                      totalRepeatCount: 1,
                    ),

                    const SizedBox(height: 48),

                    // Glassmorphic Form Card with constrained width
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: GlassMorphicCard(
                        blur: 15,
                        opacity: 0.6,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(
                                _isEntryMode
                                    ? 'TEMPORAL ACCESS'
                                    : 'INITIATE SEQUENCE',
                                style: GoogleFonts.orbitron(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Sci-Fi Inputs
                              if (!_isEntryMode) ...[
                                SciFiTextField(
                                  controller: _usernameController,
                                  label: 'CODENAME',
                                  prefixIcon: Icons.badge_outlined,
                                  onChanged: _onFieldChanged,
                                  validator: (v) => !_isEntryMode &&
                                          (v == null || v.length < 3)
                                      ? 'CODENAME must be >= 3 chars'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                              ],

                              SciFiTextField(
                                controller: _emailController,
                                label: 'TEMPORAL ID (EMAIL)',
                                prefixIcon: Icons.alternate_email,
                                onChanged: _onFieldChanged,
                                validator: (v) => v == null || !v.contains('@')
                                    ? 'Invalid TEMPORAL ID'
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              SciFiTextField(
                                controller: _passwordController,
                                label: 'CHRONO-KEY',
                                prefixIcon: Icons.lock_outline,
                                isPassword: true,
                                onChanged: _onFieldChanged,
                                validator: (v) => v == null || v.length < 6
                                    ? 'CHRONO-KEY too weak'
                                    : null,
                              ),
                              if (!_isEntryMode)
                                PasswordStrengthIndicator(
                                  password: _passwordController.text,
                                ),

                              const SizedBox(height: 32),

                              // Action Button
                              if (_isLoading)
                                const CircularProgressIndicator(
                                  color: GalacticColors.etherealCyan,
                                )
                              else
                                GestureDetector(
                                  onTap: _submit,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          GalacticColors.wormholeBlue,
                                          GalacticColors.quantumPurple,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: GalacticColors.etherealCyan
                                              .withValues(alpha: 0.4),
                                          blurRadius: 15,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                      border: Border.all(
                                        color: GalacticColors.etherealCyan
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _isEntryMode
                                            ? 'ACTIVATE PORTAL'
                                            : 'ESTABLISH LINK',
                                        style: GoogleFonts.orbitron(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ).animate().shimmer(
                                      delay: 2000.ms,
                                      duration: 1500.ms,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Toggle Button
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => setState(() {
                                _isEntryMode = !_isEntryMode;
                                _formKey.currentState?.reset();
                              }),
                      child: Text(
                        _isEntryMode
                            ? 'NEW NAVIGATOR? ESTABLISH LINK'
                            : 'EXISTING NAVIGATOR? ACTIVATE PORTAL',
                        style: GoogleFonts.orbitron(
                          color: GalacticColors.temporalGold,
                          fontSize: 12,
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
}

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({required this.password, super.key});
  final String password;

  @override
  Widget build(BuildContext context) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp('[A-Z]'))) strength++;
    if (password.contains(RegExp('[0-9]'))) strength++;
    if (password.contains(RegExp('[^a-zA-Z0-9]'))) strength++;

    Color color;
    String text;
    switch (strength) {
      case 0:
      case 1:
        color = Colors.red;
        text = 'WEAK';
      case 2:
      case 3:
        color = Colors.orange;
        text = 'GOOD';
      case 4:
        color = Colors.green;
        text = 'STRONG';
      default:
        color = Colors.red;
        text = 'WEAK';
    }
    if (password.isEmpty) {
      color = Colors.transparent;
      text = '';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0, left: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 4,
                    decoration: BoxDecoration(
                      color: password.isEmpty
                          ? Colors.white12
                          : (index <= (strength == 0 ? 0 : strength - 1)
                              ? color
                              : Colors.white12),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 50,
            child: Text(
              text,
              style: GoogleFonts.orbitron(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
