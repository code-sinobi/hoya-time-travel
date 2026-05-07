import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/era_theme.dart';
import '../../core/widgets/galactic_background.dart';
import 'domain/anomaly.dart';
import 'presentation/anomaly_provider.dart';
import 'widgets/living_anomaly_card.dart';

/// The Anomalies/Rifts screen showing timeline disturbances.
/// Features living cards with urgency effects, countdown timers,
/// and cascade connections.
class RiftsScreen extends ConsumerStatefulWidget {
  const RiftsScreen({super.key});

  @override
  ConsumerState<RiftsScreen> createState() => _RiftsScreenState();
}

class _RiftsScreenState extends ConsumerState<RiftsScreen> {
  final Set<String> _selectedAnomalies = {};
  bool _selectionMode = false;

  void _toggleSelectionMode() {
    setState(() {
      _selectionMode = !_selectionMode;
      if (!_selectionMode) {
        _selectedAnomalies.clear();
      }
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedAnomalies.contains(id)) {
        _selectedAnomalies.remove(id);
      } else {
        _selectedAnomalies.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Try real-time stream first, fall back to async fetch
    final anomaliesStream = ref.watch(anomaliesStreamProvider);

    return Scaffold(
      backgroundColor: MythicColors.voidBackground,
      body: Stack(
        children: [
          // Animated star background
          const GalacticBackground(showStars: true),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),

                const SizedBox(height: 16),

                // Anomaly List
                Expanded(
                  child: anomaliesStream.when(
                    data: (anomalies) =>
                        _buildAnomalyList(context, ref, anomalies),
                    loading: () => _buildLoadingState(),
                    error: (e, _) => _buildErrorState(e, ref),
                  ),
                ),
              ],
            ),
          ),

          // Bulk Action FAB
          if (_selectionMode && _selectedAnomalies.isNotEmpty)
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MythicColors.ochreRed.withValues(alpha: 0.8),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.delete_sweep, color: Colors.white),
                label: Text(
                  'PURGE SELECTED (${_selectedAnomalies.length})',
                  style: GoogleFonts.orbitron(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => _handleBulkPurge(
                  context,
                  ref,
                  anomaliesStream.valueOrNull ?? [],
                ),
              ),
            ).animate().slideY(begin: 1.0, end: 0.0, curve: Curves.easeOutBack),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          const Icon(
            Icons.broken_image_outlined,
            color: MythicColors.ochreRed,
            size: 24,
          ).animate(onPlay: (c) => c.repeat(reverse: true)).custom(
                duration: const Duration(milliseconds: 1500),
                builder: (context, value, child) => Opacity(
                  opacity: 0.7 + (value * 0.3),
                  child: child,
                ),
              ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'ANOMALIES: LEGENDS FADING',
              style: GoogleFonts.orbitron(
                fontSize: 18,
                color: MythicColors.ochreRed,
                fontWeight: FontWeight.bold,
                shadows: [
                  const BoxShadow(
                    color: Colors.black,
                    blurRadius: 4,
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Selection toggle button
          IconButton(
            icon: Icon(
              _selectionMode ? Icons.close : Icons.checklist,
              color: MythicColors.ochreRed.withValues(alpha: 0.7),
            ),
            onPressed: _toggleSelectionMode,
          ),
        ],
      ),
    );
  }

  Widget _buildAnomalyList(
    BuildContext context,
    WidgetRef ref,
    List<Anomaly> anomalies,
  ) {
    if (anomalies.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: anomalies.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final anomaly = anomalies[index];
        final isSelected = _selectedAnomalies.contains(anomaly.id);

        Widget card = LivingAnomalyCard(
          anomaly: anomaly,
          showCascadeIndicator: anomaly.cascadeAnomalyIds.isNotEmpty,
          cascadeCount: anomaly.cascadeAnomalyIds.length,
          onPurge:
              _selectionMode ? null : () => _handlePurge(context, ref, anomaly),
          onStabilize: _selectionMode
              ? null
              : () => _handleStabilize(context, ref, anomaly),
        );

        if (_selectionMode) {
          card = GestureDetector(
            onTap: () => _toggleSelection(anomaly.id),
            child: Stack(
              children: [
                Opacity(opacity: isSelected ? 1.0 : 0.6, child: card),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IgnorePointer(
                    child: Checkbox(
                      value: isSelected,
                      onChanged: (_) {},
                      activeColor: MythicColors.ochreRed,
                      checkColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return card
            .animate()
            .fadeIn(
              duration: 400.ms,
              delay: Duration(milliseconds: (index.clamp(0, 10)) * 100),
            )
            .slideX(
              begin: 0.1,
              end: 0,
              duration: 400.ms,
              delay: Duration(milliseconds: (index.clamp(0, 10)) * 100),
              curve: Curves.easeOutCubic,
            );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: MythicColors.ochreRed,
            strokeWidth: 2,
          ),
          const SizedBox(height: 16),
          Text(
            'Divining timeline fractures...',
            style: GoogleFonts.shareTechMono(
              color: MythicColors.stoneGray,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: MythicColors.ochreRed.withValues(alpha: 0.7),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'SCAN ERROR',
              style: GoogleFonts.orbitron(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The temporal network is unreachable.',
              style: TextStyle(
                color: MythicColors.stoneGray,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Scan'),
              style: OutlinedButton.styleFrom(
                foregroundColor: MythicColors.ochreRed,
                side: const BorderSide(color: MythicColors.ochreRed),
              ),
              onPressed: () => ref.invalidate(anomaliesStreamProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: MythicColors.stoneGray.withValues(alpha: 0.5),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'All timelines stable',
            style: GoogleFonts.cinzel(
              color: MythicColors.stoneGray,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No anomalies detected in the temporal web',
            style: GoogleFonts.exo2(
              color: MythicColors.stoneGray.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePurge(BuildContext context, WidgetRef ref, Anomaly anomaly) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: Text(
          'PURGE ANOMALY?',
          style: GoogleFonts.orbitron(
            color: MythicColors.ochreRed,
            fontSize: 16,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Erase "${anomaly.title}" from the timeline.',
              style: GoogleFonts.exo2(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Text(
              'Cost: ${anomaly.purgeCost} Temporal Energy',
              style: GoogleFonts.shareTechMono(
                color: MythicColors.ochreRed.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
            if (anomaly.cascadeAnomalyIds.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '⚠️ This will destabilize ${anomaly.cascadeAnomalyIds.length} connected timeline(s)',
                style: GoogleFonts.exo2(
                  color: Colors.amber,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: GoogleFonts.orbitron(color: MythicColors.stoneGray),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MythicColors.ochreRed.withValues(alpha: 0.3),
              foregroundColor: MythicColors.ochreRed,
            ),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(anomalyControllerProvider.notifier)
                    .purgeAnomaly(anomaly.id);
                
                if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Anomaly ${anomaly.title} purged.'),
                      backgroundColor: MythicColors.ochreRed,
                    ),
                  );
                }
              } catch (e) {
                 if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Purge failed. Insufficient energy?'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(
              'PURGE',
              style: GoogleFonts.orbitron(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _handleStabilize(BuildContext context, WidgetRef ref, Anomaly anomaly) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Entering ${anomaly.title} to stabilize timeline...',
          style: GoogleFonts.exo2(),
        ),
        backgroundColor: const Color(0xFF2D4A5E),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
    context.push('/story/${anomaly.storyId}');
  }

  void _handleBulkPurge(
    BuildContext context,
    WidgetRef ref,
    List<Anomaly> anomalies,
  ) {
    if (_selectedAnomalies.isEmpty) return;

    final selectedList =
        anomalies.where((a) => _selectedAnomalies.contains(a.id)).toList();
    final totalCost = selectedList.fold(0, (sum, a) => sum + (a.purgeCost));
    final cascadeCount =
        selectedList.fold(0, (sum, a) => sum + a.cascadeAnomalyIds.length);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: Text(
          'PURGE ${_selectedAnomalies.length} ANOMALIES?',
          style: GoogleFonts.orbitron(
            color: MythicColors.ochreRed,
            fontSize: 16,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Erase multiple timelines at once.',
              style: GoogleFonts.exo2(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Text(
              'Total Cost: $totalCost Temporal Energy',
              style: GoogleFonts.shareTechMono(
                color: MythicColors.ochreRed.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
            if (cascadeCount > 0) ...[
              const SizedBox(height: 8),
              Text(
                '⚠️ This will destabilize $cascadeCount connected timeline(s)',
                style: GoogleFonts.exo2(
                  color: Colors.amber,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: GoogleFonts.orbitron(color: MythicColors.stoneGray),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MythicColors.ochreRed.withValues(alpha: 0.3),
              foregroundColor: MythicColors.ochreRed,
            ),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(anomalyControllerProvider.notifier)
                    .purgeAnomalies(_selectedAnomalies.toList());

                if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${_selectedAnomalies.length} anomalies purged.'),
                      backgroundColor: MythicColors.ochreRed,
                    ),
                  );
                }
                _toggleSelectionMode(); // Exit mode after purge
              } catch (e) {
                 if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bulk purge failed.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(
              'PURGE ALL',
              style: GoogleFonts.orbitron(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
