import 'package:chrono_app/core/widgets/mythic_loading.dart';
import 'package:chrono_app/core/utils/app_haptics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_route.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/mythic_colors.dart';
import '../../auth/models/profile.dart';

import '../../story/data/story_library.dart';
import '../../story/repositories/story_repository.dart';

class MythicHUD extends ConsumerStatefulWidget {
  const MythicHUD({
    super.key,
    required this.profileAsync,
  });

  final AsyncValue<Profile?> profileAsync;

  @override
  ConsumerState<MythicHUD> createState() => _MythicHUDState();
}

class _MythicHUDState extends ConsumerState<MythicHUD>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 50,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CHRONO',
                style: AppTypography.headlineXl.copyWith(
                  fontSize: 16,
                  color: MythicColors.bronze.withValues(alpha: 0.7),
                  letterSpacing: 4,
                ),
              ),
              Text(
                'ARCHIVE',
                style: AppTypography.heroDisplay.copyWith(
                  fontSize: 32,
                  shadows: [
                    const BoxShadow(blurRadius: 10),
                  ],
                ),
              ),
            ],
          ),

          // Profile Medallion with Completion Ring
          Stack(
            alignment: Alignment.center,
            children: [
              // Completion Ring (Wired to Real Progress)
              SizedBox(
                width: 58,
                height: 58,
                child: Consumer(
                  builder: (context, ref, child) {
                    final progressList =
                        ref.watch(allUserProgressProvider).value ?? [];
                    final completedCount =
                        progressList.where((p) => p.isCompleted).length;
                    final totalStories = ref.watch(storyLibraryProvider).length;
                    final progress =
                        totalStories > 0 ? completedCount / totalStories : 0.0;

                    return CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 3,
                      color: MythicColors.bronze,
                      backgroundColor:
                          MythicColors.bronze.withValues(alpha: 0.15),
                    );
                  },
                ),
              ),

              Tooltip(
                message: 'User Profile',
                child: InkWell(
                  onTap: () {
                    AppHaptics.buttonPress();
                    context.pushNamed(AppRoute.profile.name);
                  },
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MythicColors.deepIndigo,
                      border: Border.all(color: MythicColors.bronze, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: MythicColors.black.withValues(alpha: 0.45),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Center(
                      child: widget.profileAsync.when(
                        data: (profile) {
                          final initial = (profile?.username ?? 'T')
                              .substring(0, 1)
                              .toUpperCase();
                          if (profile?.avatarUrl != null &&
                              profile!.avatarUrl!.isNotEmpty) {
                            return ClipOval(
                              child: Image.network(
                                profile.avatarUrl!,
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildInitial(initial),
                              ),
                            );
                          }
                          return _buildInitial(initial);
                        },
                        loading: () => const MythicLoading(),
                        error: (context, error) => const Icon(
                          Icons.error,
                          color: MythicColors.error,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Online Status Dot
              Positioned(
                bottom: 0,
                right: 0,
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        width: 12 + (_pulseController.value * 2),
                        height: 12 + (_pulseController.value * 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: MythicColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInitial(String initial) {
    return Text(
      initial,
      style: AppTypography.headingLg.copyWith(
        color: MythicColors.bronze,
      ),
    );
  }
}
