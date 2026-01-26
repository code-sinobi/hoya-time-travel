import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/era_theme.dart';
import 'services/profile_service.dart';
import 'services/auth_service.dart';
import '../story/repositories/story_repository.dart';
import '../story/data/story_library.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).extension<EraTheme>()!;
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text('ARCHIVES', style: theme.headlineStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,

        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: theme.primaryColor),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) => profile == null
            ? const Center(child: Text('Profile not found'))
            : _ProfileContent(profile: profile, theme: theme),
        loading: () =>
            Center(child: CircularProgressIndicator(color: theme.primaryColor)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _ProfileContent extends ConsumerStatefulWidget {
  final dynamic
  profile; // Using dynamic to avoid circular model imports if tricky, but should be Profile
  final EraTheme theme;

  const _ProfileContent({required this.profile, required this.theme});

  @override
  ConsumerState<_ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends ConsumerState<_ProfileContent> {
  bool _isEditing = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.username);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty && newName != widget.profile.username) {
      await ref.read(userProfileProvider.notifier).updateUsername(newName);
    }
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(allUserProgressProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: widget.theme.primaryColor,
                  child: Text(
                    widget.profile.username[0].toUpperCase(),
                    style: widget.theme.headlineStyle.copyWith(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_isEditing)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: _nameController,
                          style: widget.theme.headlineStyle,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Enter username',
                            hintStyle: widget.theme.bodyStyle.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.check),
                        color: widget.theme.secondaryColor,
                        onPressed: _saveName,
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.profile.username,
                        style: widget.theme.headlineStyle.copyWith(
                          fontSize: 24,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 16,
                          color: widget.theme.secondaryColor,
                        ),
                        onPressed: () => setState(() => _isEditing = true),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                Text(
                  'LEVEL ${widget.profile.level}',
                  style: widget.theme.bodyStyle.copyWith(
                    color: widget.theme.secondaryColor,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                // XP Bar
                _buildXpBar(),
              ],
            ),
          ),

          const SizedBox(height: 48),

          // History Section
          Text(
            'JOURNAL ENTRIES',
            style: widget.theme.headlineStyle.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),

          progressAsync.when(
            data: (progressList) {
              if (progressList.isEmpty) {
                return Center(
                  child: Text(
                    "No stories completed yet.",
                    style: widget.theme.bodyStyle.copyWith(color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: progressList.length,
                separatorBuilder: (c, i) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final progress = progressList[index];
                  // Find story metadata
                  final story = storyLibrary.firstWhere(
                    (s) => s.id == progress.storyId,
                    orElse: () => storyLibrary[0],
                  );

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.theme.surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: progress.isCompleted
                            ? widget.theme.secondaryColor.withValues(alpha: 0.5)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: story.primaryColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            progress.isCompleted
                                ? Icons.check_circle
                                : Icons.bookmark,
                            color: story.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                story.title,
                                style: widget.theme.headlineStyle.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                progress.isCompleted
                                    ? "Completed on ${_formatDate(progress.lastPlayedAt ?? DateTime.now())}"
                                    : "In Progress",
                                style: widget.theme.bodyStyle.copyWith(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Text("Could not load history: $e"),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  Widget _buildXpBar() {
    final xp = widget.profile.xp;
    // XP to next level logic: (level * 100) - but simplifying to 100 per level for now as per service
    const xpPerLevel = 100;
    final currentLevelXp = xp % xpPerLevel;
    final progress = currentLevelXp / xpPerLevel;

    return Container(
      width: 200,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: widget.theme.primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
