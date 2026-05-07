import 'package:chrono_app/core/theme/era_theme.dart';
import 'package:chrono_app/features/auth/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
    setState(() => _isLoading = true);
    try {
      await ref.read(userProfileProvider.notifier).becomeChronicler();
      if (mounted) {
        context.pop(); // Return to previous screen, now with chronicler powers
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome, Chronicler. The Quill is yours.',
              style: GoogleFonts.cinzel(color: MythicColors.parchment),
            ),
            backgroundColor: MythicColors.voidBackground,
          ),
        );
      }
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to join. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('The Chronicler\'s Path', style: GoogleFonts.cinzel()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.auto_stories,
                size: 64,
                color: MythicColors.bronze,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Weave the Threads of Time',
              style: GoogleFonts.cinzel(
                fontSize: 24,
                color: MythicColors.parchment,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'As a Chronicler, you are granted the power to create Living Stories. Your words will become worlds for others to explore.',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: MythicColors.bronze.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.black26,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'THE WRITER\'S CODE',
                    style: GoogleFonts.cinzel(
                      color: MythicColors.bronze,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRule('1. I will write with respect for all cultures.'),
                  _buildRule('2. I will not create hate speech or harm.'),
                  _buildRule('3. I create original worlds, not copies.'),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Checkbox(
                  value: _acceptedTerms,
                  activeColor: MythicColors.bronze,
                  onChanged: (val) =>
                      setState(() => _acceptedTerms = val ?? false),
                ),
                Expanded(
                  child: Text(
                    'I accept the Writer\'s Code',
                    style: GoogleFonts.lato(color: Colors.white70),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MythicColors.bronze,
                  disabledBackgroundColor: Colors.grey.shade800,
                ),
                onPressed:
                    (_acceptedTerms && !_isLoading) ? _becomeChronicler : null,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : Text(
                        'ACCEPT THE QUILL',
                        style: GoogleFonts.cinzel(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRule(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: MythicColors.bronze)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lato(color: Colors.white60),
            ),
          ),
        ],
      ),
    );
  }
}
