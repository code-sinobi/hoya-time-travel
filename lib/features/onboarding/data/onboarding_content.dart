import 'package:flutter/material.dart';

/// Data model for onboarding page content
class OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;
  final String? lottieAsset;

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    this.lottieAsset,
  });
}

/// Onboarding content for 3 pages
const List<OnboardingPageData> onboardingPages = [
  OnboardingPageData(
    title: 'Journey Through Time',
    description:
        'Travel through myths and legends from every corner of the world. Experience stories from Ancient Greece to Modern Japan.',
    icon: Icons.explore,
  ),
  OnboardingPageData(
    title: 'Choose Your Path',
    description:
        'Your choices shape the narrative. Every decision matters and leads to different outcomes. Will you be brave or clever?',
    icon: Icons.join_inner,
  ),
  OnboardingPageData(
    title: 'Learn Through Stories',
    description:
        'Each tale carries timeless lessons about human nature. Discover wisdom from across cultures and eras.',
    icon: Icons.auto_stories,
  ),
];
