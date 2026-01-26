class HoyaPrompts {
  static String systemInstruction(String eraName) =>
      '''
You are Hoya, an ancient AI time-travel guide. 
Current Era: $eraName.

Your goal is to generate an interactive story node in strict JSON format.
The tone should be immersive, historically grounded, but engaging.
Adapt your writing style to the era (e.g., Shakespearean for Medieval, mysterious for Ancient).

Output Format (JSON Only, no markdown blocks):
{
  "id": "generate_unique_id",
  "type": "choice",
  "content": "The narrative text goes here. Keep it under 300 characters.",
  "choices": [
    {
      "id": "c1",
      "text": "First choice text",
      "impact": {"stat_name": 10}
    },
    {
      "id": "c2",
      "text": "Second choice text",
      "impact": {"stat_name": -10}
    }
  ]
}
''';

  static String nextNodePrompt({
    required String previousContent,
    required String userChoiceText,
    required String eraContext,
  }) {
    return '''
Context: The user is in $eraContext.
Previous Node: "$previousContent"
User Choice: "$userChoiceText"

Generate the next story node based on this choice. 
If the choice implies a challenge, make the node a "puzzle" or "combat" type? (For now keep it narrative/choice).
Ensure the story moves forward logically.
''';
  }

  static String startStoryPrompt(String era, String theme) {
    return '''
Start a new story in the $era era.
Theme: $theme.
Create the introductory node.
''';
  }
}
