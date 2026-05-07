import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/era_theme.dart';
import '../repositories/story_repository.dart';

final storyLibraryProvider =
    NotifierProvider<StoryLibraryNotifier, List<StoryMetadata>>(
  StoryLibraryNotifier.new,
);

class StoryLibraryNotifier extends Notifier<List<StoryMetadata>> {
  @override
  List<StoryMetadata> build() {
    _fetch();
    return fallbackStoryLibrary;
  }

  Future<void> _fetch() async {
    final stories = await ref.read(storyRepositoryProvider).getStories();
    if (stories.isNotEmpty) {
      state = stories
          .map(
            (s) => StoryMetadata(
              id: s.id,
              title: s.title,
              culture: s.culture ?? 'Unknown',
              era: s.eraId,
              moral: s.moralTheme ?? '',
              description: s.description,
              imagePath: s.heroImageUrl ?? 'assets/images/default.jpeg',
              primaryColor: MythicColors.bronze,
              aiPrompt: '',
              isPremium: s.isPremium,
            ),
          )
          .toList();
    }
  }
}

class StoryMetadata {
  const StoryMetadata({
    required this.id,
    required this.title,
    required this.culture,
    required this.era,
    required this.moral,
    required this.description,
    required this.imagePath,
    required this.primaryColor,
    required this.aiPrompt,
    this.isPremium = false,
  });
  final String id;
  final String title;
  final String culture;
  final String era;
  final String moral;
  final String description;
  final String imagePath;
  final Color primaryColor;
  final String aiPrompt;
  final bool isPremium;

  // Alias for UI consistency - allows easy future era-based color logic overrides
  Color get eraColor => primaryColor;
}

