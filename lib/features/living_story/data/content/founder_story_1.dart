import '../../../story/models/story_models.dart';
import '../../domain/domain.dart';

/// "The Scholar's Burden" - Ancient Era Founder Story
/// Theme: Knowledge vs. Power
/// Culture: Ancient Greek (Alexandria)
class FounderStory1 {
  static const String storyId = 'scholar_burden_v1';

  static final Story metadata = Story(
    id: storyId,
    title: "The Scholar's Burden",
    eraId: 'ancient',
    description:
        'In the shadow of the Great Library, you must choose between preserving truth or saving your city from Roman fire.',
    heroImageUrl: 'assets/stories/scholar_hero.png', // Placeholder
    culture: 'Greek',
    moralTheme: 'Knowledge vs. Power',
    difficulty: 'Hard',
    estimatedDurationMinutes: 20,
    totalNodes: 50,
  );

  static final List<StoryNode> nodes = [
    // Root Node
    StoryNode(
      id: 'node_1_root',
      type: NodeType.narrative,
      content:
          'The smoke of the harbor stings your eyes. Alexandria burns. Around you, scholars scramble to save scrolls, their white robes stained with soot and ink. You hold the key to the Secret Archives—knowledge that could save the city, or doom it.',
      isRoot: true,
      traitImpacts: {'curiosity': 1},
      choices: [
        StoryChoice(
          id: 'choice_1_to_archive',
          text: 'Enter the Secret Archives. The knowledge must be saved.',
          teCost: 10,
          traitImpacts: {'wisdom': 2, 'curiosity': 1},
          nextNodeId: 'node_2_archive',
        ),
        StoryChoice(
          id: 'choice_1_to_streets',
          text: 'Forget the books. Save the people in the market.',
          teCost: 15,
          traitImpacts: {'empathy': 2, 'justice': 1},
          nextNodeId: 'node_2_streets',
        ),
      ],
    ),

    // Path A: Save the Scrolls (Wisdom/Patience)
    StoryNode(
      id: 'node_2_archive',
      type: NodeType.narrative,
      content:
          'You rush into the cool darkness of the Archives. The air smells of papyrus and centuries of silence. A Roman soldier blocks the corridor, his gladius drawn.',
      resourceCosts: {'te': 5},
      choices: [
        // Add follow-up choices here...
      ],
    ),

    // Path B: Save the People (Justice/Empathy)
    StoryNode(
      id: 'node_2_streets',
      type: NodeType.narrative,
      content:
          'You turn from the library to the screams in the street. A family is trapped beneath a fallen pillar. The fire draws closer.',
      resourceCosts: {'te': 5},
      choices: [
        // Add follow-up choices here...
      ],
    ),
  ];

  // Removed static choices list as they are now nested
  static final List<NodeVariant> variants = [
    // Variant for node_2_archive if user is already a known scholar
    const NodeVariant(
      id: 'var_node_2_known',
      baseNodeId: 'node_2_archive',
      variantTrigger: 'has:patron_of_knowledge',
      variantContent:
          "You rush into the Archives. The Roman soldier hesitates, recognizing your robes. 'Scholar?' he grunts, lowering his blade slightly. 'My orders are to burn, not to murder.'",
    ),
  ];
}
