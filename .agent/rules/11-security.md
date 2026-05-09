# Security Rules
activation: always

Enforces security standards for hoya_app — a production Flutter + Supabase application.

## Secrets & Credentials (Critical)

- **Never** commit secrets, API keys, tokens, or passwords to source control.
- All credentials loaded from `.env` via `flutter_dotenv` — never hardcoded.
- `.env` is in `.gitignore` — only `.env.example` (with placeholder values) is committed.
- The Supabase `service_role` key is **never** used in Flutter client code — backend/Edge Functions only.
- Rotate any key that is accidentally committed immediately.

```
# .env.example (safe to commit)
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

## Authentication Security

- Session tokens managed exclusively by the Supabase SDK — never store raw JWT in SharedPreferences or local storage.
- Always validate session state server-side via RLS — do not trust client-side auth checks alone.
- Implement token refresh using Supabase's built-in session management.
- After logout: invalidate all cached user data, clear provider state, and navigate to auth screen.
- Do NOT display sensitive user data (email, full name) in URLs or route parameters.

## Input Validation

- Validate all user inputs **before** sending to Supabase.
- Sanitize inputs displayed in the UI that originate from the database (use `Text` widgets, not `HtmlWidget` with raw HTML unless explicitly reviewed).
- Email validation: use a well-tested regex or the `email_validator` package — not ad-hoc checks.
- File upload validation: check MIME type and file size **before** uploading to Supabase Storage.

```dart
// ✅ Validate before sending
if (!EmailValidator.validate(email)) {
  throw AppException.validation('Invalid email format');
}
```

## Data Exposure Rules

- Never log PII (Personally Identifiable Information) — user IDs (UUIDs) are acceptable in debug logs, but not emails, names, or phone numbers.
- Never include sensitive fields in error messages displayed to users.
- Use `debugPrint` (not `print`) and strip sensitive logs in production builds.
- Supabase Storage: private buckets for user content, public buckets only for truly public assets.

## Row Level Security (RLS) — Security Enforcement

- **Every** table in the `public` schema must have RLS enabled — this is both a performance AND security rule.
- All RLS policies must be reviewed for:
  - Correct role targeting (`TO authenticated` / `TO anon`)
  - No unintended cross-user data access
  - `WITH CHECK` on `INSERT`/`UPDATE` to prevent users writing to other users' rows
- Run Supabase security advisors after every schema migration.

## Network Security

- All Supabase communication happens over HTTPS — no HTTP endpoints.
- Certificate pinning is not required for Supabase (they manage certs), but ensure `http_client_overrides` are not bypassing SSL validation.
- Validate that no `allowInsecureConnections` or `badCertificateCallback` overrides exist in production code.

## Deep Linking Security

- Validate deep link parameters before using them in navigation or queries.
- Never use deep link parameters directly in SQL or as unvalidated route IDs.
- OAuth redirect URLs must be registered in Supabase auth settings — no wildcard redirects.

## Error Messages

- **Never** expose raw exception messages, stack traces, or Supabase error codes to end users.
- Show friendly, localized error messages — log technical details only in debug builds.
- `PostgrestException` codes can reveal table/column names — always transform to `AppException`.

```dart
// ✅ Correct
} on PostgrestException catch (e) {
  AppLogger.error('DB error: ${e.code}', e); // log internally
  throw AppException.database('Unable to load content'); // user-facing message
}
```

## Dependency Security

- Review new packages before adding — check pub.dev score, publisher verification, and last publish date.
- Run `flutter pub outdated` regularly — patch security-relevant packages promptly.
- Prefer packages from verified publishers (`dart.dev`, `flutter.dev`, `supabase.io`).
- Avoid packages with <100 pub points or no active maintenance in the past year.

## CI/CD Security

- GitHub Actions secrets used for all sensitive CI values (`SUPABASE_URL`, `SUPABASE_ANON_KEY`).
- No secrets in workflow YAML files — use `${{ secrets.NAME }}`.
- Branch protection rules on `main` — no direct pushes, require PR review.
- Auto-dismiss stale approvals on PR changes.

## Anti-Patterns (Never Do)

- ❌ Hardcoded API keys, passwords, or tokens in source code.
- ❌ `service_role` key in Flutter app.
- ❌ Tables without RLS enabled.
- ❌ Logging emails, names, or other PII.
- ❌ Displaying raw `PostgrestException` messages to users.
- ❌ Trusting client-side auth state without server-side RLS enforcement.
- ❌ `badCertificateCallback: (_,_,_) => true` in production.
- ❌ Wildcard OAuth redirect URLs.
