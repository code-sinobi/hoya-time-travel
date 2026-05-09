import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/mythic_colors.dart';
import '../library_provider.dart';
import 'lore_preview_sheet.dart';
import 'map_story_node.dart';
import 'starfield_painter.dart';

class LoreWorldMap extends ConsumerStatefulWidget {
  const LoreWorldMap({super.key});

  @override
  ConsumerState<LoreWorldMap> createState() => _LoreWorldMapState();
}

class _LoreWorldMapState extends ConsumerState<LoreWorldMap> {
  final TransformationController _transformController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    // Center the initial view so stories at coordinate (0.5, 0.5) are visible.
    // Map is 2x width, 1.5x height. Story at (0.5,0.5) → (mapW, 0.75*mapH).
    // Translate to bring that point to screen center.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = MediaQuery.of(context).size;
      // Shift content left by half a screen width and up by a quarter height.
      _transformController.value = Matrix4.translationValues(
        -size.width * 0.5,
        -size.height * 0.25,
        0,
      );
    });
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _zoomToNode(Offset position, Size mapSize) {
    // Basic zoom to center on the node
    final targetScale = 2.0;
    final x = -position.dx * mapSize.width * targetScale +
        MediaQuery.of(context).size.width / 2;
    final y = -position.dy * mapSize.height * targetScale +
        MediaQuery.of(context).size.height / 2;

    _transformController.value = Matrix4.identity()
      // ignore: deprecated_member_use
      ..translate(x, y)
      // ignore: deprecated_member_use
      ..scale(targetScale);
  }

  @override
  Widget build(BuildContext context) {
    final storiesAsync = ref.watch(libraryFilteredStoriesProvider);

    return storiesAsync.when(
      data: (stories) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (stories.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 64,
                      color: MythicColors.stoneGray,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'MAP EMPTY',
                      style: TextStyle(
                        color: MythicColors.stoneGray,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No stories found in this temporal coordinate.',
                      style: TextStyle(color: MythicColors.stoneGray),
                    ),
                  ],
                ),
              );
            }

            final mapSize =
                Size(constraints.maxWidth * 2, constraints.maxHeight * 1.5);

            return Stack(
              children: [
                InteractiveViewer(
                  transformationController: _transformController,
                  minScale: 0.5,
                  maxScale: 3.0,
                  constrained: false,
                  boundaryMargin: EdgeInsets.all(constraints.maxWidth),
                  child: SizedBox(
                    width: mapSize.width,
                    height: mapSize.height,
                    child: Stack(
                      children: [
                        // Background Map Image (Starfield)
                        SizedBox.expand(
                          child: CustomPaint(
                            painter: StarfieldPainter(),
                          ),
                        ),

                        // Story Nodes
                        ...stories.map((story) {
                          var pos = story.mapCoordinate;
                          // Apply deterministic jitter for stories with default coordinates (0.5, 0.5)
                          if (pos == const Offset(0.5, 0.5)) {
                            final hash = story.id.hashCode;
                            // Generate a stable pseudo-random coordinate based on the hash
                            final dx = 0.1 + (hash % 100) / 100.0 * 0.8;
                            final dy =
                                0.1 + ((hash ~/ 100) % 100) / 100.0 * 0.8;
                            pos = Offset(dx, dy);
                          }

                          return Positioned(
                            left: pos.dx * mapSize.width - 24,
                            top: pos.dy * mapSize.height - 24,
                            width: 48,
                            height: 48,
                            child: MapStoryNode(
                              story: story,
                              onTap: () {
                                _zoomToNode(pos, mapSize);
                                LorePreviewSheet.show(context, story);
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                // Compass / Reset Zoom
                Positioned(
                  bottom: 100, // Above nav bar
                  right: 24,
                  child: FloatingActionButton.small(
                    tooltip: 'Reset zoom',
                    backgroundColor: MythicColors.surface2,
                    child:
                        const Icon(Icons.explore, color: MythicColors.bronze),
                    onPressed: () {
                      _transformController.value = Matrix4.identity();
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: MythicColors.bronze),
      ),
      error: (err, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color: MythicColors.ochreRed,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'Could not load map',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: () => ref.refresh(libraryFilteredStoriesProvider),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
