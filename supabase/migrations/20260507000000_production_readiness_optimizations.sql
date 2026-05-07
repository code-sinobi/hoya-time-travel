-- ============================================================
-- Production Readiness Optimizations
-- ============================================================

-- 1. DROP duplicate index (idx_story_choices_node_id = idx_story_choices_from_node)
DROP INDEX IF EXISTS public.idx_story_choices_node_id;

-- ============================================================
-- 2. Optimize RLS policies: wrap auth.uid() in (SELECT auth.uid())
--    so PostgreSQL uses an InitPlan (single evaluation per query)
--    instead of re-evaluating for every row.
-- ============================================================

-- temporal_echoes: collapse two duplicate INSERT policies into one
DROP POLICY IF EXISTS "Users can insert own echoes" ON public.temporal_echoes;
DROP POLICY IF EXISTS "Users can earn echoes" ON public.temporal_echoes;
DROP POLICY IF EXISTS "Users can view own echoes" ON public.temporal_echoes;

CREATE POLICY "Users can insert own echoes"
  ON public.temporal_echoes FOR INSERT
  TO authenticated
  WITH CHECK (user_id = (SELECT auth.uid()));

CREATE POLICY "Users can view own echoes"
  ON public.temporal_echoes FOR SELECT
  TO authenticated
  USING (user_id = (SELECT auth.uid()));

-- user_traits
DROP POLICY IF EXISTS "Users can view own traits" ON public.user_traits;
CREATE POLICY "Users can view own traits"
  ON public.user_traits FOR SELECT
  TO authenticated
  USING (user_id = (SELECT auth.uid()));

-- user_resources
DROP POLICY IF EXISTS "Users can view own resources" ON public.user_resources;
CREATE POLICY "Users can view own resources"
  ON public.user_resources FOR SELECT
  TO authenticated
  USING (user_id = (SELECT auth.uid()));

-- user_snippets
DROP POLICY IF EXISTS "Users can create own snippets" ON public.user_snippets;
DROP POLICY IF EXISTS "Users can update own snippets" ON public.user_snippets;
DROP POLICY IF EXISTS "Users can delete own snippets" ON public.user_snippets;

CREATE POLICY "Users can create own snippets"
  ON public.user_snippets FOR INSERT
  TO authenticated
  WITH CHECK (user_id = (SELECT auth.uid()));

CREATE POLICY "Users can update own snippets"
  ON public.user_snippets FOR UPDATE
  TO authenticated
  USING (user_id = (SELECT auth.uid()));

CREATE POLICY "Users can delete own snippets"
  ON public.user_snippets FOR DELETE
  TO authenticated
  USING (user_id = (SELECT auth.uid()));

-- premise_votes
DROP POLICY IF EXISTS "Users can vote" ON public.premise_votes;
CREATE POLICY "Users can vote"
  ON public.premise_votes FOR INSERT
  TO authenticated
  WITH CHECK (user_id = (SELECT auth.uid()));

-- living_story_sessions
DROP POLICY IF EXISTS "Users can select own sessions" ON public.living_story_sessions;
DROP POLICY IF EXISTS "Users can insert own sessions" ON public.living_story_sessions;
DROP POLICY IF EXISTS "Users can update own sessions" ON public.living_story_sessions;

CREATE POLICY "Users can select own sessions"
  ON public.living_story_sessions FOR SELECT
  TO authenticated
  USING (user_id = (SELECT auth.uid()));

CREATE POLICY "Users can insert own sessions"
  ON public.living_story_sessions FOR INSERT
  TO authenticated
  WITH CHECK (user_id = (SELECT auth.uid()));

CREATE POLICY "Users can update own sessions"
  ON public.living_story_sessions FOR UPDATE
  TO authenticated
  USING (user_id = (SELECT auth.uid()));

-- ============================================================
-- 3. Harden SECURITY DEFINER functions:
--    Revoke public RPC access to internal trigger functions.
-- ============================================================
REVOKE EXECUTE ON FUNCTION public.handle_new_user() FROM anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.initialize_user_data() FROM anon, authenticated;

-- ============================================================
-- 4. Fix mutable search_path on recommend_stories.
-- ============================================================
ALTER FUNCTION public.recommend_stories(uuid, integer) SET search_path = 'public';
