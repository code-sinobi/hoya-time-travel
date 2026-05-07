import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/era_theme.dart';
import '../../story/models/story_models.dart';
import '../data/chronicler_repository.dart';
import 'story_graph_screen.dart'; // To refresh the provider

final currentNodeProvider =
    FutureProvider.family<StoryNode?, String>((ref, nodeId) async {
  if (nodeId == 'new') return null; // New node
  return ref.watch(chroniclerRepositoryProvider).fetchNodeWithChoices(nodeId);
});

class NodeEditorScreen extends ConsumerStatefulWidget {
  final String storyId;
  final String nodeId;

  const NodeEditorScreen({
    super.key,
    required this.storyId,
    required this.nodeId,
  });

  @override
  ConsumerState<NodeEditorScreen> createState() => _NodeEditorScreenState();
}

class _NodeEditorScreenState extends ConsumerState<NodeEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _contentController;
  late NodeType _type;
  bool _isRoot = false;
  bool _isEnding = false;
  String? _endingType;

  // Working list of choices
  List<StoryChoice> _choices = [];
  bool _isDirty = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    _type = NodeType.narrative;
  }

  // Load initial data
  void _initializeData(StoryNode? node) {
    if (node != null && !_isDirty) {
      _contentController.text = node.content;
      _type = node.type;
      _isRoot = node.isRoot;
      _isEnding = node.isEnding;
      _endingType = node.endingType;
      _choices = List.from(node.choices);
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final node = StoryNode(
        id: widget.nodeId, // 'new' or UUID
        type: _type,
        content: _contentController.text,
        isRoot: _isRoot,
        isEnding: _isEnding,
        endingType: _endingType,
        choices: _choices,
      );

      await ref
          .read(chroniclerRepositoryProvider)
          .upsertNode(node, widget.storyId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Node saved successfully')),
        );
        ref.invalidate(storyNodesProvider(widget.storyId));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving node. Please check your data.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nodeAsync = ref.watch(currentNodeProvider(widget.nodeId));

    return Scaffold(
      backgroundColor: const Color(0xFF15151A),
      appBar: AppBar(
        title: Text(
          widget.nodeId == 'new' ? 'New Node' : 'Edit Node',
          style: GoogleFonts.cinzel(color: MythicColors.parchment),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (widget.nodeId != 'new')
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                // Confirm delete
              },
            ),
          IconButton(
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.save, color: MythicColors.bronze),
            onPressed: _isLoading ? null : _save,
          ),
        ],
      ),
      body: nodeAsync.when(
        data: (node) {
          // Initialize data from loaded node (only if not dirty)
          if (!_isDirty && node != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_isDirty) _initializeData(node);
            });
          }

          return Form(
            key: _formKey,
            onChanged: () => _isDirty = true,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Type Selector
                DropdownButtonFormField<NodeType>(
                  initialValue: _type,
                  dropdownColor: const Color(0xFF2A2A35),
                  decoration: const InputDecoration(labelText: 'Node Type'),
                  items: NodeType.values
                      .map(
                        (t) => DropdownMenuItem(
                          value: t,
                          child: Text(
                            t.name.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _type = v!),
                ),

                const SizedBox(height: 16),

                // Content
                TextFormField(
                  controller: _contentController,
                  maxLines: 5,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Content required' : null,
                ),

                const SizedBox(height: 16),

                // Toggles
                SwitchListTile(
                  title: const Text(
                    'Is Root Node',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  value: _isRoot,
                  activeThumbColor: MythicColors.bronze,
                  onChanged: (v) => setState(() => _isRoot = v),
                ),

                SwitchListTile(
                  title: const Text(
                    'Is Ending',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  value: _isEnding,
                  activeThumbColor: Colors.redAccent,
                  onChanged: (v) => setState(() => _isEnding = v),
                ),

                const Divider(color: Colors.white24, height: 32),

                // Choices
                if (!_isEnding) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CHOICES (${_choices.length})',
                        style: GoogleFonts.cinzel(
                          color: MythicColors.parchment,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_link,
                          color: MythicColors.bronze,
                        ),
                        onPressed: _addChoice,
                      ),
                    ],
                  ),
                  ..._choices
                      .asMap()
                      .entries
                      .map((entry) => _buildChoiceTile(entry.key, entry.value)),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => const Center(
          child: Text(
            'Failed to load node. Please try again.',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceTile(int index, StoryChoice choice) {
    return Card(
      color: Colors.black26,
      child: ListTile(
        title: Text(
          choice.text.isEmpty ? '(Empty Action)' : choice.text,
          style: const TextStyle(color: Colors.white70),
        ),
        subtitle: Text(
          'To: ${choice.nextNodeId ?? "None"}',
          style: const TextStyle(color: Colors.white30, fontSize: 10),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, size: 16, color: Colors.white24),
          onPressed: () {
            setState(() {
              _choices.removeAt(index);
              _isDirty = true;
            });
          },
        ),
        onTap: () => _editChoice(index, choice),
      ),
    );
  }

  void _addChoice() {
    // Show dialog to add choice
    // Simplified for MVP
    setState(() {
      _choices.add(
        StoryChoice(
          id: 'new_${DateTime.now().millisecondsSinceEpoch}',
          text: 'New Choice',
          nextNodeId: null,
        ),
      );
      _isDirty = true;
    });
  }

  void _editChoice(int index, StoryChoice choice) {
    final textCtrl = TextEditingController(text: choice.text);
    final targetCtrl = TextEditingController(text: choice.nextNodeId ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: const Text('Edit Choice', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Action Text'),
            ),
            TextField(
              controller: targetCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Target Node ID'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              setState(() {
                _choices[index] = StoryChoice(
                  id: choice.id,
                  text: textCtrl.text,
                  nextNodeId: targetCtrl.text.isEmpty ? null : targetCtrl.text,
                  // preserve others
                );
                _isDirty = true;
              });
              Navigator.pop(ctx);
              textCtrl.dispose();
              targetCtrl.dispose();
            },
          ),
        ],
      ),
    );
  }
}
