-- Create avatars bucket idempotently
INSERT INTO storage.buckets (id, name, public) 
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

-- Policy to allow anyone to read avatars
DROP POLICY IF EXISTS "Avatar images are publicly accessible." ON storage.objects;
CREATE POLICY "Avatar images are publicly accessible."
  ON storage.objects FOR SELECT
  USING ( bucket_id = 'avatars' );

-- Policy to allow authenticated users to upload their own avatar
DROP POLICY IF EXISTS "Users can upload their own avatar." ON storage.objects;
CREATE POLICY "Users can upload their own avatar."
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'avatars' AND auth.uid() = owner
  );

-- Policy to allow authenticated users to update their own avatar
DROP POLICY IF EXISTS "Users can update their own avatar." ON storage.objects;
CREATE POLICY "Users can update their own avatar."
  ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'avatars' AND auth.uid() = owner
  )
  WITH CHECK (
    bucket_id = 'avatars' AND auth.uid() = owner
  );

-- Policy to allow authenticated users to delete their own avatar
DROP POLICY IF EXISTS "Users can delete their own avatar." ON storage.objects;
CREATE POLICY "Users can delete their own avatar."
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'avatars' AND auth.uid() = owner
  );
