import '../../domain/domain.dart';

class EchoTemplatesSeed {
  static final List<EchoResponseTemplate> templates = [
    // 1. Post-Story Reflection (Generic)
    const EchoResponseTemplate(
      id: 'echo_post_story_generic_1',
      contextType: EchoContextType.postStory,
      responseTemplate:
          'The path of {recent_story} is closed, but its ripples remain. How does your heart weigh the choice you made?',
      variables: ['recent_story'],
      priority: 10,
    ),

    // 2. Post-Story Reflection (Dominant Trait: Wisdom)
    const EchoResponseTemplate(
      id: 'echo_post_story_wisdom_1',
      contextType: EchoContextType.postStory,
      triggerConditions: {'dominant_trait': 'wisdom'},
      responseTemplate:
          'You walked with open eyes in {recent_story}. Knowledge is a heavy burden, Traveler, yet you carry it well.',
      variables: ['recent_story'],
      tone: 'encouraging',
      priority: 20, // Higher priority than generic
    ),

    // 3. Trait Reflection (Courage High)
    const EchoResponseTemplate(
      id: 'echo_trait_courage_high',
      contextType: EchoContextType.traitReflection,
      triggerConditions: {'min_trait:courage': 15},
      responseTemplate:
          "Your spirit burns bright. The ancients would have called you 'Lion-Hearted'. Do not let this fire consume you.",
      tone: 'warning',
      priority: 20,
    ),

    // 4. Greeting (Daytime)
    const EchoResponseTemplate(
      id: 'echo_greeting_day',
      contextType: EchoContextType.greeting,
      responseTemplate:
          'The sun watches your steps today, Traveler. What do you seek?',
      tone: 'neutral',
      priority: 10,
    ),

    // 5. Snippet Coaching (Empathy)
    const EchoResponseTemplate(
      id: 'echo_snippet_empathy',
      contextType: EchoContextType.snippetCoaching,
      triggerConditions: {'dominant_trait': 'empathy'},
      responseTemplate:
          'Your words hold the warmth of understanding. Share this, that others may find comfort in the void.',
      tone: 'warm',
      priority: 30,
    ),
  ];
}
