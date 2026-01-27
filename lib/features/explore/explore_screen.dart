import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/era_theme.dart';
import '../story/models/story_models.dart';
import '../story/repositories/story_repository.dart';
import 'widgets/astral_map_node.dart';
import 'widgets/temporal_web_painter.dart';
import 'widgets/timeline_scrubber.dart';

final storiesProvider = FutureProvider<List<Story>>((ref) async {
  return ref.watch(storyRepositoryProvider).getStories();
});

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen>
    with TickerProviderStateMixin {
  final TransformationController _transformController =
      TransformationController();
  late AnimationController _pulseController;

  String _selectedEra = 'MYTHIC';

  // Scanner State
  bool _isScannerActive = false;
  Offset _scannerPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: 3.seconds)
      ..repeat();
  }

  @override
  void dispose() {
    _transformController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storiesAsync = ref.watch(storiesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF15151A),
      body: Stack(
        children: [
          // 1. Map Layer (Interactive)
          InteractiveViewer(
            transformationController: _transformController,
            boundaryMargin: const EdgeInsets.all(1000),
            minScale: 0.5,
            maxScale: 4.0,
            panEnabled: !_isScannerActive,
            child: storiesAsync.when(
              data: (stories) {
                return SizedBox(
                  width: 1500,
                  height: 1000,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, _) {
                      return Stack(
                        children: [
                          // Temporal Web Painter
                          CustomPaint(
                            size: const Size(1500, 1000),
                            painter: TemporalWebPainter(
                              color: MythicColors.bronze,
                              activeEra: _selectedEra,
                              nodes: stories,
                              animationValue: _pulseController.value,
                            ),
                          ),
                          // Scanner Lens
                          if (_isScannerActive)
                            Positioned(
                              left: _scannerPosition.dx - 100,
                              top: _scannerPosition.dy - 100,
                              child:
                                  Container(
                                        width: 200,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.cyanAccent,
                                            width: 2,
                                          ),
                                          gradient: RadialGradient(
                                            colors: [
                                              Colors.cyanAccent.withValues(
                                                alpha: 0.1,
                                              ),
                                              Colors.transparent,
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.cyanAccent
                                                  .withValues(alpha: 0.2),
                                              blurRadius: 20,
                                            ),
                                          ],
                                        ),
                                      )
                                      .animate(onPlay: (c) => c.repeat())
                                      .rotate(duration: 5.seconds),
                            ),
                          // Nodes
                          ..._buildNodes(stories),
                        ],
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => const SizedBox.shrink(),
            ),
          ),

          // 2. Scanner Gesture Layer (Only when active)
          if (_isScannerActive)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanUpdate: (d) {
                  setState(() {
                    debugPrint('Scanner Pan: ${d.delta}');
                    // Map screen movement to map movement based on active scale
                    final scale = _transformController.value
                        .getMaxScaleOnAxis();
                    _scannerPosition += d.delta / scale;
                  });
                },
                child: Container(color: Colors.transparent),
              ),
            ),

          // 2. HUD Overlay
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),

                const Spacer(),

                // Scanner Toggle
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24, bottom: 24),
                    child: FloatingActionButton.extended(
                      backgroundColor: _isScannerActive
                          ? Colors.cyanAccent
                          : const Color(0xFF2A2A35),
                      foregroundColor: _isScannerActive
                          ? Colors.black
                          : Colors.white,
                      onPressed: () {
                        setState(() {
                          _isScannerActive = !_isScannerActive;
                          // Reset scanner to center of map if activating
                          if (_isScannerActive) {
                            _scannerPosition = const Offset(750, 500);
                          }
                        });
                      },
                      icon: Icon(
                        _isScannerActive ? Icons.radar : Icons.radar_outlined,
                      ),
                      label: Text(
                        _isScannerActive
                            ? 'SCANNING ACTIVE'
                            : 'ACTIVATE SCANNER',
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Era Timeline Control (Bottom)
                TimelineScrubber(
                  selectedEra: _selectedEra,
                  onEraChanged: (era) {
                    setState(() => _selectedEra = era);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to filter and build nodes
  List<Widget> _buildNodes(List<Story> stories) {
    // Filter Logic
    final visibleStories = stories.where((s) {
      if (_selectedEra == 'FUTURE') {
        return true;
      }
      if (_selectedEra == 'MYTHIC') {
        return s.eraId == 'MYTHIC' || s.eraId == 'ANCIENT';
      }
      if (_selectedEra == 'MODERN') {
        return s.eraId == 'MODERN' || s.eraId == 'INDUSTRIAL';
      }
      return s.eraId == _selectedEra;
    }).toList();

    return visibleStories.map((story) {
      // Scanner Logic
      // If it's a "Hidden" node (let's say all Rifts are hidden by default unless scanned?),
      // we check distance.
      final bool isHidden = story.isRift && !_isNodeScanned(story);

      // Opacity
      final double opacity = isHidden ? 0.0 : 1.0;

      // If hidden, and scanner is close, show partial ghost?
      double scannerOpacity = 0.0;
      if (_isScannerActive) {
        final nodePos = Offset(
          story.xCoordinate * 1500,
          story.yCoordinate * 1000,
        );
        final dist = (nodePos - _scannerPosition).distance;
        if (dist < 100) {
          // Lens radius
          scannerOpacity = (1 - (dist / 100)).clamp(0.0, 1.0);
        }
      }

      final finalOpacity = max(opacity, scannerOpacity);

      return Positioned(
        left: story.xCoordinate * 1500,
        top: story.yCoordinate * 1000,
        child: Opacity(
          opacity: finalOpacity,
          child: AstralMapNode(
            data: {
              'name': story.title,
              'isRift': story.isRift,
              'era': story.eraId,
            },
            isLocked:
                isHidden &&
                scannerOpacity < 0.8, // Lock interaction if not fully scanned
            onTap: () {
              if (finalOpacity > 0.5) _animateToNode(story);
            },
          ),
        ),
      );
    }).toList();
  }

  bool _isNodeScanned(Story s) {
    return false; // Everything requires scanning/visibility logic for Rifts
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NAVIGATOR',
                style: GoogleFonts.cinzelDecorative(
                  fontSize: 32,
                  color: _isScannerActive
                      ? Colors.cyanAccent
                      : MythicColors.bronze,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const BoxShadow(color: Colors.black, blurRadius: 4),
                  ],
                ),
              ),
              Text(
                _isScannerActive ? 'TEMPORAL SCANNING...' : 'ARCHIVE VII',
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  color:
                      (_isScannerActive
                              ? Colors.cyanAccent
                              : MythicColors.parchment)
                          .withValues(alpha: 0.7),
                  letterSpacing: 2,
                ),
              ).animate(target: _isScannerActive ? 1 : 0).shimmer(),
            ],
          ),
          // Compass Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    (_isScannerActive ? Colors.cyanAccent : MythicColors.bronze)
                        .withValues(alpha: 0.5),
              ),
              color: Colors.black26,
            ),
            child: Center(
              child: Icon(
                _isScannerActive ? Icons.radar : Icons.explore,
                color: _isScannerActive
                    ? Colors.cyanAccent
                    : MythicColors.bronze,
                size: 28,
              ).animate(onPlay: (c) => c.repeat()).rotate(duration: 10.seconds),
            ),
          ),
        ],
      ),
    );
  }

  void _animateToNode(Story story) {
    final targetScale = 2.0;
    final x =
        -(story.xCoordinate * 1000 * targetScale) +
        (MediaQuery.of(context).size.width / 2);
    final y =
        -(story.yCoordinate * 1000 * targetScale) +
        (MediaQuery.of(context).size.height / 2);

    final matrix = Matrix4.identity()
      ..setTranslationRaw(x, y, 0.0)
      ..multiply(
        Matrix4.diagonal3Values(targetScale, targetScale, targetScale),
      );

    final animation =
        Matrix4Tween(begin: _transformController.value, end: matrix).animate(
          CurvedAnimation(
            parent: AnimationController(vsync: this, duration: 800.ms)
              ..forward(),
            curve: Curves.easeInOut,
          ),
        );

    animation.addListener(() {
      _transformController.value = animation.value;
    });

    _showNodeDetails(context, story);
  }

  void _showNodeDetails(BuildContext context, Story story) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A24),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: MythicColors.bronze, width: 2)),
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 20)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              story.title.toUpperCase(),
              style: GoogleFonts.cinzelDecorative(
                fontSize: 24,
                color: MythicColors.parchment,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ERA: ${story.eraId}',
              style: GoogleFonts.spaceMono(
                color: MythicColors.bronze,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              story.description,
              style: GoogleFonts.exo2(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MythicColors.bronze,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close modal
                  if (story.isRift) {
                    context.go('/rifts');
                  } else {
                    context.go('/story/${story.id}');
                  }
                },
                child: Text(
                  'INITIATE JUMP',
                  style: GoogleFonts.cinzel(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
} // End of State logic (replacing the previous _animateToNode... end)
