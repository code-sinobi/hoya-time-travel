import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/story_models.dart';
import 'services/story_service.dart';
import 'widgets/story_view.dart';
import '../../core/theme/era_theme.dart';

class StoryScreen extends ConsumerStatefulWidget {
  final String storyId;
  const StoryScreen({super.key, required this.storyId});

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  StoryNode? _currentNode;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialNode();
  }

  Future<void> _loadInitialNode() async {
    final node = await ref
        .read(storyServiceProvider.notifier)
        .loadNode(widget.storyId, 'start');

    if (mounted) {
      setState(() {
        _currentNode = node;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleChoice(StoryChoice choice) async {
    if (choice.nextNodeId == null) {
      // Handle dynamic/error case or just return
      return;
    }

    setState(() => _isLoading = true);

    final nextNode = await ref
        .read(storyServiceProvider.notifier)
        .loadNode(widget.storyId, choice.nextNodeId!);

    if (mounted) {
      setState(() {
        _currentNode = nextNode;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<EraTheme>();
    if (theme == null) return const SizedBox();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'The Lost Scroll',
          style: theme.headlineStyle.copyWith(fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: theme.primaryColor),
      ),
      extendBodyBehindAppBar: true,
      body: _isLoading
          ? _buildLoadingState(theme)
          : _currentNode != null
          ? StoryView(node: _currentNode!, onChoiceSelected: _handleChoice)
          : Center(
              child: Text('Error retrieving story', style: theme.bodyStyle),
            ),
    );
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
}
