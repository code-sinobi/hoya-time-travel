// ignore_for_file: avoid_print
// Vocabulary Scanner for Hoya App (v2 - Smart Filtering)
// Detects sci-fi terms in USER-FACING content only.
// Ignores: generated files, code identifiers, technical exception handling.
// Run with: dart run scripts/vocabulary_scanner.dart

import 'dart:io';

/// Banned terms that break the mythology aesthetic.
/// Only flagged in UI strings and comments, NOT in code identifiers.
const Map<String, String> bannedTerms = {
  // Sci-Fi Navigation (UI Strings)
  'Sector': 'Use "Archive" or "Region" instead',
  'Warp': 'Use "Journey" or "Traverse" instead',
  'Galaxy': 'Use "Cosmos" or "Realm" instead',
  'Scanning': 'Use "Divining" or "Searching" instead',
  'Download': 'Use "Transcribe" or "Record" instead',
  'Upload': 'Use "Inscribe" or "Commit" instead',
  'Terminal': 'Use "Altar" or "Sanctum" instead',
  'Server': 'Use "Oracle" or "Keeper" instead',
  'Protocol': 'Use "Rite" or "Ritual" instead',
  'Algorithm': 'Use "Formula" or "Incantation" instead',

  // Neon/Sci-Fi Colors (in strings/variable names)
  'neon': 'Neon aesthetic is banned. Use warm, ancient tones.',
  'cyber': 'Cyberpunk aesthetic is banned.',
  'hologram': 'Use "apparition" or "vision" instead',
};

/// Terms that are only violations in UI strings (quotes), not code identifiers.
const Map<String, String> uiOnlyTerms = {
  'Loading': 'Use "Summoning" or "Awakening" instead',
  'Settings': 'Use "Rituals" or "Preferences" instead',
  'Login': 'Use "Enter" or "Arrive" instead',
  'Logout': 'Use "Depart" or "Sever Link" instead',
  'Notification': 'Use "Omen" or "Whisper" instead',
};

/// Files to exclude from scanning
bool shouldExclude(String path) {
  // Skip generated files
  if (path.endsWith('.g.dart')) return true;
  if (path.endsWith('.freezed.dart')) return true;

  // Skip test files
  if (path.contains('test\\') || path.contains('test/')) return true;

  // Skip scripts
  if (path.contains('scripts\\') || path.contains('scripts/')) return true;

  // Skip asset directories - internal filenames don't need vocabulary checks
  if (path.contains('assets\\') || path.contains('assets/')) return true;

  return false;
}

/// Check if a line is a UI-facing string (contains quotes with the term)
bool isInUIString(String line, String term) {
  // Check if term appears inside a quoted string
  final singleQuotePattern = RegExp(
    "'[^']*${term.toLowerCase()}[^']*'",
    caseSensitive: false,
  );
  final doubleQuotePattern = RegExp(
    '"[^"]*${term.toLowerCase()}[^"]*"',
    caseSensitive: false,
  );

  return singleQuotePattern.hasMatch(line) || doubleQuotePattern.hasMatch(line);
}

/// Files to scan (Dart source files in lib/)
Future<List<File>> getSourceFiles(String path) async {
  final dir = Directory(path);
  final files = <File>[];

  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      if (!shouldExclude(entity.path)) {
        files.add(entity);
      }
    }
  }

  return files;
}

/// Scan a single file for banned terms
Future<List<String>> scanFile(File file) async {
  final violations = <String>[];
  final content = await file.readAsString();
  final lines = content.split('\n');

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    final lineNumber = i + 1;

    // Skip import statements
    if (line.trimLeft().startsWith('import')) continue;

    // Skip class/function declarations (code identifiers)
    if (line.trimLeft().startsWith('class ')) continue;
    if (line.trimLeft().startsWith('abstract class ')) continue;
    if (line.contains('extends ') || line.contains('implements ')) continue;

    // Check always-banned terms
    for (final entry in bannedTerms.entries) {
      if (line.toLowerCase().contains(entry.key.toLowerCase())) {
        violations.add(
          '${file.path}:$lineNumber - Found "${entry.key}". ${entry.value}',
        );
      }
    }

    // Check UI-only terms (only if in quoted strings)
    for (final entry in uiOnlyTerms.entries) {
      if (isInUIString(line, entry.key)) {
        violations.add(
          '${file.path}:$lineNumber - Found "${entry.key}" in UI string. ${entry.value}',
        );
      }
    }
  }

  return violations;
}

void main() async {
  print('🔍 Hoya Vocabulary Scanner v2 (Smart Filtering)');
  print('=' * 50);
  print('Scanning for sci-fi terms in UI-facing content...\n');
  print('Note: Ignoring generated files (.g.dart), code identifiers,');
  print('      and technical terms (Error, User, Profile in code).\n');

  final libPath = 'lib';
  final files = await getSourceFiles(libPath);

  print('Scanning ${files.length} Dart files...\n');

  final allViolations = <String>[];

  for (final file in files) {
    final violations = await scanFile(file);
    allViolations.addAll(violations);
  }

  if (allViolations.isEmpty) {
    print('✅ No vocabulary violations found!');
    print('   Your UI content adheres to the Mythic Design Language.');
    exit(0);
  } else {
    print('⚠️  Found ${allViolations.length} vocabulary violations:\n');
    for (final v in allViolations) {
      print('  ❌ $v');
    }
    print('\n📜 Suggestion: Replace these terms with mythology equivalents.');
    print(
      '   Focus on user-visible strings (button labels, headers, messages).',
    );
    exit(1);
  }
}
