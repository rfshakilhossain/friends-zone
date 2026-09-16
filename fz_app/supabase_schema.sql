-- ============================================================
-- FRIENDS ZONE
-- Complete Supabase Database Schema
-- Phase 1 Production Foundation
--
-- Run this entire file in:
-- Supabase Dashboard
-- -> SQL Editor
-- -> New Query
--
-- IMPORTANT:
-- This schema is designed so that server-authoritative values
-- such as FZ Tokens cannot be directly modified by the client.
-- ============================================================


-- ============================================================
-- 1. EXTENSIONS
-- ============================================================

create extension if not exists pgcrypto;


-- ============================================================
-- 2. PROFILES
-- ============================================================

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,

  email text,

  display_name text not null
    default 'Friends Zone User',

  bio text not null
    default '',

  avatar_url text,

  is_online boolean not null
    default false,

  visibility boolean not null
    default true,

  latitude double precision,

  longitude double precision,

  location_updated_at timestamptz,

  -- Legacy/server-readable balance field.
  -- Client is NOT allowed to update this column.
  tokens bigint not null
    default 0,

  -- Legacy/server-readable referral count.
  -- Client is NOT allowed to update this column.
  referral_count integer not null
    default 0,

  last_seen timestamptz,

  created_at timestamptz not null
    default now(),

  updated_at timestamptz not null
    default now()
);


-- ============================================================
-- 3. PROFILE INDEXES
-- ============================================================

create index if not exists profiles_visibility_online_idx
on public.profiles (visibility, is_online);

create index if not exists profiles_location_idx
on public.profiles (latitude, longitude);

create index if not exists profiles_last_seen_idx
on public.profiles (last_seen desc);


-- ============================================================
-- 4. FZ TOKEN LEDGER
--
-- Server-authoritative economy.
--
-- Positive amount = credit
-- Negative amount = debit
--
-- Client can READ own ledger.
-- Client cannot INSERT/UPDATE/DELETE ledger rows.
-- ============================================================

create table if not exists public.fz_token_ledger (
  id uuid primary key
    default gen_random_uuid(),

  user_id uuid not null
    references public.profiles(id)
    on delete cascade,

  amount bigint not null
    check (amount <> 0),

  reason text not null
    check (
      reason in (
        'earn',
        'spend',
        'reward',
        'referral',
        'purchase',
        'game_reward',
        'adjustment'
      )
    ),

  reference_id text,

  metadata jsonb not null
    default '{}'::jsonb,

  created_at timestamptz not null
    default now()
);


create index if not exists
fz_token_ledger_user_created_idx
on public.fz_token_ledger (
  user_id,
  created_at desc
);


create index if not exists
fz_token_ledger_reference_idx
on public.fz_token_ledger (
  reference_id
);


-- ============================================================
-- 5. SERVER-CALCULATED TOKEN BALANCE VIEW
-- ============================================================

create or replace view public.profile_token_balances
with (security_invoker = true)
as
select
  p.id,

  coalesce(
    sum(l.amount),
    0
  )::bigint as tokens

from public.profiles p

left join public.fz_token_ledger l
  on l.user_id = p.id

group by p.id;


-- ============================================================
-- 6. POSTS
-- ============================================================

create table if not exists public.posts (
  id uuid primary key
    default gen_random_uuid(),

  author_id uuid not null
    references public.profiles(id)
    on delete cascade,

  caption text not null
    default '',

  media_url text,

  created_at timestamptz not null
    default now(),

  updated_at timestamptz not null
    default now()
);


create index if not exists
posts_created_at_idx
on public.posts (
  created_at desc
);

create index if not exists
posts_author_created_idx
on public.posts (
  author_id,
  created_at desc
);


-- ============================================================
-- 7. POST LIKES
-- ============================================================

create table if not exists public.post_likes (
  post_id uuid not null
    references public.posts(id)
    on delete cascade,

  user_id uuid not null
    references public.profiles(id)
    on delete cascade,

  created_at timestamptz not null
    default now(),

  primary key (
    post_id,
    user_id
  )
);


create index if not exists
post_likes_user_idx
on public.post_likes (
  user_id
);


-- ============================================================
-- 8. POST COMMENTS
-- ============================================================

create table if not exists public.post_comments (
  id uuid primary key
    default gen_random_uuid(),

  post_id uuid not null
    references public.posts(id)
    on delete cascade,

  user_id uuid not null
    references public.profiles(id)
    on delete cascade,

  body text not null,

  created_at timestamptz not null
    default now()
);


