import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/era_theme.dart';
import '../rifts/domain/anomaly.dart';
import '../rifts/presentation/anomaly_provider.dart';
import 'domain/era.dart';
import 'widgets/anomaly_blip.dart';
import 'widgets/futures_tab.dart';
import 'widgets/temporal_radar.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Era _selectedEra = Era.mythic;
  final Set<Era> _exploredEras = {
    Era.mythic,
    Era.ancient,
    Era.medieval,
  }; // Mock explored eras

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15151A),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: ColoredBox(
            color: Colors.black26,
            child: TabBar(
              controller: _tabController,
              indicatorColor: MythicColors.bronze,
              labelColor: MythicColors.bronze,
              unselectedLabelColor: Colors.white38,
              labelStyle: GoogleFonts.cinzel(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'RADAR'),
                Tab(text: 'FUTURES'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildRadarTab(),
          const FuturesTab(),
        ],
      ),
    );
  }

  Widget _buildRadarTab() {
    // Watch anomalies stream
    final anomaliesAsync = ref.watch(anomaliesStreamProvider);

    return Stack(
      children: [
        // Background - subtle grid or stars
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              radius: 1.5,
              colors: [
                Color(0xFF1A1A2E),
                Color(0xFF0A0A0F),
              ],
            ),
          ),
        ),

        // Radar Content
        Center(
          child: anomaliesAsync.when(
            data: (anomalies) {
              final blips = _mapAnomaliesToBlips(anomalies);
              return TemporalRadar(
                anomalies: blips,
                currentEra: _selectedEra,
                exploredEras: _exploredEras,
                onEraSelected: (era) => setState(() => _selectedEra = era),
                onAnomalyTapped: _handleAnomalyTap,
                onScanComplete: () {
                  // Optional: Trigger haptic or sound
                },
              );
            },
            loading: () =>
                const CircularProgressIndicator(color: Color(0xFF00FFFF)),
            error: (e, s) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.signal_wifi_off, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'RADAR OFFLINE',
                  style: GoogleFonts.orbitron(color: Colors.red),
                ),
                const Text(
                  'Unable to connect to the temporal network.',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ],
            ),
          ),
        ),

        // Hint Text
        Positioned(
          bottom: 32,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'DIVINING TIMELINE...',
              style: GoogleFonts.shareTechMono(
                color: const Color(0xFF00FFFF).withValues(alpha: 0.5),
                letterSpacing: 2,
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(),
          ),
        ),
      ],
    );
  }

  List<AnomalyBlipData> _mapAnomaliesToBlips(List<Anomaly> anomalies) {
    // Helper to distribute blips randomly but deterministically based on ID
    return anomalies.map((anomaly) {
      final seed = anomaly.id.codeUnits.fold(0, (p, c) => p + c);
      final random = math.Random(seed);

      // Use parsed era from domain model
      final era = anomaly.parsedEra;

      // Angle roughly within the era's region (+/- 30 degrees)
      final baseAngle = era.radarAngle;
      final variance = (random.nextDouble() - 0.5) * (math.pi / 3);
      final angle = ((baseAngle + variance) % (2 * math.pi) + (2 * math.pi)) %
          (2 * math.pi); // Normalize to [0, 2π)

      // Distance between 0.4 and 0.9 of radius
      final distance = 0.4 + (random.nextDouble() * 0.5);

      return AnomalyBlipData(
        id: anomaly.id,
        era: era,
        angle: angle,
        distance: distance,
        severity: anomaly.severity,
        title: anomaly.title,
      );
    }).toList();
  }

  void _handleAnomalyTap(AnomalyBlipData blip) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A24),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(
              color: blip.severity == AnomalySeverity.critical
                  ? Colors.red
                  : const Color(0xFF00FFFF),
              width: 2,
            ),
          ),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 20)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: blip.severity == AnomalySeverity.critical
                      ? Colors.red
                      : Colors.amber,
                ),
                const SizedBox(width: 12),
                Text(
                  'ANOMALY DETECTED',
                  style: GoogleFonts.orbitron(
                    fontSize: 14,
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              blip.title.toUpperCase(),
              style: GoogleFonts.cinzelDecorative(
                fontSize: 24,
                color: MythicColors.parchment,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ERA: ${blip.era.label}',
              style: GoogleFonts.spaceMono(
                color: const Color(0xFF00FFFF),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF00FFFF).withValues(alpha: 0.2),
                  foregroundColor: const Color(0xFF00FFFF),
                  side: const BorderSide(color: Color(0xFF00FFFF)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/rifts'); // Navigate to dashboard
                },
                child: Text(
                  'ANALYZE IN DASHBOARD',
                  style: GoogleFonts.orbitron(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
