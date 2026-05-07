import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/ai/openrouter_service.dart';
import '../../../core/ai/prompts.dart';
import '../../../core/theme/era_theme.dart';
import '../../auth/services/profile_service.dart';
import 'user_traits_controller.dart';

class EchoMentorSheet extends ConsumerStatefulWidget {
  const EchoMentorSheet({super.key});

  @override
  ConsumerState<EchoMentorSheet> createState() => _EchoMentorSheetState();
}

class _EchoMentorSheetState extends ConsumerState<EchoMentorSheet> {
  String _mentorResponse = '';
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchMentorWisdom();
  }

  Future<void> _fetchMentorWisdom() async {
    try {
      final profile = ref.read(userProfileProvider).value;
      final traitsState = ref.read(userTraitsControllerProvider).value;
      final aiService = ref.read(openRouterServiceProvider);

      final userName = profile?.username ?? 'Traveler';
      final traitsMap = traitsState?.toCompassMap() ?? {};
      final historyList = traitsState?.traitHistory
              .take(5)
              .map(
                (h) =>
                    r'${h.traitChanged.name}: ${h.changeAmount > 0 ? "+" : ""}${h.changeAmount} (${h.reason})',
              )
              .toList() ??
          [];

      final prompt = ChronoPrompts.echoMentorPrompt(
        userName: userName,
        traits: traitsMap,
        recentHistory: historyList,
      );

      final stream = aiService.streamContent(
        prompt,
        'I seek guidance from the Echo.',
      );

      setState(() {
        _isLoading = false;
      });

      await for (final chunk in stream) {
        if (mounted) {
          setState(() {
            _mentorResponse += chunk;
          });
        }
      }
    } on Object catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _mentorResponse =
              'The connection to the Echo has been severed... ($e)';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF15151A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: MythicColors.stoneGray.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(
                Icons.spatial_audio_off,
                color: MythicColors.fluxCyan,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'THE ECHO',
                style: GoogleFonts.cinzelDecorative(
                  fontSize: 20,
                  color: MythicColors.fluxCyan,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'A fragment of collective wisdom, speaking across the void.',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 16,
              color: MythicColors.parchment.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: MythicColors.fluxCyan.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: MythicColors.fluxCyan,
                      ),
                    )
                  : Text(
                      _mentorResponse,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 20,
                        height: 1.5,
                        color: _hasError
                            ? Colors.redAccent
                            : MythicColors.parchment,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
