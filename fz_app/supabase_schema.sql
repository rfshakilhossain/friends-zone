-- Friends Zone production foundation for Supabase.
-- Run this whole file in Supabase SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  display_name text not null default 'Friends Zone User',
  bio text not null default '',
  avatar_url text,
  is_online boolean not null default false,
  visibility boolean not null default true,
  latitude double precision,
  longitude double precision,
  location_updated_at timestamptz,
  tokens bigint not null default 0,
  referral_count integer not null default 0,
  last_seen timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  author_id uuid not null references public.profiles(id) on delete cascade,
  caption text not null default '',
  media_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.post_likes (
  post_id uuid not null references public.posts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (post_id, user_id)
);

create table if not exists public.post_comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.posts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  body text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.conversations (
  id text primary key,
  created_by uuid not null references public.profiles(id) on delete cascade,
  last_message text not null default '',
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create table if not exists public.conversation_members (
  conversation_id text not null references public.conversations(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  joined_at timestamptz not null default now(),
  primary key (conversation_id, user_id)
);

create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id text not null references public.conversations(id) on delete cascade,
  sender_id uuid not null references public.profiles(id) on delete cascade,
  text text not null default '',
  type text not null default 'text' check (type in ('text','image','file','voice')),
  media_url text,
  created_at timestamptz not null default now()
);

create index if not exists profiles_visibility_online_idx on public.profiles(visibility, is_online);
create index if not exists profiles_location_idx on public.profiles(latitude, longitude);
create index if not exists posts_created_at_idx on public.posts(created_at desc);
create index if not exists messages_conversation_created_idx on public.messages(conversation_id, created_at);

-- New auth users automatically get a profile row.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, email, display_name)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'display_name', split_part(coalesce(new.email, 'user'), '@', 1), 'Friends Zone User')
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

alter table public.profiles enable row level security;
alter table public.posts enable row level security;
alter table public.post_likes enable row level security;
alter table public.post_comments enable row level security;
alter table public.conversations enable row level security;
alter table public.conversation_members enable row level security;
alter table public.messages enable row level security;

drop policy if exists "profiles_select_visible" on public.profiles;
create policy "profiles_select_visible" on public.profiles for select to authenticated using (visibility = true or id = auth.uid());
drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own" on public.profiles for insert to authenticated with check (id = auth.uid());
drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles for update to authenticated using (id = auth.uid()) with check (id = auth.uid());

drop policy if exists "posts_select_authenticated" on public.posts;
create policy "posts_select_authenticated" on public.posts for select to authenticated using (true);
drop policy if exists "posts_insert_own" on public.posts;
create policy "posts_insert_own" on public.posts for insert to authenticated with check (author_id = auth.uid());
drop policy if exists "posts_update_own" on public.posts;
create policy "posts_update_own" on public.posts for update to authenticated using (author_id = auth.uid()) with check (author_id = auth.uid());
drop policy if exists "posts_delete_own" on public.posts;
create policy "posts_delete_own" on public.posts for delete to authenticated using (author_id = auth.uid());

drop policy if exists "likes_select_authenticated" on public.post_likes;
create policy "likes_select_authenticated" on public.post_likes for select to authenticated using (true);
drop policy if exists "likes_insert_own" on public.post_likes;
create policy "likes_insert_own" on public.post_likes for insert to authenticated with check (user_id = auth.uid());
drop policy if exists "likes_delete_own" on public.post_likes;
create policy "likes_delete_own" on public.post_likes for delete to authenticated using (user_id = auth.uid());

drop policy if exists "comments_select_authenticated" on public.post_comments;
create policy "comments_select_authenticated" on public.post_comments for select to authenticated using (true);
drop policy if exists "comments_insert_own" on public.post_comments;
create policy "comments_insert_own" on public.post_comments for insert to authenticated with check (user_id = auth.uid());
drop policy if exists "comments_update_own" on public.post_comments;
create policy "comments_update_own" on public.post_comments for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
drop policy if exists "comments_delete_own" on public.post_comments;
create policy "comments_delete_own" on public.post_comments for delete to authenticated using (user_id = auth.uid());

-- A member can read/manage only conversations they belong to.
drop policy if exists "conversation_select_member" on public.conversations;
create policy "conversation_select_member" on public.conversations for select to authenticated using (exists (select 1 from public.conversation_members cm where cm.conversation_id = id and cm.user_id = auth.uid()));
drop policy if exists "conversation_insert_creator" on public.conversations;
create policy "conversation_insert_creator" on public.conversations for insert to authenticated with check (created_by = auth.uid());
drop policy if exists "conversation_update_member" on public.conversations;
create policy "conversation_update_member" on public.conversations for update to authenticated using (exists (select 1 from public.conversation_members cm where cm.conversation_id = id and cm.user_id = auth.uid()));

drop policy if exists "members_select_self" on public.conversation_members;
create policy "members_select_self" on public.conversation_members for select to authenticated using (user_id = auth.uid());
drop policy if exists "members_insert_self" on public.conversation_members;
create policy "members_insert_self" on public.conversation_members for insert to authenticated with check (user_id = auth.uid() or exists (select 1 from public.conversations c where c.id = conversation_id and c.created_by = auth.uid()));

drop policy if exists "messages_select_member" on public.messages;
create policy "messages_select_member" on public.messages for select to authenticated using (exists (select 1 from public.conversation_members cm where cm.conversation_id = messages.conversation_id and cm.user_id = auth.uid()));
drop policy if exists "messages_insert_sender" on public.messages;
create policy "messages_insert_sender" on public.messages for insert to authenticated with check (sender_id = auth.uid() and exists (select 1 from public.conversation_members cm where cm.conversation_id = messages.conversation_id and cm.user_id = auth.uid()));

-- Data API privileges (RLS still controls row-level access).
grant select, insert, update, delete on public.profiles to authenticated;
grant select, insert, update, delete on public.posts to authenticated;
grant select, insert, delete on public.post_likes to authenticated;
grant select, insert, update, delete on public.post_comments to authenticated;
grant select, insert, update on public.conversations to authenticated;
grant select, insert on public.conversation_members to authenticated;
grant select, insert on public.messages to authenticated;

-- Realtime for social data.
do $$
begin
  begin alter publication supabase_realtime add table public.profiles; exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.posts; exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.post_likes; exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.post_comments; exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.messages; exception when duplicate_object then null; end;
end $$;

-- Private user file bucket. Client policies are scoped to the user's own folder.
insert into storage.buckets (id, name, public) values ('user-files', 'user-files', false) on conflict (id) do nothing;
drop policy if exists "user_files_read_own" on storage.objects;
create policy "user_files_read_own" on storage.objects for select to authenticated using (bucket_id = 'user-files' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "user_files_insert_own" on storage.objects;
create policy "user_files_insert_own" on storage.objects for insert to authenticated with check (bucket_id = 'user-files' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "user_files_update_own" on storage.objects;
create policy "user_files_update_own" on storage.objects for update to authenticated using (bucket_id = 'user-files' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "user_files_delete_own" on storage.objects;
create policy "user_files_delete_own" on storage.objects for delete to authenticated using (bucket_id = 'user-files' and (storage.foldername(name))[1] = auth.uid()::text);
