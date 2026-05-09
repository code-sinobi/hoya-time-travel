# CI/CD & Git Workflow Rules
activation: always

Enforces branching strategy, commit hygiene, and CI gate requirements for hoya_app.

## Branching Strategy

```
main          ← Production-ready. Protected. No direct pushes.
develop       ← Integration branch. All feature PRs target here.
feature/*     ← New features (e.g., feature/living-story-editor)
fix/*         ← Bug fixes (e.g., fix/auth-redirect-loop)
chore/*       ← Non-functional changes (e.g., chore/update-dependencies)
release/*     ← Release prep branches (e.g., release/1.2.0)
```

- **Never push directly to `main`** — all changes via PR.
- Feature branches branch from `develop`, merge back to `develop`.
- Hotfixes branch from `main`, merge to both `main` and `develop`.

## Commit Message Format (Conventional Commits)

```
<type>(<scope>): <short description>

[optional body]

[optional footer: BREAKING CHANGE, Fixes #issue]
```

**Types:**
| Type | When |
|---|---|
| `feat` | New feature |
| `fix` | Bug fix |
| `chore` | Build process, dependency update, config |
| `refactor` | Code change with no feature/fix |
| `test` | Adding or fixing tests |
| `docs` | Documentation only |
| `style` | Formatting, no logic change |
| `perf` | Performance improvement |
| `ci` | CI/CD pipeline changes |

**Examples:**
```
feat(story): add living story real-time collaboration
fix(auth): resolve redirect loop on session expiry
chore(deps): upgrade supabase_flutter to 2.12.0
test(riverpod): add unit tests for auth notifier
```

- Subject line: **max 72 characters**, imperative mood ("add" not "added").
- No period at the end of the subject.
- Body: explain *why*, not *what* (the diff shows what).

## Pull Request Rules

- Every PR must have a **description** explaining: what changed, why, and how to test.
- PR title follows Conventional Commits format.
- Link to related issue: `Fixes #123` or `Relates to #456`.
- All CI checks must pass before merge:
  - `flutter analyze --fatal-infos`
  - `flutter test`
  - Build check (debug APK / IPA)
- Minimum **1 reviewer approval** required.
- No self-merging.
- Squash merge into `develop` to keep history clean.

## CI Pipeline Requirements

The GitHub Actions pipeline must pass before any merge:

1. **Static Analysis**: `flutter analyze --fatal-infos` — zero warnings.
2. **Tests**: `flutter test` — all tests green.
3. **Build**: `flutter build apk --debug` — build succeeds.
4. **Code Generation Check**: Verify no dirty generated files exist.

```yaml
# Required checks in branch protection:
# - analyze
# - test
# - build
```

## Generated File Policy

- **Always commit** `*.g.dart` and `*.freezed.dart` files.
- Run `dart run build_runner build -d` before every commit that touches model or provider files.
- CI should verify generated files are up to date (compare git diff after generation).

## Dependency Management

- Use exact versions for critical packages in `pubspec.yaml` — avoid floating `^` on packages that break APIs frequently.
- Use `^` for packages with strict semver compliance (dart core, flutter, google_fonts).
- Run `flutter pub upgrade --major-versions` only in a dedicated chore branch, not in feature branches.
- Review `pubspec.lock` on every dependency update PR.

## Release Process

1. Create `release/x.y.z` branch from `develop`.
2. Bump version in `pubspec.yaml` (`version: x.y.z+buildNumber`).
3. Update `CHANGELOG.md`.
4. PR to `main` with sign-off.
5. Tag `main` with `vx.y.z` after merge.
6. Merge `main` back into `develop`.

## Anti-Patterns (Never Do)

- ❌ Force-pushing to `main` or `develop`.
- ❌ Merging with failing CI checks.
- ❌ Commit messages like "fix stuff", "wip", "asdf".
- ❌ Committing `*.g.dart` files that are out of sync with their source.
- ❌ Committing `.env` files with real credentials.
- ❌ `node_modules`, `build/`, `.dart_tool/` in the repository.
- ❌ Large binary files (images > 500KB, videos) committed to the repo — use assets pipeline or cloud storage.