create index if not exists
post_comments_post_created_idx
on public.post_comments (
  post_id,
  created_at
);


create index if not exists
post_comments_user_idx
on public.post_comments (
  user_id
);


-- ============================================================
-- 9. CONVERSATIONS
-- ============================================================

create table if not exists public.conversations (
  id text primary key,

  created_by uuid not null
    references public.profiles(id)
    on delete cascade,

  last_message text not null
    default '',

  updated_at timestamptz not null
    default now(),

  created_at timestamptz not null
    default now()
);


create index if not exists
conversations_updated_idx
on public.conversations (
  updated_at desc
);


-- ============================================================
-- 10. CONVERSATION MEMBERS
-- ============================================================

create table if not exists public.conversation_members (
  conversation_id text not null
    references public.conversations(id)
    on delete cascade,

  user_id uuid not null
    references public.profiles(id)
    on delete cascade,

  joined_at timestamptz not null
    default now(),

  primary key (
    conversation_id,
    user_id
  )
);


create index if not exists
conversation_members_user_idx
on public.conversation_members (
  user_id
);


create index if not exists
conversation_members_conversation_idx
on public.conversation_members (
  conversation_id
);


-- ============================================================
-- 11. MESSAGES
-- ============================================================

create table if not exists public.messages (
  id uuid primary key
    default gen_random_uuid(),

  conversation_id text not null
    references public.conversations(id)
    on delete cascade,

  sender_id uuid not null
    references public.profiles(id)
    on delete cascade,

  text text not null
    default '',

  type text not null
    default 'text'
    check (
      type in (
        'text',
        'image',
        'file',
        'voice'
      )
    ),

  media_url text,

  created_at timestamptz not null
    default now()
);


create index if not exists
messages_conversation_created_idx
on public.messages (
  conversation_id,
  created_at
);


create index if not exists
messages_sender_idx
on public.messages (
  sender_id,
  created_at desc
);


-- ============================================================
-- 12. AUTH -> PROFILE TRIGGER
--
-- Automatically creates a profile whenever a new auth user
-- is registered.
-- ============================================================

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin

  insert into public.profiles (
    id,
    email,
    display_name
  )

  values (
    new.id,

    new.email,

    coalesce(
      nullif(
        trim(
          new.raw_user_meta_data ->> 'display_name'
        ),
        ''
      ),

      nullif(
        split_part(
          coalesce(new.email, 'user'),
          '@',
          1
        ),
        ''
      ),

      'Friends Zone User'
    )
  )

  on conflict (id)
  do nothing;

  return new;

end;
$$;


drop trigger if exists
on_auth_user_created
on auth.users;


create trigger
on_auth_user_created

after insert
on auth.users

for each row

execute procedure
public.handle_new_user();


-- ============================================================
-- 13. ENABLE ROW LEVEL SECURITY
-- ============================================================

alter table public.profiles
enable row level security;

alter table public.fz_token_ledger
enable row level security;

alter table public.posts
enable row level security;

alter table public.post_likes
enable row level security;

alter table public.post_comments
enable row level security;

alter table public.conversations
enable row level security;

alter table public.conversation_members
enable row level security;

alter table public.messages
enable row level security;


-- ============================================================
-- 14. PROFILES RLS
-- ============================================================

drop policy if exists
"profiles_select_visible"
on public.profiles;


create policy
"profiles_select_visible"

on public.profiles

for select

to authenticated

using (
  visibility = true
  or id = auth.uid()
);


drop policy if exists
"profiles_insert_own"
on public.profiles;


create policy
"profiles_insert_own"

on public.profiles

for insert

to authenticated

with check (
  id = auth.uid()
);


drop policy if exists
"profiles_update_own"
on public.profiles;


create policy
"profiles_update_own"

on public.profiles

for update

to authenticated

using (
  id = auth.uid()
)

with check (
  id = auth.uid()
);


-- ============================================================
-- 15. POSTS RLS
-- ============================================================

drop policy if exists
"posts_select_authenticated"
on public.posts;


create policy
"posts_select_authenticated"

on public.posts

for select

to authenticated

using (
  true
);


drop policy if exists
"posts_insert_own"
on public.posts;


create policy
"posts_insert_own"

on public.posts

for insert

to authenticated

with check (
  author_id = auth.uid()
);


drop policy if exists
"posts_update_own"
on public.posts;


