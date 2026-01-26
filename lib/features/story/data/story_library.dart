import 'package:flutter/material.dart';

class StoryMetadata {
  final String id;
  final String title;
  final String culture;
  final String era;
  final String moral;
  final String description;
  final String imagePath;
  final Color primaryColor;
  final String aiPrompt;

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
  });
}

const List<StoryMetadata> storyLibrary = [
  // AMERICAS (5)
  StoryMetadata(
    id: 's01',
    title: 'Coyote Steals Fire',
    culture: 'Native American (Navajo)',
    era: 'Mythic Age',
    moral: 'Selflessness',
    description:
        'Journey with Coyote as he outwits the Fire Beings to bring warmth to humanity, learning that true leadership means serving others.',
    imagePath: 'assets/images/s01_coyote.jpeg',
    primaryColor: Color(0xFFD35400),
    aiPrompt:
        'Watercolor style, starry night desert landscape, a glowing coyote running with a burning stick, sparks flying into the sky, mystical atmosphere, 8k resolution.',
  ),
  StoryMetadata(
    id: 's02',
    title: 'The Feathered Serpent',
    culture: 'Aztec',
    era: 'Pre-Columbian',
    moral: 'Wisdom vs Power',
    description:
        'Walk with Quetzalcoatl as he brings knowledge to his people, facing the dark sorcery of Tezcatlipoca.',
    imagePath: 'assets/images/s02_quetzal.jpeg',
    primaryColor: Color(0xFF27AE60),
    aiPrompt:
        'Aztec mythology art, Quetzalcoatl feathered serpent flying over ancient Tenochtitlan pyramids, vibrant turquoise and gold feathers, dramatic sunlight.',
  ),
  StoryMetadata(
    id: 's03',
    title: 'The Hero Twins',
    culture: 'Mayan',
    era: 'Ancient Maya',
    moral: 'Resilience',
    description:
        'Descend into Xibalba with Hunahpu and Xbalanque to defeat the Lords of Death through wit and ball games.',
    imagePath: 'assets/images/s03_twins.jpeg',
    primaryColor: Color(0xFF8E44AD),
    aiPrompt:
        'Mayan art style, two young warriors playing a ball game in a dark underworld cavern, glowing limestone, mysterious shadows, dynamic action.',
  ),
  StoryMetadata(
    id: 's04',
    title: 'The Origin of Stories',
    culture: 'Seneca',
    era: 'Pre-Columbian',
    moral: 'Oral Tradition',
    description:
        'A boy listens to a talking stone that tells the first stories of the world, learning why history must be remembered.',
    imagePath: 'assets/images/s04_stone.jpeg',
    primaryColor: Color(0xFF7F8C8D),
    aiPrompt:
        'Digital fantasy painting, a young native american boy sitting on moss in a forest listening to a large ancient glowing stone, magical particles, serene.',
  ),
  StoryMetadata(
    id: 's05',
    title: 'Sedna of the Sea',
    culture: 'Inuit',
    era: 'Ancient Arctic',
    moral: 'Respect for Nature',
    description:
        'Dive into the icy depths to meet Sedna, the mother of sea mammals, and learn why we must honor the gifts of the ocean.',
    imagePath: 'assets/images/s05_sedna.jpeg',
    primaryColor: Color(0xFF2980B9),
    aiPrompt:
        'Underwater fantasy scene, Sedna the sea goddess with flowing hair tangling with sea creatures, icy blue waters, aurora borealis shining from above surface.',
  ),

  // AFRICA (5)
  StoryMetadata(
    id: 's06',
    title: 'Anansi & The Wisdom Pot',
    culture: 'West African (Akan)',
    era: 'Folklore Age',
    moral: 'Sharing Knowledge',
    description:
        'Follow the trickster spider Anansi as he tries to hoard all the world\'s wisdom in a clay pot, only to learn a valuable lesson.',
    imagePath: 'assets/images/s06_anansi.jpeg',
    primaryColor: Color(0xFFE67E22),
    aiPrompt:
        'Folklore illustration, Anansi the spider man climbing a tall palm tree carrying a clay pot, vibrant savanna sunset background, stylized african patterns.',
  ),
  StoryMetadata(
    id: 's07',
    title: 'The Lion\'s Whisker',
    culture: 'Ethiopian',
    era: 'Traditional',
    moral: 'Patience',
    description:
        'A stepmother seeks a magic potion to win her stepson\'s love, but learns that patience and care are the strongest magic of all.',
    imagePath: 'assets/images/s07_lion.jpeg',
    primaryColor: Color(0xFFF1C40F),
    aiPrompt:
        'Warm storybook art, an ethiopian woman slowly approaching a sleeping lion in a cave, golden lighting, tense but peaceful atmosphere.',
  ),
  StoryMetadata(
    id: 's08',
    title: 'Sundiata: Lion King',
    culture: 'Mali Empire',
    era: 'Medieval Africa',
    moral: 'Overcoming Adversity',
    description:
        'The epic tale of the crippled prince who rose to become the founder of the great Mali Empire.',
    imagePath: 'assets/images/s08_sundiata.jpeg',
    primaryColor: Color(0xFFA04000),
    aiPrompt:
        'Epic historical art, Sundiata Keita standing tall holding a royal staff, vast african plains and armies in background, regal and powerful.',
  ),
  StoryMetadata(
    id: 's09',
    title: 'Makeda\'s Journey',
    culture: 'Kingdom of Sheba',
    era: 'Ancient',
    moral: 'Quest for Wisdom',
    description:
        'Join the Queen of Sheba on her caravan across the desert to test the wisdom of King Solomon.',
    imagePath: 'assets/images/s09_makeda.jpeg',
    primaryColor: Color(0xFFD4AC0D),
    aiPrompt:
        'Orientalist painting style, a grand caravan of camels and riches crossing the desert dunes, Queen of Sheba in a palanquin, sunset.',
  ),
  StoryMetadata(
    id: 's10',
    title: 'Shaka\'s Spear',
    culture: 'Zulu',
    era: '19th Century',
    moral: 'Innovation',
    description:
        'How a young warrior changed warfare forever by introducing the short spear, teaching the value of adapting to challenges.',
    imagePath: 'assets/images/s10_shaka.jpeg',
    primaryColor: Color(0xFF641E16),
    aiPrompt:
        'Action portrait, Shaka Zulu holding a short spear and shield, intense expression, dynamic pose, dust swirling, african warrior.',
  ),

  // EUROPE (5)
  StoryMetadata(
    id: 's11',
    title: 'The Sword of Damocles',
    culture: 'Ancient Greece',
    era: 'Classical',
    moral: 'Responsibility',
    description:
        'Sit upon the throne of Dionysius and discover that great power brings constant peril and heavy responsibility.',
    imagePath: 'assets/images/s11_damocles.jpeg',
    primaryColor: Color(0xFF7D3C98),
    aiPrompt:
        'Classical oil painting, king sitting on a golden throne looking up at a sharp sword hanging by a single horse hair, dramatic chiaroscuro lighting.',
  ),
  StoryMetadata(
    id: 's12',
    title: 'Odin\'s Sacrifice',
    culture: 'Norse',
    era: 'Viking Age',
    moral: 'Sacrifice for Wisdom',
    description:
        'Witness the Allfather sacrifice his eye at Mimir\'s well to gain the wisdom to save the nine worlds.',
    imagePath: 'assets/images/s12_odin.jpeg',
    primaryColor: Color(0xFF2E4053),
    aiPrompt:
        'Dark fantasy art, Odin standing before a mystical glowing well, one eye covered, raven on shoulder, ancient runic stones, misty forest.',
  ),
  StoryMetadata(
    id: 's13',
    title: 'King Arthur\'s Test',
    culture: 'Celtic/British',
    era: 'Medieval',
    moral: 'Rightful Leadership',
    description:
        'A young squire pulls the sword from the stone, proving that true nobility comes from within, not just from blood.',
    imagePath: 'assets/images/s13_arthur.jpeg',
    primaryColor: Color(0xFFC0392B),
    aiPrompt:
        'Medieval fantasy art, young Arthur pulling a glowing sword from a stone in a forest clearing, magical light beams, amazed crowd in background.',
  ),
  StoryMetadata(
    id: 's14',
    title: 'Pandora\'s Box',
    culture: 'Ancient Greece',
    era: 'Mythic Age',
    moral: 'Hope',
    description:
        'When curiosity releases all evils into the world, one thing remains. Discover the power of Hope in the darkest times.',
    imagePath: 'assets/images/s14_pandora.jpeg',
    primaryColor: Color(0xFF1ABC9C),
    aiPrompt:
        'Classical greek art, a woman opening an ornate golden box, dark smoke spirits escaping, a single small glowing light remaining inside.',
  ),
  StoryMetadata(
    id: 's15',
    title: 'Jeanne d\'Arc',
    culture: 'France',
    era: 'Medieval',
    moral: 'Conviction',
    description:
        'A peasant girl hears voices that lead her to command armies. A story of unshakeable faith in one\'s destiny.',
    imagePath: 'assets/images/s15_joan.jpeg',
    primaryColor: Color(0xFFECF0F1),
    aiPrompt:
        'Historical oil painting, Joan of Arc in armor holding a white banner on a horse, battlefield background, dramatic sky, rays of light.',
  ),

  // ASIA (5)
  StoryMetadata(
    id: 's16',
    title: 'The Empty Pot',
    culture: 'Ancient China',
    era: 'Han Dynasty',
    moral: 'Honesty',
    description:
        'The Emperor gives seeds to all children. One boy returns with an empty pot, teaching us that honesty is more valuable than success.',
    imagePath: 'assets/images/s16_empty_pot.jpeg',
    primaryColor: Color(0xFFE74C3C),
    aiPrompt:
        'Digital painting, ancient chinese emperor holding an empty clay pot, surrounded by children with blooming flowers, golden hour lighting, intricate silk robes.',
  ),
  StoryMetadata(
    id: 's17',
    title: 'The Banyan Deer',
    culture: 'Ancient India (Jataka)',
    era: 'Vedic Age',
    moral: 'Compassion',
    description:
        'A golden deer king offers his own life to save a pregnant doe, moving a human king to ban hunting forever.',
    imagePath: 'assets/images/s17_deer.jpeg',
    primaryColor: Color(0xFFF39C12),
    aiPrompt:
        'Detailed fantasy art, a golden deer standing in a lush indian forest, protecting a smaller doe, beams of sunlight filtering through banyan roots, peaceful.',
  ),
  StoryMetadata(
    id: 's18',
    title: 'Momotaro',
    culture: 'Feudal Japan',
    era: 'Edo Period',
    moral: 'Teamwork',
    description:
        'The Peach Boy bands together with a dog, monkey, and pheasant to defeat the ogres, showing that different strengths make a strong team.',
    imagePath: 'assets/images/s18_momotaro.jpeg',
    primaryColor: Color(0xFFFFAF40),
    aiPrompt:
        'Ukiyo-e style japanese woodblock print, a boy warrior standing with a dog, monkey, and pheasant facing a dark island fortress, stylized waves.',
  ),
  StoryMetadata(
    id: 's19',
    title: 'The Blind Men & Elephant',
    culture: 'India',
    era: 'Ancient',
    moral: 'Perspective',
    description:
        'Six blind men touch different parts of an elephant and argue about what it is, teaching us that our truth is only part of the whole.',
    imagePath: 'assets/images/s19_elephant.jpeg',
    primaryColor: Color(0xFF566573),
    aiPrompt:
        'Storybook illustration, a massive elephant surrounded by six men touching different parts, soft textured style, educational vibe.',
  ),
  StoryMetadata(
    id: 's20',
    title: 'Aladdin\'s Lamp',
    culture: 'Arabian Nights',
    era: 'Golden Age',
    moral: 'Greed vs Contentment',
    description:
        'A poor boy finds infinite power in a lamp, but learns that true happiness cannot be wished for.',
    imagePath: 'assets/images/s20_aladdin.jpeg',
    primaryColor: Color(0xFF8E44AD),
    aiPrompt:
        'Arabian nights fantasy art, a glowing magical oil lamp in a dark treasure cave, blue smoke swirling into a form, gold coins scattered.',
  ),

  // OCEANIA & MIDDLE EAST (5)
  StoryMetadata(
    id: 's21',
    title: 'Maui\'s Hook',
    culture: 'Polynesian',
    era: 'Mythic Pacific',
    moral: 'Determination',
    description:
        'The demigod Maui seeks to slow the sun itself to help his people, proving that even the impossible can be challenged.',
    imagePath: 'assets/images/s21_maui.jpeg',
    primaryColor: Color(0xFF3498DB),
    aiPrompt:
        'Polynesian tattoo style art, a muscular man holding a giant glowing fishhook catching the sun, ocean waves crashing, stylized sun rays.',
  ),
  StoryMetadata(
    id: 's22',
    title: 'Gilgamesh & Enkidu',
    culture: 'Mesopotamia',
    era: 'Sumerian',
    moral: 'Friendship',
    description:
        'The arrogant king Gilgamesh finds his equal in the wild man Enkidu, learning that connection is the cure for tyranny.',
    imagePath: 'assets/images/s22_gilgamesh.jpeg',
    primaryColor: Color(0xFFB9770E),
    aiPrompt:
        'Epic concept art, two legendary warriors standing back to back fighting a celestial bull, ancient babylonian ziggurat in background, cinematic.',
  ),
  StoryMetadata(
    id: 's23',
    title: 'Isis & Osiris',
    culture: 'Ancient Egypt',
    era: 'Old Kingdom',
    moral: 'Undying Love',
    description:
        'Isis journeys across the world to reassemble her fallen husband, a testament to devotion that transcends death.',
    imagePath: 'assets/images/s23_isis.jpeg',
    primaryColor: Color(0xFF1F618D),
    aiPrompt:
        'Egyptian mural style brought to life, Goddess Isis with winged arms spread over a golden sarcophagus, magical hieroglyphs floating.',
  ),
  StoryMetadata(
    id: 's24',
    title: 'The Rainbow Serpent',
    culture: 'Australian Aboriginal',
    era: 'Dreamtime',
    moral: 'Creation',
    description:
        'Travel the Dreamtime tracks with the Rainbow Serpent as it carves the rivers and mountains, shaping the world.',
    imagePath: 'assets/images/s24_rainbow.jpeg',
    primaryColor: Color(0xFFC0392B),
    aiPrompt:
        'Aboriginal dot painting style 3D render, a giant colorful snake slithering through an australian canyon creating a river, vibrant earth tones.',
  ),
  StoryMetadata(
    id: 's25',
    title: 'Sinbad the Sailor',
    culture: 'Middle Eastern',
    era: 'Abbasid Caliphate',
    moral: 'Curiosity',
    description:
        'Set sail on the seven seas, facing rocs and giants, driven by the insatiable human need to explore the unknown.',
    imagePath: 'assets/images/s25_sinbad.jpeg',
    primaryColor: Color(0xFF16A085),
    aiPrompt:
        'Maritime fantasy art, a medieval arabian ship tossing in a storm, a giant bird (Roc) flying overhead, dramatic waves, adventure.',
  ),

  // MODERN/FOLKLORE MIX (5)
  StoryMetadata(
    id: 's26',
    title: 'John Henry',
    culture: 'American Folklore',
    era: 'Industrial Age',
    moral: 'Human Spirit',
    description:
        'The steel-driving man races against a steam drill, proving that the human spirit has value no machine can replace.',
    imagePath: 'assets/stories/s26_henry.jpeg',
    primaryColor: Color(0xFF2C3E50),
    aiPrompt:
        'American folklore art, a strong man swinging a hammer against a railroad spike, steam engine in background, sweat and grit, dramatic lighting.',
  ),
  StoryMetadata(
    id: 's27',
    title: 'Baba Yaga',
    culture: 'Slavic',
    era: 'Medieval Russia',
    moral: 'Intuition',
    description:
        'Vasilisa must use her intuition to survive the tasks of the witch Baba Yaga in her chicken-legged hut.',
    imagePath: 'assets/stories/s27_baba.jpeg',
    primaryColor: Color(0xFF5B2C6F),
    aiPrompt:
        'Dark fairytale art, a wooden hut standing on giant chicken legs in a birch forest, glowing skulls on fence, mysterious atmosphere.',
  ),
  StoryMetadata(
    id: 's28',
    title: 'The Golem of Prague',
    culture: 'Jewish Folklore',
    era: '16th Century',
    moral: 'Hubris',
    description:
        'A rabbi creates a clay protector for his people, but learns the dangers of creating life without a soul.',
    imagePath: 'assets/stories/s28_golem.jpeg',
    primaryColor: Color(0xFF7B7D7D),
    aiPrompt:
        'Gothic atmosphere, a giant clay figure standing in a cobblestone alley of old Prague, glowing hebrew letters on forehead, foggy night.',
  ),
  StoryMetadata(
    id: 's29',
    title: 'La Llorona',
    culture: 'Mexican Folklore',
    era: 'Colonial',
    moral: 'Regret',
    description:
        'A cautionary tale of a weeping spirit, teaching the heavy weight of actions taken in anger.',
    imagePath: 'assets/stories/s29_llorona.jpeg',
    primaryColor: Color(0xFF17202A),
    aiPrompt:
        'Ghostly horror style, a weeping woman in a white dress standing by a river bank at night, translucent and ethereal, sorrowful mood.',
  ),
  StoryMetadata(
    id: 's30',
    title: 'Hachiko',
    culture: 'Modern Japan',
    era: '1920s',
    moral: 'Loyalty',
    description:
        'The true story of a faithful dog who waited for his master every day for nine years, defining loyalty for a nation.',
    imagePath: 'assets/stories/s30_hachiko.jpeg',
    primaryColor: Color(0xFFD35400),
    aiPrompt:
        'Vintage japanese photography style colorized, an Akita dog sitting patiently at a train station in snow, 1920s clothing in background, emotional.',
  ),
];