final List<StoryMetadata> fallbackStoryLibrary = [
  // AMERICAS (5)
  const StoryMetadata(
    id: 's01',
    title: 'Coyote Steals Fire',
    culture: 'Native American (Navajo)',
    era: 'Mythic Age',
    moral: 'Selflessness',
    description:
        'Journey with Coyote as he outwits the Fire Beings to bring warmth to humanity, learning that true leadership means serving others.',
    imagePath: 'assets/images/s01_coyote.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Watercolor style, starry night desert landscape, a glowing coyote running with a burning stick, sparks flying into the sky, mystical atmosphere, 8k resolution.',
  ),
  const StoryMetadata(
    id: 's02',
    title: 'The Feathered Serpent',
    culture: 'Aztec',
    era: 'Pre-Columbian',
    moral: 'Wisdom vs Power',
    description:
        'Walk with Quetzalcoatl as he brings knowledge to his people, facing the dark sorcery of Tezcatlipoca.',
    imagePath: 'assets/images/s02_quetzal.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Aztec mythology art, Quetzalcoatl feathered serpent flying over ancient Tenochtitlan pyramids, vibrant turquoise and gold feathers, dramatic sunlight.',
  ),
  const StoryMetadata(
    id: 's03',
    title: 'The Hero Twins',
    culture: 'Mayan',
    era: 'Ancient Maya',
    moral: 'Resilience',
    description:
        'Descend into Xibalba with Hunahpu and Xbalanque to defeat the Lords of Death through wit and ball games.',
    imagePath: 'assets/images/s03_twins.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Mayan art style, two young warriors playing a ball game in a dark underworld cavern, glowing limestone, mysterious shadows, dynamic action.',
  ),
  const StoryMetadata(
    id: 's04',
    title: 'The Origin of Stories',
    culture: 'Seneca',
    era: 'Pre-Columbian',
    moral: 'Oral Tradition',
    description:
        'A boy listens to a talking stone that tells the first stories of the world, learning why history must be remembered.',
    imagePath: 'assets/images/s04_stone.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Digital fantasy painting, a young native american boy sitting on moss in a forest listening to a large ancient glowing stone, magical particles, serene.',
  ),
  const StoryMetadata(
    id: 's05',
    title: 'Sedna of the Sea',
    culture: 'Inuit',
    era: 'Ancient Arctic',
    moral: 'Respect for Nature',
    description:
        'Dive into the icy depths to meet Sedna, the mother of sea mammals, and learn why we must honor the gifts of the ocean.',
    imagePath: 'assets/images/s05_sedna.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Underwater fantasy scene, Sedna the sea goddess with flowing hair tangling with sea creatures, icy blue waters, aurora borealis shining from above surface.',
  ),

  // AFRICA (5)
  const StoryMetadata(
    id: 's06',
    title: 'Anansi & The Wisdom Pot',
    culture: 'West African (Akan)',
    era: 'Folklore Age',
    moral: 'Sharing Knowledge',
    description:
        'Follow the trickster spider Anansi as he tries to hoard all the world\'s wisdom in a clay pot, only to learn a valuable lesson.',
    imagePath: 'assets/images/s06_anansi.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Folklore illustration, Anansi the spider man climbing a tall palm tree carrying a clay pot, vibrant savanna sunset background, stylized african patterns.',
  ),
  const StoryMetadata(
    id: 's07',
    title: 'The Lion\'s Whisker',
    culture: 'Ethiopian',
    era: 'Traditional',
    moral: 'Patience',
    description:
        'A stepmother seeks a magic potion to win her stepson\'s love, but learns that patience and care are the strongest magic of all.',
    imagePath: 'assets/images/s07_lion.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Warm storybook art, an ethiopian woman slowly approaching a sleeping lion in a cave, golden lighting, tense but peaceful atmosphere.',
  ),
  const StoryMetadata(
    id: 's08',
    title: 'Sundiata: Lion King',
    culture: 'Mali Empire',
    era: 'Medieval Africa',
    moral: 'Overcoming Adversity',
    description:
        'The epic tale of the crippled prince who rose to become the founder of the great Mali Empire.',
    imagePath: 'assets/images/s08_sundiata.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Epic historical art, Sundiata Keita standing tall holding a royal staff, vast african plains and armies in background, regal and powerful.',
  ),
  const StoryMetadata(
    id: 's09',
    title: 'Makeda\'s Journey',
    culture: 'Kingdom of Sheba',
    era: 'Ancient',
    moral: 'Quest for Wisdom',
    description:
        'Join the Queen of Sheba on her caravan across the desert to test the wisdom of King Solomon.',
    imagePath: 'assets/images/s09_makeda.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Orientalist painting style, a grand caravan of camels and riches crossing the desert dunes, Queen of Sheba in a palanquin, sunset.',
  ),
  const StoryMetadata(
    id: 's10',
    title: 'Shaka\'s Spear',
    culture: 'Zulu',
    era: '19th Century',
    moral: 'Innovation',
    description:
        'How a young warrior changed warfare forever by introducing the short spear, teaching the value of adapting to challenges.',
    imagePath: 'assets/images/s10_shaka.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Action portrait, Shaka Zulu holding a short spear and shield, intense expression, dynamic pose, dust swirling, african warrior.',
  ),

  // EUROPE (5)
  const StoryMetadata(
    id: 's11',
    title: 'The Sword of Damocles',
    culture: 'Ancient Greece',
    era: 'Classical',
    moral: 'Responsibility',
    description:
        'Sit upon the throne of Dionysius and discover that great power brings constant peril and heavy responsibility.',
    imagePath: 'assets/images/s11_damocles.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Classical oil painting, king sitting on a golden throne looking up at a sharp sword hanging by a single horse hair, dramatic chiaroscuro lighting.',
  ),
  const StoryMetadata(
    id: 's12',
    title: 'Odin\'s Sacrifice',
    culture: 'Norse',
    era: 'Viking Age',
    moral: 'Sacrifice for Wisdom',
    description:
        'Witness the Allfather sacrifice his eye at Mimir\'s well to gain the wisdom to save the nine worlds.',
    imagePath: 'assets/images/s12_odin.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Dark fantasy art, Odin standing before a mystical glowing well, one eye covered, raven on shoulder, ancient runic stones, misty forest.',
  ),
  const StoryMetadata(
    id: 's13',
    title: 'King Arthur\'s Test',
    culture: 'Celtic/British',
    era: 'Medieval',
    moral: 'Rightful Leadership',
    description:
        'A young squire pulls the sword from the stone, proving that true nobility comes from within, not just from blood.',
    imagePath: 'assets/images/s13_arthur.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Medieval fantasy art, young Arthur pulling a glowing sword from a stone in a forest clearing, magical light beams, amazed crowd in background.',
  ),
  const StoryMetadata(
    id: 's14',
    title: 'Pandora\'s Box',
    culture: 'Ancient Greece',
    era: 'Mythic Age',
    moral: 'Hope',
    description:
        'When curiosity releases all evils into the world, one thing remains. Discover the power of Hope in the darkest times.',
    imagePath: 'assets/images/s14_pandora.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Classical greek art, a woman opening an ornate golden box, dark smoke spirits escaping, a single small glowing light remaining inside.',
  ),
  const StoryMetadata(
    id: 's15',
    title: 'Jeanne d\'Arc',
    culture: 'France',
    era: 'Medieval',
    moral: 'Conviction',
    description:
        'A peasant girl hears voices that lead her to command armies. A story of unshakeable faith in one\'s destiny.',
    imagePath: 'assets/images/s15_joan.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Historical oil painting, Joan of Arc in armor holding a white banner on a horse, battlefield background, dramatic sky, rays of light.',
  ),

  // ASIA (5)
  const StoryMetadata(
    id: 's16',
    title: 'The Empty Pot',
    culture: 'Ancient China',
    era: 'Han Dynasty',
    moral: 'Honesty',
    description:
        'The Emperor gives seeds to all children. One boy returns with an empty pot, teaching us that honesty is more valuable than success.',
    imagePath: 'assets/images/s16_empty_pot.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Digital painting, ancient chinese emperor holding an empty clay pot, surrounded by children with blooming flowers, golden hour lighting, intricate silk robes.',
  ),
  const StoryMetadata(
    id: 's17',
    title: 'The Banyan Deer',
    culture: 'Ancient India (Jataka)',
    era: 'Vedic Age',
    moral: 'Compassion',
    description:
        'A golden deer king offers his own life to save a pregnant doe, moving a human king to ban hunting forever.',
    imagePath: 'assets/images/s17_deer.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Detailed fantasy art, a golden deer standing in a lush indian forest, protecting a smaller doe, beams of sunlight filtering through banyan roots, peaceful.',
  ),
  const StoryMetadata(
    id: 's18',
    title: 'Momotaro',
    culture: 'Feudal Japan',
    era: 'Edo Period',
    moral: 'Teamwork',
    description:
        'The Peach Boy bands together with a dog, monkey, and pheasant to defeat the ogres, showing that different strengths make a strong team.',
    imagePath: 'assets/images/s18_momotaro.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Ukiyo-e style japanese woodblock print, a boy warrior standing with a dog, monkey, and pheasant facing a dark island fortress, stylized waves.',
  ),
  const StoryMetadata(
    id: 's19',
    title: 'The Blind Men & Elephant',
    culture: 'India',
    era: 'Ancient',
    moral: 'Perspective',
    description:
        'Six blind men touch different parts of an elephant and argue about what it is, teaching us that our truth is only part of the whole.',
    imagePath: 'assets/images/s19_elephant.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Storybook illustration, a massive elephant surrounded by six men touching different parts, soft textured style, educational vibe.',
  ),
  const StoryMetadata(
    id: 's20',
    title: 'Aladdin\'s Lamp',
    culture: 'Arabian Nights',
    era: 'Golden Age',
    moral: 'Greed vs Contentment',
    description:
        'A poor boy finds infinite power in a lamp, but learns that true happiness cannot be wished for.',
    imagePath: 'assets/images/s20_aladdin.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Arabian nights fantasy art, a glowing magical oil lamp in a dark treasure cave, blue smoke swirling into a form, gold coins scattered.',
  ),

  // OCEANIA & MIDDLE EAST (5)
  const StoryMetadata(
    id: 's21',
    title: 'Maui\'s Hook',
    culture: 'Polynesian',
    era: 'Mythic Pacific',
    moral: 'Determination',
    description:
        'The demigod Maui seeks to slow the sun itself to help his people, proving that even the impossible can be challenged.',
    imagePath: 'assets/images/s21_maui.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Polynesian tattoo style art, a muscular man holding a giant glowing fishhook catching the sun, ocean waves crashing, stylized sun rays.',
  ),
  const StoryMetadata(
    id: 's22',
    title: 'Gilgamesh & Enkidu',
    culture: 'Mesopotamia',
    era: 'Sumerian',
    moral: 'Friendship',
    description:
        'The arrogant king Gilgamesh finds his equal in the wild man Enkidu, learning that connection is the cure for tyranny.',
    imagePath: 'assets/images/s22_gilgamesh.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Epic concept art, two legendary warriors standing back to back fighting a celestial bull, ancient babylonian ziggurat in background, cinematic.',
  ),
  const StoryMetadata(
    id: 's23',
    title: 'Isis & Osiris',
    culture: 'Ancient Egypt',
    era: 'Old Kingdom',
    moral: 'Undying Love',
    description:
        'Isis journeys across the world to reassemble her fallen husband, a testament to devotion that transcends death.',
    imagePath: 'assets/images/s23_isis.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Egyptian mural style brought to life, Goddess Isis with winged arms spread over a golden sarcophagus, magical hieroglyphs floating.',
  ),
  const StoryMetadata(
    id: 's24',
    title: 'The Rainbow Serpent',
    culture: 'Australian Aboriginal',
    era: 'Dreamtime',
    moral: 'Creation',
    description:
        'Travel the Dreamtime tracks with the Rainbow Serpent as it carves the rivers and mountains, shaping the world.',
    imagePath: 'assets/images/s24_rainbow.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Aboriginal dot painting style 3D render, a giant colorful snake slithering through an australian canyon creating a river, vibrant earth tones.',
  ),
  const StoryMetadata(
    id: 's25',
    title: 'Sinbad the Sailor',
    culture: 'Middle Eastern',
    era: 'Abbasid Caliphate',
    moral: 'Curiosity',
    description:
        'Set sail on the seven seas, facing rocs and giants, driven by the insatiable human need to explore the unknown.',
    imagePath: 'assets/images/s25_sinbad.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Maritime fantasy art, a medieval arabian ship tossing in a storm, a giant bird (Roc) flying overhead, dramatic waves, adventure.',
  ),

  // MODERN/FOLKLORE MIX (5)
  const StoryMetadata(
    id: 's26',
    title: 'John Henry',
    culture: 'American Folklore',
    era: 'Industrial Age',
    moral: 'Human Spirit',
    description:
        'The steel-driving man races against a steam drill, proving that the human spirit has value no machine can replace.',
    imagePath: 'assets/images/s26_henry.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'American folklore art, a strong man swinging a hammer against a railroad spike, steam engine in background, sweat and grit, dramatic lighting.',
    isPremium: true,
  ),
  const StoryMetadata(
    id: 's27',
    title: 'Baba Yaga',
    culture: 'Slavic',
    era: 'Medieval Russia',
    moral: 'Intuition',
    description:
        'Vasilisa must use her intuition to survive the tasks of the witch Baba Yaga in her chicken-legged hut.',
    imagePath: 'assets/images/s27_baba.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Dark fairytale art, a wooden hut standing on giant chicken legs in a birch forest, glowing skulls on fence, mysterious atmosphere.',
    isPremium: true,
  ),
  const StoryMetadata(
    id: 's28',
    title: 'The Golem of Prague',
    culture: 'Jewish Folklore',
    era: '16th Century',
    moral: 'Hubris',
    description:
        'A rabbi creates a clay protector for his people, but learns the dangers of creating life without a soul.',
    imagePath: 'assets/images/s28_golem.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Gothic atmosphere, a giant clay figure standing in a cobblestone alley of old Prague, glowing hebrew letters on forehead, foggy night.',
    isPremium: true,
  ),
  const StoryMetadata(
    id: 's29',
    title: 'La Llorona',
    culture: 'Mexican Folklore',
    era: 'Colonial',
    moral: 'Regret',
    description:
        'A cautionary tale of a weeping spirit, teaching the heavy weight of actions taken in anger.',
    imagePath: 'assets/images/s29_llorona.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Ghostly horror style, a weeping woman in a white dress standing by a river bank at night, translucent and ethereal, sorrowful mood.',
    isPremium: true,
  ),
  const StoryMetadata(
    id: 's30',
    title: 'Hachiko',
    culture: 'Modern Japan',
    era: '1920s',
    moral: 'Loyalty',
    description:
        'The true story of a faithful dog who waited for his master every day for nine years, defining loyalty for a nation.',
    imagePath: 'assets/images/s30_hachiko.jpeg',
    primaryColor: MythicColors.bronze,
    aiPrompt:
        'Vintage japanese photography style colorized, an Akita dog sitting patiently at a train station in snow, 1920s clothing in background, emotional.',
    isPremium: true,
  ),
];