create policy
"posts_update_own"

on public.posts

for update

to authenticated

using (
  author_id = auth.uid()
)

with check (
  author_id = auth.uid()
);


drop policy if exists
"posts_delete_own"
on public.posts;


create policy
"posts_delete_own"

on public.posts

for delete

to authenticated

using (
  author_id = auth.uid()
);


-- ============================================================
-- 16. POST LIKES RLS
-- ============================================================

drop policy if exists
"likes_select_authenticated"
on public.post_likes;


create policy
"likes_select_authenticated"

on public.post_likes

for select

to authenticated

using (
  true
);


drop policy if exists
"likes_insert_own"
on public.post_likes;


create policy
"likes_insert_own"

on public.post_likes

for insert

to authenticated

with check (
  user_id = auth.uid()
);


drop policy if exists
"likes_delete_own"
on public.post_likes;


create policy
"likes_delete_own"

on public.post_likes

for delete

to authenticated

using (
  user_id = auth.uid()
);


-- ============================================================
-- 17. POST COMMENTS RLS
-- ============================================================

drop policy if exists
"comments_select_authenticated"
on public.post_comments;


create policy
"comments_select_authenticated"

on public.post_comments

for select

to authenticated

using (
  true
);


drop policy if exists
"comments_insert_own"
on public.post_comments;


create policy
"comments_insert_own"

on public.post_comments

for insert

to authenticated

with check (
  user_id = auth.uid()
);


drop policy if exists
"comments_update_own"
on public.post_comments;


create policy
"comments_update_own"

on public.post_comments

for update

to authenticated

using (
  user_id = auth.uid()
)

with check (
  user_id = auth.uid()
);


drop policy if exists
"comments_delete_own"
on public.post_comments;


create policy
"comments_delete_own"

on public.post_comments

for delete

to authenticated

using (
  user_id = auth.uid()
);


-- ============================================================
-- 18. CONVERSATIONS RLS
-- ============================================================

drop policy if exists
"conversation_select_member"
on public.conversations;


create policy
"conversation_select_member"

on public.conversations

for select

to authenticated

using (
  exists (
    select 1

    from public.conversation_members cm

    where cm.conversation_id = conversations.id

      and cm.user_id = auth.uid()
  )
);


drop policy if exists
"conversation_insert_creator"
on public.conversations;


create policy
"conversation_insert_creator"

on public.conversations

for insert

to authenticated

with check (
  created_by = auth.uid()
);


drop policy if exists
"conversation_update_member"
on public.conversations;


create policy
"conversation_update_member"

on public.conversations

for update

to authenticated

using (
  exists (
    select 1

    from public.conversation_members cm

    where cm.conversation_id = conversations.id

      and cm.user_id = auth.uid()
  )
);


-- ============================================================
-- 19. CONVERSATION MEMBERS RLS
--
-- Only conversation creator can add another member.
-- A user may add themselves only when the conversation has no
-- members yet.
-- ============================================================

drop policy if exists
"members_select_self"
on public.conversation_members;


create policy
"members_select_self"

on public.conversation_members

for select

to authenticated

using (
  user_id = auth.uid()
);


drop policy if exists
"members_insert_self"
on public.conversation_members;


drop policy if exists
"members_insert_creator_or_self"
on public.conversation_members;


create policy
"members_insert_creator_or_self"

on public.conversation_members

for insert

to authenticated

with check (

  exists (
    select 1

    from public.conversations c

    where c.id = conversation_id

      and c.created_by = auth.uid()
  )

  or (

    user_id = auth.uid()

    and not exists (
      select 1

      from public.conversation_members cm

      where cm.conversation_id = conversation_id
    )
  )
);


-- ============================================================
-- 20. MESSAGES RLS
-- ============================================================

drop policy if exists
"messages_select_member"
on public.messages;


create policy
"messages_select_member"

on public.messages

for select

to authenticated

using (

  exists (
    select 1

    from public.conversation_members cm

    where cm.conversation_id = messages.conversation_id

      and cm.user_id = auth.uid()
  )
);


drop policy if exists
"messages_insert_sender"
on public.messages;


create policy
"messages_insert_sender"

on public.messages

for insert

to authenticated

with check (

  sender_id = auth.uid()

  and exists (
    select 1

    from public.conversation_members cm

    where cm.conversation_id = messages.conversation_id

      and cm.user_id = auth.uid()
  )
);


