import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/auth_service.dart';
import '../../core/widgets/galactic_background.dart';

import '../../core/theme/galactic_colors.dart';
import '../../core/widgets/time_particles.dart';
import '../../core/widgets/glass_morphic_card.dart';
import '../../core/widgets/sci_fi_text_field.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
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
    // Basic theme access if needed, but we use GalacticColors directly for strong theming

    return Scaffold(
      body: Stack(
        children: [
          // Enhanced Galactic Background is already good, we add Particles
          const GalacticBackground(showStars: true),

          // Time Particles
          const Positioned.fill(child: TimeParticles(count: 40)),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with Sci-Fi Glow
                    Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                GalacticColors.wormholeBlue.withOpacity(0.3),
                                GalacticColors.deepNebula.withOpacity(0.1),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: GalacticColors.neonCyan.withOpacity(0.2),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                            border: Border.all(
                              color: GalacticColors.neonCyan.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons
                                .hourglass_empty, // Or futuristic icon if available
                            size: 60,
                            color: GalacticColors.neonCyan,
                          ),
                        )
                        .animate()
                        .scale(duration: 800.ms, curve: Curves.elasticOut)
                        .then()
                        .shimmer(duration: 2000.ms),

                    const SizedBox(height: 24),

                    AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          'TEMPORAL WISDOM ARCHIVE',
                          textStyle: GoogleFonts.orbitron(
                            fontSize: 14,
                            color: GalacticColors.neonCyan,
                            letterSpacing: 2,
                          ),
                          speed: const Duration(milliseconds: 50),
                        ),
                      ],
                      totalRepeatCount: 1,
                    ),

                    const SizedBox(height: 48),

                    // Glassmorphic Form Card
                    GlassMorphicCard(
                      blur: 15,
                      opacity: 0.6,
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Text(
                              _isLogin
                                  ? 'TEMPORAL ACCESS'
                                  : 'INITIATE SEQUENCE',
                              style: GoogleFonts.orbitron(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Sci-Fi Inputs
                            if (!_isLogin) ...[
                              SciFiTextField(
                                controller: _usernameController,
                                label: 'CODENAME',
                                prefixIcon: Icons.badge_outlined,
                                onChanged: (_) {},
                              ),
                              const SizedBox(height: 20),
                            ],

                            SciFiTextField(
                              controller: _emailController,
                              label: 'TEMPORAL ID (EMAIL)',
                              prefixIcon: Icons.alternate_email,
                              onChanged: (_) {},
                            ),
                            const SizedBox(height: 20),

                            SciFiTextField(
                              controller: _passwordController,
                              label: 'CHRONO-KEY',
                              prefixIcon: Icons.lock_outline,
                              isPassword: true,
                              onChanged: (_) {},
                            ),

                            const SizedBox(height: 32),

                            // Action Button
                            if (_isLoading)
                              CircularProgressIndicator(
                                color: GalacticColors.neonCyan,
                              )
                            else
                              GestureDetector(
                                onTap: _submit,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        GalacticColors.wormholeBlue,
                                        GalacticColors.quantumPurple,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: GalacticColors.neonCyan
                                            .withOpacity(0.4),
                                        blurRadius: 15,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: GalacticColors.neonCyan
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _isLogin
                                          ? 'ACTIVATE PORTAL'
                                          : 'ESTABLISH LINK',
                                      style: GoogleFonts.orbitron(
                                        fontSize: 16,
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

                    const SizedBox(height: 24),

                    // Toggle Button
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => setState(() {
                              _isLogin = !_isLogin;
                              _formKey.currentState?.reset();
                            }),
                      child: Text(
                        _isLogin
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

// Removed _PasswordStrengthIndicator as it should ideally be integrated into SciFiTextField or handled better visually
// For now, removing to clean up the sci-fi look, or can be re-added if critically needed.
