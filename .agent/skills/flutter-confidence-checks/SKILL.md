---
name: flutter-confidence-checks
description: Provides lightweight testing and validation practices for Flutter features. Use when adding logic-heavy code or refactoring.
---

# Flutter Confidence Checks Skill

This skill focuses on practical correctness, not exhaustive testing.

## When to use this skill

- Adding business logic
- Refactoring providers or repositories
- Touching auth or data flow

## What to test

Priority order:
1. Providers (logic)
2. Repositories (data mapping)
3. Widgets only if logic-heavy

## Provider testing

- Test notifier methods directly
- Mock repositories
- Verify state transitions

## What NOT to over-test

- Simple UI layout
- Generated code
- One-line getters

## Sanity checks (even without tests)

- Error states handled?
- Loading states visible?
- Empty states intentional?

## Goal

Confidence, not coverage.