-- ============================================================
-- 21. TOKEN LEDGER RLS
--
-- Users can see their own ledger.
-- No client-side INSERT/UPDATE/DELETE.
-- ============================================================

drop policy if exists
"token_ledger_select_own"
on public.fz_token_ledger;


create policy
"token_ledger_select_own"

on public.fz_token_ledger

for select

to authenticated

using (
  user_id = auth.uid()
);


grant select
on public.fz_token_ledger
to authenticated;


-- ============================================================
-- 22. SECURE PROFILE CREATION RPC
-- ============================================================

create or replace function public.ensure_my_profile(
  p_display_name text,
  p_email text default null,
  p_avatar_url text default null
)
returns public.profiles

language plpgsql

security definer

set search_path = public

as $$

declare
  result public.profiles;

begin

  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;


  insert into public.profiles (
    id,
    email,
    display_name,
    avatar_url
  )

  values (
    auth.uid(),

    p_email,

    coalesce(
      nullif(
        trim(p_display_name),
        ''
      ),
      'Friends Zone User'
    ),

    p_avatar_url
  )

  on conflict (id)

  do update set

    email = coalesce(
      public.profiles.email,
      excluded.email
    ),

    avatar_url = coalesce(
      public.profiles.avatar_url,
      excluded.avatar_url
    ),

    updated_at = now()

  returning *
  into result;


  return result;

end;

$$;


grant execute
on function public.ensure_my_profile(text, text, text)
to authenticated;


-- ============================================================
-- 23. SERVER-AUTHORITATIVE TOKEN BALANCE
-- ============================================================

create or replace function public.get_my_token_balance()
returns bigint

language sql

stable

security invoker

set search_path = public

as $$

  select
    coalesce(
      sum(amount),
      0
    )::bigint

  from public.fz_token_ledger

  where user_id = auth.uid();

$$;


grant execute
on function public.get_my_token_balance()
to authenticated;


-- ============================================================
-- 24. REFERRAL COUNT
-- ============================================================

create or replace function public.get_my_referral_count()
returns integer

language sql

stable

security invoker

set search_path = public

as $$

  select
    coalesce(
      referral_count,
      0
    )

  from public.profiles

  where id = auth.uid();

$$;


grant execute
on function public.get_my_referral_count()
to authenticated;


-- ============================================================
-- 25. COLUMN-LEVEL PROFILE PRIVILEGES
--
-- IMPORTANT:
-- tokens and referral_count are intentionally excluded.
-- ============================================================

grant select
on public.profiles
to authenticated;


grant insert (
  id,
  email,
  display_name,
  bio,
  avatar_url,
  is_online,
  visibility,
  latitude,
  longitude,
  location_updated_at,
  last_seen,
  updated_at
)

on public.profiles
to authenticated;


grant update (
  display_name,
  bio,
  avatar_url,
  is_online,
  visibility,
  latitude,
  longitude,
  location_updated_at,
  last_seen,
  updated_at
)

on public.profiles
to authenticated;


-- ============================================================
-- 26. DATA API PRIVILEGES
-- ============================================================

grant select, insert, update, delete
on public.posts
to authenticated;


grant select, insert, delete
on public.post_likes
to authenticated;


grant select, insert, update, delete
on public.post_comments
to authenticated;


grant select, insert, update
on public.conversations
to authenticated;


grant select, insert
on public.conversation_members
to authenticated;


grant select, insert
on public.messages
to authenticated;


-- ============================================================
-- 27. NEARBY RADAR DISCOVERY RPC
--
-- Location filtering happens on the server.
--
-- The client does NOT download every profile and filter locally.
--
-- Maximum response:
-- 100 users
-- ============================================================

create or replace function public.nearby_visible_profiles(
  p_latitude double precision,
  p_longitude double precision,
  p_radius_km double precision default 10
)

returns table (
  id uuid,
  display_name text,
  bio text,
  avatar_url text,
  is_online boolean,
  latitude double precision,
  longitude double precision,
  distance_km double precision
)

language sql

stable

security invoker

set search_path = public

