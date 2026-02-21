import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/era_theme.dart';

class EchoesSheet extends StatelessWidget {
  final List<dynamic> echoes;

  const EchoesSheet({super.key, required this.echoes});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A22),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'YOUR TEMPORAL ECHOES',
            style: GoogleFonts.cinzel(
              color: MythicColors.bronze,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Threads of your previous incarnations across the timeline.',
            style: GoogleFonts.cormorantGaramond(
              color: MythicColors.parchment.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: echoes.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    itemCount: echoes.length,
                    separatorBuilder: (_, __) => const Divider(color: Colors.white10),
                    itemBuilder: (context, index) {
                      final echo = echoes[index];
                      return _EchoTile(echo: echo);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Opacity(
        opacity: 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.blur_on, size: 48, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              'NO ECHOES FOUND',
              style: GoogleFonts.orbitron(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _EchoTile extends StatelessWidget {
  final dynamic echo;

  const _EchoTile({required this.echo});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(echo['created_at']);
    final formattedDate = DateFormat('yyyy-MM-dd • HH:mm').format(date);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: MythicColors.bronze.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.waves, color: MythicColors.bronze, size: 20),
      ),
      title: Text(
        echo['title'] ?? 'Temporal Echo',
        style: GoogleFonts.exo2(color: MythicColors.parchment),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            echo['era_id'] ?? 'Unknown Era',
            style: GoogleFonts.shareTechMono(
              color: MythicColors.stoneGray,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            formattedDate,
            style: const TextStyle(color: Colors.white24, fontSize: 10),
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white10),
    );
  }
}
