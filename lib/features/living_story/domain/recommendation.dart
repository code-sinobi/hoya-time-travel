import '../../story/models/story_models.dart';

class Recommendation {
  const Recommendation({
    required this.story,
    required this.relevanceScore,
  });
  final Story story;
  final double relevanceScore;
}
