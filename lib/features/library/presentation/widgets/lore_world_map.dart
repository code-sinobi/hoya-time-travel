import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/mythic_colors.dart';
import '../library_provider.dart';
import 'lore_preview_sheet.dart';
import 'map_story_node.dart';

class LoreWorldMap extends ConsumerStatefulWidget {
  const LoreWorldMap({super.key});

  @override
  ConsumerState<LoreWorldMap> createState() => _LoreWorldMapState();
}

class _LoreWorldMapState extends ConsumerState<LoreWorldMap> {
  final TransformationController _transformController =
      TransformationController();

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
                        // Background Map Image (placeholder solid/gradient for now if no asset)
                        Container(
                          decoration: const BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                MythicColors.deepIndigo,
                                MythicColors.voidBackground,
                              ],
                              radius: 1.5,
                            ),
                          ),
                          child: const Center(
                            child: Opacity(
                              opacity: 0.1,
                              child: Icon(
                                Icons.public,
                                size: 400,
                                color: MythicColors.bronze,
                              ),
                            ),
                          ),
                        ),

                        // Story Nodes
                        ...stories.map((story) {
                          final pos = story.mapCoordinate;
                          return Positioned(
                            left: pos.dx * mapSize.width,
                            top: pos.dy * mapSize.height,
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
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}
