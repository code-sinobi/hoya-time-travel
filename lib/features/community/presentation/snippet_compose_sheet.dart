import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/era_theme.dart';
import '../data/community_repository.dart';

class SnippetComposeSheet extends ConsumerStatefulWidget {
  final String eraId;

  const SnippetComposeSheet({super.key, required this.eraId});

  @override
  ConsumerState<SnippetComposeSheet> createState() => _SnippetComposeSheetState();
}

class _SnippetComposeSheetState extends ConsumerState<SnippetComposeSheet> {
  final _controller = TextEditingController();
  final List<String> _tags = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_controller.text.trim().isEmpty) return;
    
    setState(() => _isLoading = true);
    
    try {
      await ref.read(communityRepositoryProvider).submitSnippet(
        content: _controller.text.trim(),
        eraId: widget.eraId,
        tags: _tags,
      );
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thread submitted for curation')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NEW TIMELINE FRAGMENT',
            style: GoogleFonts.orbitron(
              color: MythicColors.bronze,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 4,
            maxLength: 280,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'What occurred in this branch of time?',
              hintStyle: const TextStyle(color: Colors.white24),
              fillColor: Colors.white.withValues(alpha: 0.05),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Tag chips (Mock)
          Wrap(
            spacing: 8,
            children: ['MYSTERY', 'BATTLE', 'LORE', 'NATURE']
                .map((tag) => FilterChip(
                      label: Text(tag),
                      selected: _tags.contains(tag),
                      onSelected: (val) {
                        setState(() {
                          if (val) _tags.add(tag);
                          else _tags.remove(tag);
                        });
                      },
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: MythicColors.bronze,
                foregroundColor: Colors.black,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text('SUBMIT FRAGMENT'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
