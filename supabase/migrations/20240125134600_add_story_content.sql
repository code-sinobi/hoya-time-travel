-- Create story_nodes table
CREATE TABLE IF NOT EXISTS public.story_nodes (
    id text NOT NULL PRIMARY KEY,
    story_id text NOT NULL,
    type text NOT NULL DEFAULT 'narrative', -- narrative, choice, puzzle, combat, ending
    content text NOT NULL,
    background_image text,
    created_at timestamp with time zone DEFAULT now()
);

-- Create story_choices table
CREATE TABLE IF NOT EXISTS public.story_choices (
    id text NOT NULL PRIMARY KEY,
    node_id text NOT NULL REFERENCES public.story_nodes(id) ON DELETE CASCADE,
    text text NOT NULL,
    next_node_id text REFERENCES public.story_nodes(id), -- Null if it's an end or dynamic
    impact jsonb,
    created_at timestamp with time zone DEFAULT now()
);

-- RLS Policies
ALTER TABLE public.story_nodes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.story_choices ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Enable read access for all users" ON public.story_nodes
    FOR SELECT USING (true);

CREATE POLICY "Enable read access for all users" ON public.story_choices
    FOR SELECT USING (true);

-- Insert Content for Story 1: Coyote Steals Fire (s01)
INSERT INTO public.story_nodes (id, story_id, type, content) VALUES
('s01_start', 's01', 'narrative', 'Long ago, before humans had fire, they shivering in the cold winter nights. The Fire Beings held all the fire for themselves high up on their mountain.'),
('s01_n02', 's01', 'choice', 'Coyote saw the humans suffering and decided to help. He gathered his animal friends: Squirrel, Chipmunk, and Frog. "We need a plan," Coyote said.'),
('s01_n03_stealth', 's01', 'choice', 'Coyote crept up the mountain while the Fire Beings were sleeping. He seized a glowing coal in his jaws!'),
('s01_n03_negotiate', 's01', 'choice', 'Coyote walked boldly to the Fire Beings'' camp. "Share your warmth," he asked. They laughed and chased him away with burning sticks!'),
('s01_n04_chase', 's01', 'choice', 'Coyote ran down the mountain, the Fire Beings hot on his heels. His tail caught fire (which is why it is blacks-tipped today). He tossed the coal to Squirrel.'),
('s01_n05_squirrel', 's01', 'choice', 'Squirrel caught the coal, but it burned her back, curling her tail. She threw it to Chipmunk.'),
('s01_n06_chipmunk', 's01', 'choice', 'The Fire Beings were close! Chipmunk froze in fear as the coal singed three stripes down his back. Frog shouted, "To me!"'),
('s01_n07_frog', 's01', 'choice', 'Frog swallowed the coal and dove into the water. The Fire Beings could not follow. He swam to the humans'' wood pile and spat out the coal into the wood.'),
('s01_end_success', 's01', 'ending', 'The wood caught fire. The humans were warm at last! They honored Coyote and his friends for their bravery and sacrifice. True leadership serves others.');

INSERT INTO public.story_choices (id, node_id, text, next_node_id) VALUES
('s01_c01', 's01_start', 'Continue', 's01_n02'),
('s01_c02_a', 's01_n02', 'Sneak in and steal it', 's01_n03_stealth'),
('s01_c02_b', 's01_n02', 'Try to ask politely', 's01_n03_negotiate'),
('s01_c03_a', 's01_n03_stealth', 'Run for it!', 's01_n04_chase'),
('s01_c03_b', 's01_n03_negotiate', 'Run away!', 's01_n04_chase'), -- Both lead to chase
('s01_c04', 's01_n04_chase', 'Pass to Squirrel', 's01_n05_squirrel'),
('s01_c05', 's01_n05_squirrel', 'Pass to Chipmunk', 's01_n06_chipmunk'),
('s01_c06', 's01_n06_chipmunk', 'Pass to Frog', 's01_n07_frog'),
('s01_c07', 's01_n07_frog', 'Give fire to humans', 's01_end_success');


-- Story 2: The Feathered Serpent (s02)
INSERT INTO public.story_nodes (id, story_id, type, content) VALUES
('s02_start', 's02', 'narrative', 'The great city of Tenochtitlan shimmered under the sun. Quetzalcoatl, the Feathered Serpent, walked among his people in human form, teaching them arts and agriculture.'),
('s02_n02', 's02', 'choice', 'But his dark brother, Tezcatlipoca, grew jealous. "They become too powerful with this knowledge," he whispered. He devised a trick to shame Quetzalcoatl.'),
('s02_n03_mirror', 's02', 'choice', 'Tezcatlipoca presented Quetzalcoatl with a smoking mirror. "Look upon your true self," he famously said. Quetzalcoatl saw a frail, old face.'),
('s02_n04_drink', 's02', 'choice', 'Despairing of his mortality, he was offered a "medicine" by his brother. It was pulque, and he became fast asleep, neglecting his duties.'),
('s02_n05_exile', 's02', 'choice', 'Upon waking, Quetzalcoatl felt great shame. "I must leave," he declared. "But I shall return one day to judge how you have used my gifts."'),
('s02_end', 's02', 'ending', 'He sailed East on a raft of serpents. The people waited for his return, understanding that wisdom requires vigilance against one''s own weakness.');

INSERT INTO public.story_choices (id, node_id, text, next_node_id) VALUES
('s02_c01', 's02_start', 'Listen to Tezcatlipoca', 's02_n02'),
('s02_c02', 's02_n02', 'Look in the mirror', 's02_n03_mirror'),
('s02_c03', 's02_n03_mirror', 'Accept the drink', 's02_n04_drink'),
('s02_c04', 's02_n04_drink', 'Wake up', 's02_n05_exile'),
('s02_c05', 's02_n05_exile', 'Sail away', 's02_end');

-- GENERIC TEMPLATES FOR REMAINING STORIES (To ensure app works for all)
-- In a real scenario, we would fill these out uniquely.
DO $$
DECLARE
    story_ids text[] := ARRAY[
        's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
        's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18',
        's19', 's20', 's21', 's22', 's23', 's24', 's25', 's26',
        's27', 's28', 's29', 's30'
    ];
    sid text;
BEGIN
    FOREACH sid IN ARRAY story_ids LOOP
        -- Start Node
        INSERT INTO public.story_nodes (id, story_id, type, content)
        VALUES (sid || '_start', sid, 'narrative', 'This is the beginning of the legend. The world was different then, filled with magic and mystery.');
        
        -- Middle Node
        INSERT INTO public.story_nodes (id, story_id, type, content)
        VALUES (sid || '_n02', sid, 'choice', 'Our hero faced a difficult choice that would determine their fate and teach them a valuable lesson.');

        -- End Node
        INSERT INTO public.story_nodes (id, story_id, type, content)
        VALUES (sid || '_end', sid, 'ending', 'And so, the lesson was learned. The legend lives on to this day.');

        -- Choices
        INSERT INTO public.story_choices (id, node_id, text, next_node_id)
        VALUES 
        (sid || '_c01', sid || '_start', 'Begin the Journey', sid || '_n02'),
        (sid || '_c02', sid || '_n02', 'Complete the Quest', sid || '_end');
    END LOOP;
END $$;
