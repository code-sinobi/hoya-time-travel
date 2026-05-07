import 'package:chrono_app/features/story/models/story_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Story model has required fields', () {
    final story = Story(
      id: 'test',
      title: 'Test Story',
      eraId: 'ancient',
      description: 'A test story',
      heroImageUrl: null,
    );

    expect(story.id, 'test');
    expect(story.title, 'Test Story');
  });

  test('StoryNode model has required fields', () {
    final node = StoryNode(
      id: 'node_1',
      type: NodeType.narrative,
      content: 'Test content',
    );

    expect(node.id, 'node_1');
    expect(node.type, NodeType.narrative);
  });
}
