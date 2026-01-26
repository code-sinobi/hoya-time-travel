-- Create a table for public profiles
create table if not exists profiles (
  id uuid references auth.users on delete cascade not null primary key,
  username text,
  avatar_url text,
  xp integer default 0,
  level integer default 1,
  updated_at timestamp with time zone,

  constraint username_length check (char_length(username) >= 3)
);

-- Set up Row Level Security (RLS)
alter table profiles enable row level security;

create policy "Public profiles are viewable by everyone."
  on profiles for select
  using ( true );

create policy "Users can insert their own profile."
  on profiles for insert
  with check ( auth.uid() = id );

create policy "Users can update own profile."
  on profiles for update
  using ( auth.uid() = id );

-- Create a table for user progress on stories
create table if not exists user_progress (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references profiles(id) on delete cascade not null,
  story_id text not null, -- Matches the ID in story_library.dart
  current_node_id text,
  is_completed boolean default false,
  last_played_at timestamp with time zone default now(),
  
  unique(user_id, story_id)
);

alter table user_progress enable row level security;

create policy "Users can view own progress."
  on user_progress for select
  using ( auth.uid() = user_id );

create policy "Users can insert own progress."
  on user_progress for insert
  with check ( auth.uid() = user_id );

create policy "Users can update own progress."
  on user_progress for update
  using ( auth.uid() = user_id );

-- Function to handle new user signup
create or replace function public.handle_new_user() 
returns trigger as $$
begin
  insert into public.profiles (id, username, avatar_url)
  values (new.id, new.raw_user_meta_data->>'username', new.raw_user_meta_data->>'avatar_url');
  return new;
end;
$$ language plpgsql security definer;

-- Trigger the function every time a user is created
-- Drop if exists to avoid error on repeated runs
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
