---
name: supabase-integration
description: Handles Supabase authentication, database access, and data flow. Use when working with backend data or auth.
---

# Supabase Integration Skill

This skill defines how the app communicates with Supabase.

## When to use this skill

- Auth flows (login, signup, logout)
- Reading or writing backend data
- Session management

## Rules

- Supabase client access only in data layer
- Never call Supabase from widgets
- Auth state exposed via Riverpod

## Data access

- One file per table or domain
- Map Supabase responses to domain models
- Handle errors explicitly

## Auth

- Session stored in memory, not widgets
- React to auth changes via provider listeners
