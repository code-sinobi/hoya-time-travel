import 'package:chrono_app/core/widgets/mythic_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/app_haptics.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/mythic_colors.dart';
import '../../living_story/presentation/user_traits_controller.dart';
import '../../living_story/presentation/widgets/wisdom_compass_chart.dart';
import '../models/profile.dart';
import '../services/profile_service.dart';

class ProfileIdCard extends ConsumerWidget {
  const ProfileIdCard({required this.profileAsync, super.key});

  final AsyncValue<Profile?> profileAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: MythicColors.surface2.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: MythicColors.bronze.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: MythicColors.black.withValues(alpha: 0.5),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar Medallion
          _AvatarMedallion(profile: profileAsync.value),

          const SizedBox(height: 20),

          profileAsync.when(
            data: (profile) => Column(
              children: [
                Text(
                  profile?.username?.toUpperCase() ?? 'UNKNOWN TRAVELER',
                  style: AppTypography.headingMd.copyWith(
                    color: MythicColors.parchment,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: MythicColors.surface0.withValues(alpha: 0.38),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: MythicColors.stoneGray,
                    ),
                  ),
                  child: Text(
                    "ID: ${profile?.id.substring(0, 8).toUpperCase() ?? '8X-92-B'}",
                    style: AppTypography.code.copyWith(
                      color: MythicColors.bronze,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            loading: () => const MythicLoading(),
            error: (_, __) => const Text(
              'ID ERROR',
              style: TextStyle(color: MythicColors.error),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Subscription Badge
          profileAsync.when(
            data: (profile) {
              final isPatron = profile?.subscriptionTier == 'patron' ||
                  profile?.subscriptionTier == 'oracle';
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isPatron
                          ? MythicColors.bronze.withValues(alpha: 0.2)
                          : Colors.transparent,
                      border: Border.all(
                        color: isPatron
                            ? MythicColors.bronze
                            : MythicColors.white.withValues(alpha: 0.24),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'TIER: ${(profile?.subscriptionTier ?? "FREE").toUpperCase()}',
                      style: AppTypography.label.copyWith(
                        color: isPatron
                            ? MythicColors.bronze
                            : MythicColors.white.withValues(alpha: 0.54),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  if (!isPatron) ...[
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: MythicColors.bronze,
                        ),
                        foregroundColor: MythicColors.bronze,
                      ),
                      onPressed: () {
                        ref
                            .read(userProfileProvider.notifier)
                            .upgradeSubscription();
                      },
                      child: const Text('UPGRADE TO PATRON'),
                    ),
                  ],
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 20),

          profileAsync.when(
            data: (profile) {
              if (profile?.role == 'chronicler' || profile?.role == 'admin') {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: MythicColors.deepIndigo.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: MythicColors.deepIndigo,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.edit_note,
                        color: MythicColors.fluxCyan,
                        size: 16,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'MASTER CHRONICLER',
                        style: AppTypography.label.copyWith(
                          color: MythicColors.fluxCyan,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: TextButton.icon(
                  icon: const Icon(
                    Icons.history_edu,
                    color: MythicColors.bronze,
                  ),
                  label: Text(
                    'BECOME A CHRONICLER',
                    style: AppTypography.label,
                  ),
                  onPressed: () {
                    context.push('/chronicler/onboarding');
                  },
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Wisdom Compass Section
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'WISDOM COMPASS',
              style: AppTypography.label.copyWith(
                fontSize: 14,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ref.watch(userTraitsControllerProvider).when(
                data: (traits) => SizedBox(
                  height: 220,
                  child: WisdomCompassChart(
                    traits: traits.toCompassMap(),
                  ),
                ),
                loading: () => const SizedBox(
                  height: 220,
                  child: Center(
                    child: MythicLoading(),
                  ),
                ),
                error: (_, __) => const SizedBox(
                  height: 220,
                ), // Fail gracefully
              ),
        ],
      ),
    );
  }
}

class _AvatarMedallion extends ConsumerStatefulWidget {
  const _AvatarMedallion({required this.profile});
  final Profile? profile;

  @override
  ConsumerState<_AvatarMedallion> createState() => _AvatarMedallionState();
}

class _AvatarMedallionState extends ConsumerState<_AvatarMedallion> {
  bool _isInscribing = false;

  Future<void> _pickAndInscribe() async {
    if (widget.profile == null) return;

    AppHaptics.buttonPress();
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (xFile == null) return;

    setState(() => _isInscribing = true);

    try {
      await ref.read(userProfileProvider.notifier).inscribeAvatar(xFile.path);
      AppHaptics.success();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inscribe failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isInscribing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Inscribe Profile Avatar',
      button: true,
      child: InkWell(
        onTap: _isInscribing ? null : _pickAndInscribe,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: MythicColors.deepIndigo,
            border: Border.all(
              color: MythicColors.bronze,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: MythicColors.bronze.withValues(alpha: 0.3),
                blurRadius: 20,
              ),
            ],
          ),
          child: ClipOval(
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (widget.profile?.avatarUrl != null)
                  Image.network(
                    widget.profile!.avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildFallback(),
                  )
                else
                  _buildFallback(),

                if (_isInscribing)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: MythicLoading(),
                    ),
                  ),

                // Hover/Icon overlay
                if (!_isInscribing)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 8, top: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: MythicColors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(
              duration: 4.seconds,
              color: MythicColors.white.withValues(alpha: 0.24),
            ),
      ),
    );
  }

  Widget _buildFallback() {
    return Center(
      child: Text(
        widget.profile?.username?.substring(0, 1).toUpperCase() ?? 'T',
        style: AppTypography.heroDisplay.copyWith(
          color: MythicColors.parchment,
        ),
      ),
    );
  }
}
