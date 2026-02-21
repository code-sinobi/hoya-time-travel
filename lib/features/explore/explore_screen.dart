import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/era_theme.dart';
import '../rifts/presentation/anomaly_provider.dart';
import 'widgets/temporal_radar.dart';
import 'widgets/fog_overlay.dart';
import 'widgets/futures_tab.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
      backgroundColor: const Color(0xFF0F0F13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'TEMPORAL EXPLORER',
          style: GoogleFonts.orbitron(
            fontSize: 16,
            color: MythicColors.parchment,
            letterSpacing: 2,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: MythicColors.bronze,
          labelColor: MythicColors.bronze,
          unselectedLabelColor: Colors.white24,
          labelStyle: GoogleFonts.shareTechMono(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'RADAR', icon: Icon(Icons.radar)),
            Tab(text: 'FUTURES', icon: Icon(Icons.auto_awesome_mosaic)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRadarTab(),
          const FuturesTab(),
        ],
      ),
    );
  }

  Widget _buildRadarTab() {
    final anomaliesAsync = ref.watch(anomaliesStreamProvider);

    return anomaliesAsync.when(
      data: (anomalies) {
        final blips = _mapAnomaliesToBlips(anomalies);
        return Stack(
          children: [
            Center(
              child: TemporalRadar(
                blips: blips,
                onBlipTap: (anomalyId) {
                  // Navigate to anomaly
                },
              ),
            ),
            const FogOverlay(
              exploredEras: {'MYTHIC', 'ANCIENT', 'MODERN'},
            ),
            _buildLegend(),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: MythicColors.bronze),
      ),
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
    );
  }

  List<RadarBlip> _mapAnomaliesToBlips(List<dynamic> anomalies) {
    // Deterministic but randomized layout for blips
    return anomalies.asMap().entries.map((entry) {
      final index = entry.key;
      final anomaly = entry.value;

      final baseAngle = (index * 137.5) * (math.pi / 180);
      final variance = math.Random(anomaly.id.hashCode).nextDouble() * 0.5;
      final angle = ((baseAngle + variance) % (math.pi * 2) + (math.pi * 2)) %
          (math.pi * 2);

      final distance = 0.3 + (math.Random(index).nextDouble() * 0.5);

      return RadarBlip(
        id: anomaly.id,
        angle: angle,
        distance: distance,
        intensity: anomaly.urgency / 10.0,
        color: _getColorForEra(anomaly.eraId),
      );
    }).toList();
  }

  Color _getColorForEra(String era) {
    switch (era.toUpperCase()) {
      case 'MYTHIC':
        return const Color(0xFFFFD700);
      case 'ANCIENT':
        return MythicColors.bronze;
      case 'MODERN':
        return const Color(0xFF00CED1);
      default:
        return Colors.white;
    }
  }

  Widget _buildLegend() {
    return Positioned(
      bottom: 24,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _legendItem('MYTHIC', const Color(0xFFFFD700)),
            _legendItem('ANCIENT', MythicColors.bronze),
            _legendItem('MODERN', const Color(0xFF00CED1)),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }
}
