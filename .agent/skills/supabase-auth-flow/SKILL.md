---
name: supabase-auth-flow
description: Manages authentication, session state, and auth-based routing using Supabase, Riverpod, and go_router.
---

# Supabase Auth Flow Skill

This skill defines how authentication and session state are handled.

## When to use this skill

- Login / signup screens
- Protecting routes
- Reacting to auth changes

## Auth state source of truth

- Supabase session is the single source
- Expose auth state via a Riverpod provider
- UI never reads Supabase directly

## Required providers

- `authSessionProvider`
- `currentUserProvider`

## Routing integration

- go_router listens to auth provider
- Redirect logic lives in router, not widgets
- Avoid imperative navigation after login

## Login/logout rules

- Login updates Supabase only
- State updates propagate automatically
- Logout clears session and cached data

## Anti-patterns

- Checking auth in `build()`
- Storing session in SharedPreferences manually
- Calling `context.go()` from providers
