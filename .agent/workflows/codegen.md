---
description: Run code generation for Riverpod and JSON serialization
---

# Code Generation Workflow

This app uses code generation for:
- Riverpod providers (`@riverpod` annotations)
- JSON serialization (`@JsonSerializable` annotations)

## When to run

Run code generation when you modify any file with:
- `@riverpod` annotations
- `@JsonSerializable` annotations  
- Any `.dart` file with `part '*.g.dart'`

## Commands

### One-time generation
// turbo
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Watch mode (continuous generation)
```bash
flutter pub run build_runner watch
```

### Clean previous builds
```bash
flutter pub run build_runner clean
```

## Troubleshooting

If you see errors about conflicting outputs:
1. Delete all `*.g.dart` files manually, or
2. Use the `--delete-conflicting-outputs` flag

If build_runner seems stuck:
1. Stop the process (Ctrl+C)
2. Run `flutter clean`
3. Run `flutter pub get`
4. Try generation again
