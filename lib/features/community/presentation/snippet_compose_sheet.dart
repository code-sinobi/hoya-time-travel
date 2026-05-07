import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/era_theme.dart';
import 'snippet_controller.dart';

class SnippetComposeSheet extends ConsumerStatefulWidget {
  const SnippetComposeSheet({super.key, this.originStoryId});
  final String? originStoryId;

  @override
  ConsumerState<SnippetComposeSheet> createState() =>
      _SnippetComposeSheetState();
}

class _SnippetComposeSheetState extends ConsumerState<SnippetComposeSheet> {
  final _controller = TextEditingController();
  final Set<String> _selectedTags = {};

  static const int _maxChars = 280;

  static const List<String> _availableTags = [
    'wisdom',
    'courage',
    'fear',
    'hope',
    'void',
    'growth',
    'memory',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;

    ref.read(snippetControllerProvider.notifier).submitSnippet(
          content: _controller.text,
          tags: _selectedTags.toList(),
          originStoryId: widget.originStoryId,
        );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for success/error
    ref.listen(snippetControllerProvider, (previous, next) {
      if (!mounted) return;
      if (next is AsyncData && previous is AsyncLoading) {
        final messenger = ScaffoldMessenger.of(context);
        context.pop(); // Close sheet
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Your echo has been released into the Void.'),
            backgroundColor: MythicColors.deepIndigo,
          ),
        );
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to release echo: ${next.error}'),
            backgroundColor: MythicColors.ochreRed,
          ),
        );
      }
    });

    final isLoading = ref.watch(snippetControllerProvider).isLoading;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E2C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: MythicColors.bronze)),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ETCH A SNIPPET',
            style: GoogleFonts.cinzelDecorative(
              fontSize: 20,
              color: MythicColors.bronze,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Share a fragment of wisdom or a whisper of memory. If worthy, it may echo for others.',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 16,
              color: MythicColors.parchment.withValues(alpha: 0.8),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Text Input
          TextField(
            controller: _controller,
            maxLength: _maxChars,
            maxLines: 4,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 18,
              color: MythicColors.parchment,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black38,
              hintText: 'Type your echo here...',
              hintStyle: TextStyle(
                color: MythicColors.stoneGray.withValues(alpha: 0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: MythicColors.stoneGray.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: MythicColors.bronze),
              ),
              counterStyle: const TextStyle(color: MythicColors.stoneGray),
            ),
          ),

          const SizedBox(height: 16),

          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableTags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return ChoiceChip(
                label: Text(tag.toUpperCase()),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                },
                backgroundColor: Colors.transparent,
                selectedColor: MythicColors.bronze.withValues(alpha: 0.3),
                labelStyle: GoogleFonts.cinzel(
                  fontSize: 10,
                  color:
                      isSelected ? MythicColors.bronze : MythicColors.stoneGray,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? MythicColors.bronze
                        : MythicColors.stoneGray.withValues(alpha: 0.5),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Submit Button
          ElevatedButton(
            onPressed: isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: MythicColors.bronze,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : Text(
                    'RELEASE TO THE VOID',
                    style: GoogleFonts.cinzel(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
