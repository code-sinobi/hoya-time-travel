import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/story_models.dart';
import '../living_story/presentation/living_story_controller.dart';

import 'widgets/story_view.dart';
import 'widgets/resource_header.dart';
import '../../core/theme/era_theme.dart';

class StoryScreen extends ConsumerStatefulWidget {
  final String storyId;
  const StoryScreen({super.key, required this.storyId});

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger loading session when screen mounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(livingStoryControllerProvider.notifier)
          .loadSession(widget.storyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<EraTheme>();
    if (theme == null) return const SizedBox();

    // Watch the living story state
    final storyState = ref.watch(livingStoryControllerProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          storyState.session?.storyId ?? 'Story',
          style: theme.headlineStyle.copyWith(fontSize: 20),
        ),
        backgroundColor: theme.backgroundColor.withValues(alpha: 0.8),
        elevation: 0,
        leading: BackButton(color: theme.primaryColor),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: ResourceHeader(),
        ),
      ),
      body: _buildBody(context, ref, theme, storyState),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    EraTheme theme,
    LivingStoryState state,
  ) {
    if (state.isLoading) {
      return _buildLoadingState(theme);
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.error}',
              style: theme.bodyStyle.copyWith(
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref
                  .read(livingStoryControllerProvider.notifier)
                  .loadSession(widget.storyId),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.currentNode != null) {
      return StoryView(
        node: state.currentNode!,
        onChoiceSelected: (choice) => _handleChoice(ref, choice),
      );
    }

    return const Center(child: Text('No content available'));
  }

  Widget _buildLoadingState(EraTheme theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.primaryColor),
          const SizedBox(height: 16),
          Text(
            'Consulting the Timeline...',
            style: theme.bodyStyle.copyWith(color: theme.primaryColor),
          ),
        ],
      ),
    );
  }

  void _handleChoice(WidgetRef ref, StoryChoice choice) {
    ref.read(livingStoryControllerProvider.notifier).makeChoice(choice);
  }
}
