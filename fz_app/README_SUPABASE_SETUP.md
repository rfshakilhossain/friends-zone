# Friends Zone — Supabase setup

This build replaces Firebase with Supabase for the Friends Zone backend.

## 1) Create the database schema

Open your Supabase Dashboard -> SQL Editor, paste the full `supabase_schema.sql`, and run it.

The SQL creates profiles, posts, likes, comments, conversations, members, messages, RLS policies, Realtime publication entries, and a private `user-files` storage bucket.

## 2) Authentication

Supabase Dashboard -> Authentication -> Providers -> Email: enable Email/Password.

For the first testing phase you can disable email confirmation if you want immediate signup/login. For production, email confirmation is recommended.

## 3) Flutter credentials

Do not put secret/service keys in the app. This app expects build-time Dart defines:

- `FZ_SUPABASE_URL`
- `FZ_SUPABASE_PUBLISHABLE_KEY`

Example local run:

```bash
flutter run \
  --dart-define=FZ_SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=FZ_SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_KEY
```

## 4) GitHub Actions secrets

Add these repository secrets:

- `FZ_SUPABASE_URL`
- `FZ_SUPABASE_PUBLISHABLE_KEY`

The workflow injects them at build time.

## Current real-time scope

This version has real Supabase authentication, profile creation, online state, GPS location publishing, realtime feed stream, post creation, likes, and realtime 1-to-1 text chat foundation.

Voice Lounge, push notifications, scalable geo-search, and server-authoritative FZ Token/referral rewards are separate production phases and are not falsely marked complete here.