as $$

  select

    p.id,

    p.display_name,

    p.bio,

    p.avatar_url,

    p.is_online,

    p.latitude,

    p.longitude,

    6371.0 * 2 * asin(
      sqrt(

        power(
          sin(
            radians(
              p.latitude - p_latitude
            ) / 2
          ),
          2
        )

        +

        cos(
          radians(p_latitude)
        )

        *

        cos(
          radians(p.latitude)
        )

        *

        power(
          sin(
            radians(
              p.longitude - p_longitude
            ) / 2
          ),
          2
        )

      )
    ) as distance_km


  from public.profiles p


  where

    p.visibility = true

    and p.id <> auth.uid()

    and p.latitude is not null

    and p.longitude is not null


    and

    6371.0 * 2 * asin(
      sqrt(

        power(
          sin(
            radians(
              p.latitude - p_latitude
            ) / 2
          ),
          2
        )

        +

        cos(
          radians(p_latitude)
        )

        *

        cos(
          radians(p.latitude)
        )

        *

        power(
          sin(
            radians(
              p.longitude - p_longitude
            ) / 2
          ),
          2
        )

      )
    )

    <= greatest(
      p_radius_km,
      0
    )


  order by distance_km asc

  limit 100;

$$;


grant execute
on function public.nearby_visible_profiles(
  double precision,
  double precision,
  double precision
)

to authenticated;


-- ============================================================
-- 28. REALTIME
-- ============================================================

do $$

begin

  begin

    alter publication supabase_realtime
    add table public.profiles;

  exception
    when duplicate_object then null;

  end;


  begin

    alter publication supabase_realtime
    add table public.posts;

  exception
    when duplicate_object then null;

  end;


  begin

    alter publication supabase_realtime
    add table public.post_likes;

  exception
    when duplicate_object then null;

  end;


  begin

    alter publication supabase_realtime
    add table public.post_comments;

  exception
    when duplicate_object then null;

  end;


  begin

    alter publication supabase_realtime
    add table public.messages;

  exception
    when duplicate_object then null;

  end;

end $$;


-- ============================================================
-- 29. PRIVATE USER STORAGE
--
-- Bucket:
-- user-files
--
-- Public URL is intentionally disabled.
--
-- Files must live under:
--
-- <user-id>/<filename>
--
-- Example:
--
-- 8f2.../avatar.png
-- ============================================================

insert into storage.buckets (
  id,
  name,
  public
)

values (
  'user-files',
  'user-files',
  false
)

on conflict (id)
do nothing;


-- ============================================================
-- 30. STORAGE SELECT POLICY
-- ============================================================

drop policy if exists
"user_files_read_own"
on storage.objects;


create policy
"user_files_read_own"

on storage.objects

for select

to authenticated

using (

  bucket_id = 'user-files'

  and
  (storage.foldername(name))[1]
  = auth.uid()::text

);


-- ============================================================
-- 31. STORAGE INSERT POLICY
-- ============================================================

drop policy if exists
"user_files_insert_own"
on storage.objects;


create policy
"user_files_insert_own"

on storage.objects

for insert

to authenticated

with check (

  bucket_id = 'user-files'

  and
  (storage.foldername(name))[1]
  = auth.uid()::text

);


-- ============================================================
-- 32. STORAGE UPDATE POLICY
-- ============================================================

drop policy if exists
"user_files_update_own"
on storage.objects;


create policy
"user_files_update_own"

on storage.objects

for update

to authenticated

using (

  bucket_id = 'user-files'

  and
  (storage.foldername(name))[1]
  = auth.uid()::text

)

with check (

  bucket_id = 'user-files'

  and
  (storage.foldername(name))[1]
  = auth.uid()::text

);


-- ============================================================
-- 33. STORAGE DELETE POLICY
-- ============================================================

drop policy if exists
"user_files_delete_own"
on storage.objects;


create policy
"user_files_delete_own"

on storage.objects

for delete

to authenticated

using (

  bucket_id = 'user-files'

  and
  (storage.foldername(name))[1]
  = auth.uid()::text

);


-- ============================================================
-- 34. FINAL NOTES
--
-- Server-authoritative:
--   - FZ token ledger
--   - token balance
--   - referral count
--
-- Protected by RLS:
--   - profiles
--   - posts
--   - likes
--   - comments
--   - conversations
--   - members
--   - messages
--   - token ledger
--   - storage
--
-- Radar:
--   - server-side distance calculation
--   - visibility filtering
--   - maximum 100 results
--
-- Realtime:
--   - profiles
--   - posts
--   - likes
--   - comments
--   - messages
--
-- This is the Phase-1 foundation.
-- Party, games, voice, verification, premium,
-- purchases, avatar, emoji, referrals and notifications
-- will receive dedicated server-authoritative tables/RPCs
-- in their respective implementation phases.
-- ============================================================
