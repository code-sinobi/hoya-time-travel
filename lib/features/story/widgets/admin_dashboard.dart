import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/ai/openrouter_service.dart';
import '../data/story_library.dart';
import '../services/narrative_orchestrator.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  late NarrativeOrchestrator _orchestrator;
  final Map<String, String> _status = {};
  bool _isExpandingAll = false;

  @override
  void initState() {
    super.initState();
    _orchestrator = NarrativeOrchestrator(
      ref.read(openRouterServiceProvider),
      Supabase.instance.client,
    );
  }

  Future<void> _expandStory(StoryMetadata story) async {
    setState(() => _status[story.id] = 'Expanding...');
    try {
      await _orchestrator.expandStory(story);
      setState(() => _status[story.id] = 'Done ✅');
    } on Object {
      setState(() => _status[story.id] = 'Error ❌');
    }
  }

  Future<void> _expandAll() async {
    setState(() => _isExpandingAll = true);
    for (final story in fallbackStoryLibrary) {
      await _expandStory(story);
    }
    setState(() => _isExpandingAll = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chrono Admin - Story Expansion'),
        actions: [
          if (!_isExpandingAll)
            TextButton.icon(
              onPressed: _expandAll,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Expand All 30'),
              style: TextButton.styleFrom(foregroundColor: Colors.white),
            )
          else
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: fallbackStoryLibrary.length,
        itemBuilder: (context, index) {
          final story = fallbackStoryLibrary[index];
          final status = _status[story.id] ?? 'Pending';

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: story.primaryColor,
              child: Text(
                story.id,
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
            title: Text(story.title),
            subtitle: Text('${story.culture} | ${story.era}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    color: status.contains('Error')
                        ? Colors.red
                        : status.contains('Done')
                            ? Colors.green
                            : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: status == 'Expanding...'
                      ? null
                      : () => _expandStory(story),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
