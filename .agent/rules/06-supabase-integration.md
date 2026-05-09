# Supabase Integration Rules
activation: always

Enforces safe, performant, and secure Supabase usage in hoya_app.

## Access Boundary (Hard Rules)

- **Only the data layer** (`lib/features/<feature>/data/`) may import `supabase_flutter`.
- Widgets, providers, and domain models must **never** call `Supabase.instance` directly.
- The `service_role` key is **never** used in Flutter client code — backend/Edge Functions only.
- Always use the `anon` / `publishable` key from environment config (`AppConfig.supabaseAnonKey`).

```dart
// ✅ Correct — data layer repository
class StoryRepository {
  final SupabaseClient _client;
  StoryRepository(this._client);

  Future<List<Story>> fetchAll() async {
    final data = await _client.from('stories').select();
    return data.map(Story.fromJson).toList();
  }
}

// ❌ Wrong — widget calling Supabase directly
class StoryScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Supabase.instance.client.from('stories').select(); // NEVER
  }
}
```

## Repository Patterns

- One repository class per Supabase table or domain area.
- Repository classes are provided to the DI graph via `@riverpod`:
  ```dart
  @riverpod
  StoryRepository storyRepository(Ref ref) {
    return StoryRepository(Supabase.instance.client);
  }
  ```
- All repository methods return domain models, not raw `Map<String, dynamic>`.
- Map Supabase responses to domain models **immediately** inside the repository.
- Repository methods **never** return `dynamic` or raw JSON.

## Row Level Security (RLS)

- **Every table** in the `public` schema must have RLS enabled:
  ```sql
  ALTER TABLE <table> ENABLE ROW LEVEL SECURITY;
  ```
- Use `(SELECT auth.uid())` in policies (not bare `auth.uid()`) for performance:
  ```sql
  -- ✅ Correct
  USING (user_id = (SELECT auth.uid()))
  -- ❌ Wrong (re-evaluates per row)
  USING (user_id = auth.uid())
  ```
- Separate policies for `SELECT`, `INSERT`, `UPDATE`, `DELETE` — do not use `FOR ALL` unless justified.
- Index every column used in RLS policies (especially `user_id`).
- Never assume an empty result from Supabase means "no data" — it may mean "unauthorized" — show appropriate UI.

## Auth Session Rules

- Supabase session is the **single source of truth** for auth state.
- Expose auth state through `authSessionProvider` — never store tokens manually in SharedPreferences.
- React to auth changes via `Supabase.instance.client.auth.onAuthStateChange` stream, exposed through a Riverpod provider.
- After logout: invalidate all user-specific providers, clear cached data.

```dart
// ✅ Auth stream exposed via provider
@Riverpod(keepAlive: true)
Stream<AuthState> authStateChanges(Ref ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
}
```

## Error Handling

- Wrap every Supabase call in a try/catch that converts `PostgrestException`, `AuthException`, and `StorageException` into typed `AppException` variants.
- Never let Supabase exceptions propagate raw to the UI — always transform first.
- Log errors with the project logger (`AppLogger`), not `print()`.

```dart
// ✅ Correct error handling
Future<Story> fetchStory(String id) async {
  try {
    final data = await _client.from('stories').select().eq('id', id).single();
    return Story.fromJson(data);
  } on PostgrestException catch (e) {
    throw AppException.database(e.message, code: e.code);
  }
}
```

## Realtime Subscriptions

- Subscribe to Realtime only when the screen is active — cancel on dispose.
- Realtime subscriptions are subject to RLS — unauthorized rows will not appear in events.
- Manage subscriptions in a Riverpod `AsyncNotifier` using `ref.onDispose`.

```dart
@riverpod
class LiveStories extends _$LiveStories {
  @override
  Future<List<Story>> build() async {
    final channel = Supabase.instance.client
        .channel('stories')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'stories',
          callback: (_) => ref.invalidateSelf(),
        )
        .subscribe();

    ref.onDispose(() => Supabase.instance.client.removeChannel(channel));
    return ref.read(storyRepositoryProvider).fetchAll();
  }
}
```

## Storage Rules

- Storage bucket access only through a dedicated storage repository/service.
- Use signed URLs for private buckets — never expose bucket paths directly in UI.
- Enforce file size and MIME type validation **before** upload, not after.
- All uploaded files use paths prefixed by `auth.uid()` so RLS can enforce user ownership.

## Environment & Config

- Supabase URL and anon key loaded from `.env` via `flutter_dotenv`.
- Never hardcode Supabase credentials in source code.
- `AppConfig` class in `lib/core/config/` is the only place to read env values.
- `.env` is in `.gitignore` — commit `.env.example` with placeholder values.

## Performance

- Use `select('column1, column2')` to fetch only needed columns — avoid `select('*')` in production paths.
- Use `.limit()` and pagination for list queries — never fetch unbounded lists.
- Use `.eq()`, `.in_()`, and indexed columns in filters — avoid full-table scans.
- Prefer Supabase Edge Functions for complex server-side joins over client-side joining.

## Anti-Patterns (Never Do)

- ❌ `Supabase.instance.client` anywhere outside `data/` layer.
- ❌ Storing `service_role` key in the Flutter app.
- ❌ Tables without RLS enabled.
- ❌ `auth.uid()` without `SELECT` wrapper in RLS policies.
- ❌ Fetching unbounded `select('*')` on large tables.
- ❌ Swallowing `PostgrestException` silently.
- ❌ Realtime subscriptions that are never cancelled.
