import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'gemini_service.g.dart';

@Riverpod(keepAlive: true)
GeminiService geminiService(Ref ref) {
  // Retrieve API Key from environment or use a placeholder
  // Run with: flutter run --dart-define=GEMINI_API_KEY=your_key_here
  const apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  if (apiKey.isEmpty) {
    debugPrint(
      'WARNING: GEMINI_API_KEY is missing. AI features will not work.',
    );
  }

  return GeminiService(apiKey);
}

class GeminiService {
  final String apiKey;
  late final GenerativeModel _model;

  GeminiService(this.apiKey) {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json', // Force JSON output
        temperature: 0.7,
      ),
    );
  }

  Future<Map<String, dynamic>> generateContent(
    String systemPrompt,
    String userPrompt,
  ) async {
    if (apiKey.isEmpty) {
      throw Exception(
        'Gemini API Key is missing. Please restart with --dart-define=GEMINI_API_KEY=...',
      );
    }

    try {
      final chat = _model.startChat(history: [Content.text(systemPrompt)]);

      final response = await chat.sendMessage(Content.text(userPrompt));
      final text = response.text;

      if (text == null) {
        throw Exception('Empty response from Gemini');
      }

      // Clean up markdown code blocks if present (though responseMimeType should handle it)
      final cleanJson = _cleanJson(text);
      return jsonDecode(cleanJson) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Gemini Error: $e');
      rethrow;
    }
  }

  String _cleanJson(String text) {
    text = text.trim();
    // Remove leading ```json or ``` with optional whitespace/newline
    text = text.replaceFirst(RegExp(r'^```(?:json)?\s*'), '');
    // Remove trailing ```
    text = text.replaceFirst(RegExp(r'\s*```$'), '');
    return text.trim();
  }
}
