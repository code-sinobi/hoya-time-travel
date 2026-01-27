---
description: Run Flutter tests, analysis, and code quality checks
---

# Test Workflow

Run this workflow to execute all quality checks locally before pushing.

## Quick Check (Most Common)

// turbo-all

1. Run static analysis:
```bash
flutter analyze
```

2. Check code formatting:
```bash
dart format --set-exit-if-changed .
```

3. Run all unit and widget tests:
```bash
flutter test
```

## Full Suite (Before PR)

4. Run integration tests (requires device/emulator):
```bash
flutter test integration_test
```

5. Run tests with coverage report:
```bash
flutter test --coverage
```

## Fix Formatting

If the format check fails, run this to auto-fix:
```bash
dart format .
```

## Golden Tests

Update golden files after UI changes:
```bash
flutter test --update-goldens test/design/
```
