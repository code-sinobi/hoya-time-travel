# Agent Behavior Rules (Meta-Rules)
activation: always

Defines how the Antigravity agent must behave across all tasks in the hoya_app workspace.

## Skill Activation (Agent Must Follow)

The agent **automatically activates** the appropriate skill when the user's request matches:

| User request context | Skill activated |
|---|---|
| Creating a new feature, screen, or data flow | `flutter-feature-scaffold` |
| Building any widget, screen, page, or visual UI | `flutter-mobile-design` |
| Working on state, providers, async logic | `riverpod-state` |
| Adding or changing navigation/routes | `go-router-navigation` |
| Working with Supabase queries or auth | `supabase-integration` |
| Auth flows, session management, login/logout | `supabase-auth-flow` |
| Adding models, fromJson/toJson, serialization | `json-serialization` |
| Adding animations, Lottie, typography | `ui-motion-design` |
| Debugging, testing, validating logic | `flutter-confidence-checks` |
| Project structure, file placement, refactoring | `flutter-architecture` |

**Multiple skills may activate simultaneously** if the task spans multiple domains (e.g., a new feature uses scaffold + riverpod + supabase + navigation).

## Pre-Task Checklist (Agent Must Always Do)

Before implementing any code change, the agent must:

1. **Read the relevant SKILL.md** — always `view_file` the skill before writing code.
2. **Check the existing file structure** — `list_dir` the target feature or core directory.
3. **Read related existing files** — understand what already exists before adding new code.
4. **Validate rules** — ensure the planned implementation does not violate any active rule file.

## Code Generation Mandate

Any task that touches providers or models **must** run code generation:

```bash
dart run build_runner build --delete-conflicting-outputs
```

The agent must:
1. Make the source code change.
2. Run build_runner.
3. Verify the generated files are correct.
4. Never leave the codebase in a state where source and generated files are out of sync.

## Validation After Every Change

After implementing any code change, the agent must run:

```bash
flutter analyze
```

Zero warnings/errors required before reporting completion. If analysis fails, fix the issues before finishing.

For significant logic changes, also run:
```bash
flutter test
```

## Communication Standards

- **Be concise** — no padding, no restating what the code does.
- **Explain the why** — non-obvious design decisions get a brief rationale.
- When a design decision has tradeoffs, surface them and ask for the user's preference rather than assuming.
- When multiple approaches exist, recommend one with reasoning rather than listing all options.
- Use markdown formatting in all responses.

## Prohibited Agent Behaviors

- ❌ Writing code that violates any rule in `.agent/rules/` without explicit user override.
- ❌ Placing files outside the defined architecture without explaining why.
- ❌ Leaving `TODO` or `FIXME` comments without associated tracking issues.
- ❌ Using deprecated Riverpod APIs (`StateNotifier`, `ChangeNotifier`) in new code.
- ❌ Suppressing lint errors with `// ignore:` without explanation.
- ❌ Committing changes without running `flutter analyze`.
- ❌ Leaving stale generated files uncommitted.
- ❌ Proceeding with a plan that requires user input without asking first.

## Architecture Decision Records (ADRs)

For significant architectural decisions (new packages, major refactors, pattern changes), the agent should:
1. Propose the change in a brief explanation before implementing.
2. Wait for user approval on significant architectural changes.
3. Document the decision in a comment or the implementation plan.

## Rule Override Protocol

If the user explicitly asks to deviate from a rule:
1. Acknowledge the deviation clearly.
2. Explain the implication/risk.
3. Implement with a `// RULE_OVERRIDE: <reason>` comment at the relevant code location.

## hoya_app Specific Context

- **App name**: hoya_app (package: `com.hoya.hoya_app`)
- **Design system**: MythicColors palette + EraTheme + M3
- **Backend**: Supabase (postgres + auth + storage + realtime)
- **State**: Riverpod 2.x with code generation
- **Routing**: go_router with typed routes
- **Models**: freezed + json_serializable
- **Features**: auth, splash, onboarding, home/portal, story, living_story, chronicler, explore, library, community, achievements, admin, rifts
- **Widgetbook**: Visual component catalog at `lib/widgetbook.dart`
- **CI**: GitHub Actions (analyze → test → build pipeline)
