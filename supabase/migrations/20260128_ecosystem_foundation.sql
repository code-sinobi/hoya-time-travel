-- Migration: Phase 0 Ecosystem Schema
-- Description: Adds tables for Living Stories, Wisdom Snippets, User Traits, Mentor Conversations, and Live Events.

-- 1. Living Story Sessions (Phase 1 Foundation)
CREATE TABLE IF NOT EXISTS public.living_story_sessions (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    story_id text NOT NULL,
    current_node_id text NOT NULL,
    path_taken text[] DEFAULT ARRAY[]::text[], -- Trace of node IDs
    resources jsonb DEFAULT '{"temporal_energy": 100, "cultural_insight": 0}'::jsonb,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

-- 2. Wisdom Snippets (Phase 3 Foundation)
CREATE TABLE IF NOT EXISTS public.wisdom_snippets (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
    title text,
    content text NOT NULL,
    source_culture text,
    theme text, -- Used for AI clustering
    status text DEFAULT 'submitted', -- submitted, approved, integrated
    created_at timestamp with time zone DEFAULT now()
);

-- 3. User Traits (Wisdom Compass - Phase 2 Foundation)
CREATE TABLE IF NOT EXISTS public.user_traits (
    user_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE PRIMARY KEY,
    empathy integer DEFAULT 0,
    justice integer DEFAULT 0,
    courage integer DEFAULT 0,
    wisdom integer DEFAULT 0,
    patience integer DEFAULT 0,
    updated_at timestamp with time zone DEFAULT now()
);

-- 4. Mentor Conversations (Echo - Phase 2 Foundation)
CREATE TABLE IF NOT EXISTS public.mentor_conversations (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    role text NOT NULL, -- 'user' or 'echo'
    message text NOT NULL,
    context_metadata jsonb, -- Store related story_id or trait changes
    created_at timestamp with time zone DEFAULT now()
);

-- 5. Live Events (Phase 4 Foundation)
CREATE TABLE IF NOT EXISTS public.live_events (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    title text NOT NULL,
    description text NOT NULL,
    event_type text DEFAULT 'temporal_anomaly',
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    rewards jsonb, -- { "xp": 500, "trait": "wisdom", "value": 5 }
    created_at timestamp with time zone DEFAULT now()
);

-- RLS Policies
ALTER TABLE public.living_story_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wisdom_snippets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_traits ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mentor_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.live_events ENABLE ROW LEVEL SECURITY;

-- Living Story Sessions
CREATE POLICY "Users can view own sessions" ON public.living_story_sessions
    FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own sessions" ON public.living_story_sessions
    FOR ALL USING (auth.uid() = user_id);

-- Wisdom Snippets
CREATE POLICY "Snippets are viewable by all" ON public.wisdom_snippets
    FOR SELECT USING (true);
CREATE POLICY "Users can insert snippets" ON public.wisdom_snippets
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- User Traits
CREATE POLICY "Users can view own traits" ON public.user_traits
    FOR SELECT USING (auth.uid() = user_id);

-- Mentor Conversations
CREATE POLICY "Users can view own conversations" ON public.mentor_conversations
    FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can post messages" ON public.mentor_conversations
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Live Events
CREATE POLICY "Live events are viewable by all" ON public.live_events
    FOR SELECT USING (true);

-- Functions & Triggers for Automation
-- Automatically initialize user_traits when a profile is created
CREATE OR REPLACE FUNCTION public.initialize_user_traits()
RETURNS trigger AS $$
BEGIN
    INSERT INTO public.user_traits (user_id) VALUES (new.id);
    RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_profile_created_init_traits
    AFTER INSERT ON public.profiles
    FOR EACH ROW EXECUTE PROCEDURE public.initialize_user_traits();

-- Initialize traits for existing profiles
INSERT INTO public.user_traits (user_id)
SELECT id FROM public.profiles
ON CONFLICT (user_id) DO NOTHING;
