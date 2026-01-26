---
name: json-serialization
description: Defines how to create and maintain JSON-serializable models using json_serializable. Use when adding models or APIs.
---

# JSON Serialization Skill

Standardizes model creation and code generation.

## When to use this skill

- Creating new data models
- Integrating API responses
- Persisting structured data

## Conventions

- Annotate with `@JsonSerializable`
- Keep models immutable
- Use `uuid` for IDs where needed

## File structure

- `model.dart`
- `model.g.dart` (generated)

## Rules

- Never edit generated files
- Regenerate with build_runner after changes
