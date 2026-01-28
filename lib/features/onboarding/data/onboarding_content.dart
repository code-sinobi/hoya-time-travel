import 'package:flutter/material.dart';
import '../widgets/mythology_crawl.dart';

/// Data model for onboarding page content
class OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;
  final String? lottieAsset;
  final List<CrawlSection>? crawlSections;

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    this.lottieAsset,
    this.crawlSections,
  });
}

/// Onboarding content for 3 pages
final List<OnboardingPageData> onboardingPages = [
  const OnboardingPageData(
    title: 'Journey Through Time',
    description:
        'Travel through myths and legends from every corner of the world. Experience stories from Ancient Greece to Modern Japan.',
    icon: Icons.explore,
    lottieAsset: 'assets/lottie/onboarding-1.json',
    crawlSections: [
      CrawlSection(
        title: 'JOURNEY THROUGH TIME',
        body:
            'Travel through myths and legends from every corner of the world. Experience stories from Ancient Greece to Modern Japan, from Norse sagas to African folklore. Each tale is a portal to another era, another civilization, another way of understanding the cosmos.',
      ),
    ],
  ),
  const OnboardingPageData(
    title: 'Choose Your Path',
    description:
        'Your choices shape the narrative. Every decision matters and leads to different outcomes. Will you be brave or clever?',
    icon: Icons.join_inner,
    lottieAsset: 'assets/lottie/onboarding-2.json',
    crawlSections: [
      CrawlSection(
        title: 'DISCOVER WISDOM',
        subtitle: 'ANCIENT TRUTHS AWAIT',
        body:
            'Each legend carries timeless wisdom. Uncover lessons of courage, sacrifice, love, and transformation that have guided humanity for millennia. These stories are more than entertainment—they are the collective memory of our species, teaching us what it means to be human.',
      ),
    ],
  ),
  const OnboardingPageData(
    title: 'Learn Through Stories',
    description:
        'Each tale carries timeless lessons about human nature. Discover wisdom from across cultures and eras.',
    icon: Icons.auto_stories,
    lottieAsset: 'assets/lottie/onboarding-3.json',
    crawlSections: [
      CrawlSection(
        title: 'ENTER THE PORTAL',
        body:
            'Your journey begins now. Step through the portal and immerse yourself in stories that have shaped civilizations and inspired generations. From the dawn of humanity to the distant future, the Library of Legends awaits.',
      ),
    ],
  ),
];
