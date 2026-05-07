import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/era_theme.dart';
import '../data/chronicler_repository.dart';

class ChroniclerOnboardingScreen extends ConsumerStatefulWidget {
  const ChroniclerOnboardingScreen({super.key});

  @override
  ConsumerState<ChroniclerOnboardingScreen> createState() =>
      _ChroniclerOnboardingScreenState();
}

class _ChroniclerOnboardingScreenState
    extends ConsumerState<ChroniclerOnboardingScreen> {
  bool _acceptedTerms = false;
  bool _isLoading = false;

  Future<void> _becomeChronicler() async {
    if (!_acceptedTerms) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(chroniclerRepositoryProvider).becomeChronicler();
      if (mounted) {
        context.go('/chronicler');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to join chroniclers. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15151A),
      body: Stack(
        children: [
          // Background Aesthetic
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/parchment_texture.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'WEAVE THE\nTIMELINE',
                    style: GoogleFonts.cinzelDecorative(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: MythicColors.parchment,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 60,
                    height: 4,
                    color: MythicColors.bronze,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Chroniclers are the architects of history. By joining, you gain the power to create stories, branch paths, and decide the fate of entire eras.',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 20,
                      color: MythicColors.parchment.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),
                  const Spacer(),

                  // Terms Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: MythicColors.bronze.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _acceptedTerms,
                          activeColor: MythicColors.bronze,
                          onChanged: (val) =>
                              setState(() => _acceptedTerms = val ?? false),
                        ),
                        Expanded(
                          child: Text(
                            'I agree to the Chronos Code of Truth and Creative Quality.',
                            style: GoogleFonts.shareTechMono(
                              fontSize: 12,
                              color: MythicColors.stoneGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (_acceptedTerms && !_isLoading)
                          ? _becomeChronicler
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MythicColors.bronze,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.white12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text(
                              'ASCEND TO CHRONICLER',
                              style: GoogleFonts.orbitron(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
